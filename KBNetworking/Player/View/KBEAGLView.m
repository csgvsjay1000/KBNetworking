//
//  KBEAGLView.m
//  VRShow
//
//  Created by chengshenggen on 8/26/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "KBEAGLView.h"
#import <GLKit/GLKit.h>
#import "GLProgram.h"
#import "Constants.h"

typedef NS_ENUM(NSUInteger,PreShowViewFlag) {
    PreShowViewFlag_VRTag = 0,
    PreShowViewFlag_VRList = 1,
};


#define ES_PI  (3.14159265f)
#define ROLL_CORRECTION ES_PI/2.0

@interface KBEAGLView (){
    CGSize sizeInPixels;
    EAGLContext *context;
    GLuint displayRenderbuffer, displayFramebuffer,_depthRenderBuffer;
    
    GLProgram *normalProgram;  //普通视图shader
    GLProgram *panaProgram;  //全景视图shader

    GLuint VBO, VAO, EBO;
    GLuint VBO_Texture;

    CVOpenGLESTextureRef _lumaTexture;
    CVOpenGLESTextureRef _chromaTexture;
    CVOpenGLESTextureCacheRef _videoTextureCache;
    
    GLProgram *currentProgram;
    int _numIndices;
    
    GLfloat *vVertices;
    GLfloat *vTextCoord;
    GLushort *indices;
    
    BOOL isUp;
    GLfloat preDress;
    
    GLKVector3 cameraPos;
    GLKVector3 cameraFront;
    GLKVector3 cameraUp;
    BOOL _notUseMotion;

}

@end

@implementation KBEAGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self setupGL];
        [self addSubview:self.playerBackgroundView];
        [self layoutSubPages];
    }
    return self;
}


-(void)layoutSubPages{
    [_playerBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@210);
    }];
}
-(void)dealloc{
    [self tearDownGL];
    NSLog(@"%@ dealloc",[self class]);
}

-(void)layoutSubviews{
    
    if (self.bounds.size.width>0) {
        @synchronized (self) {
            [self destroyDisplayFramebuffer];
            [self createDisplayFramebuffer];
            glViewport(0, 0, sizeInPixels.width, sizeInPixels.height);
        }
    }
    
    
}

#pragma mark - setupGL
-(void)setupGL{
    self.opaque = YES;
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    if (!_videoTextureCache) {
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, context, NULL, &_videoTextureCache);
        if (err != noErr) {
            NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
            return;
        }
    }
    
    cameraPos = GLKVector3Make(0, 0, 0);
    cameraFront = GLKVector3Make(0, 0, -1);
    cameraUp = GLKVector3Make(0.0f, 1.0f,  0.0f);
}

-(void)tearDownGL{
    [self cleanUpTextures];
    
    if(_videoTextureCache) {
        CFRelease(_videoTextureCache);
    }
    if (context == [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:nil];
        context = nil;
    }
    
}

-(void)wait:(BOOL)value{
    if (value) {
        self.playerBackgroundView.hidden = NO;
        [self.playerBackgroundView.loadingImageView startAnimating];
    }else{
        self.playerBackgroundView.hidden = YES;
        [self.playerBackgroundView.loadingImageView stopAnimating];
    }
}

#pragma mark - public method
-(void)setPlayerLocation:(KBPlayerLocation)playerLocation andVideoType:(VideoType)videoType{
    [EAGLContext setCurrentContext:context];

    [self destoryVertex];
    
    
    
    [self loadNormalShader];
    [self loadPanoShader];

    if (videoType == VideoType_Normal || videoType == VideoType_3D || videoType == VideoType_updown_3D) {
        currentProgram = normalProgram;
    }else{
        currentProgram = panaProgram;
    }
    
    [currentProgram use];
    
    
    int numVertices = 0;
    
    
    glGenVertexArraysOES(1, &VAO);
    glBindVertexArrayOES(VAO);
    
    if (videoType == VideoType_360 || videoType == VideoType_updown_360) {
        _numIndices =  esGenSphere_3(200, 1.0f, &vVertices,  NULL,&vTextCoord, &indices, &numVertices,playerLocation);
        
        // Vertex
        glGenBuffers(1, &VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER,
                     numVertices*3*sizeof(GLfloat),
                     vVertices,
                     GL_STATIC_DRAW);
        glEnableVertexAttribArray([currentProgram attributeIndex:@"position"]);
        glVertexAttribPointer([currentProgram attributeIndex:@"position"],
                              3,
                              GL_FLOAT,
                              GL_FALSE,
                              sizeof(GLfloat) * 3,
                              NULL);
        //            glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        // Texture Coordinates
        glGenBuffers(1, &VBO_Texture);
        glBindBuffer(GL_ARRAY_BUFFER, VBO_Texture);
        glBufferData(GL_ARRAY_BUFFER,
                     numVertices*2*sizeof(GLfloat),
                     vTextCoord,
                     GL_DYNAMIC_DRAW);
        glEnableVertexAttribArray([currentProgram attributeIndex:@"texCoord"]);
        glVertexAttribPointer([currentProgram attributeIndex:@"texCoord"],
                              2,
                              GL_FLOAT,
                              GL_FALSE,
                              sizeof(GLfloat) * 2,
                              NULL);
        //            glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        //Indices
        glGenBuffers(1, &EBO);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                     sizeof(GLushort) * _numIndices,
                     indices, GL_STATIC_DRAW);
        //            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
        free(vVertices);
        free(vTextCoord);
        free(indices);
    }
    
    if (videoType == VideoType_Normal || videoType == VideoType_3D) {
        GLfloat vertices[] = {
            -1.0f, 1.f, 0,
            1.0f, 1.f, 0,
            1.f,  -1.f, 0,
            -1.f,  -1.f, 0,
        };
        
        glGenBuffers(1, &VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
        
        glVertexAttribPointer([currentProgram attributeIndex:@"position"], 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid*)0);
        glEnableVertexAttribArray([currentProgram attributeIndex:@"position"]);
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        if (playerLocation == KBPlayerLocationNone) {
            GLfloat textures[] = {
                0.0f, 0.0f,
                1.0f, 0.0f,
                1.0f, 1.0f,
                0.0f, 1.0f,
            };
            glGenBuffers(1, &VBO_Texture);
            glBindBuffer(GL_ARRAY_BUFFER, VBO_Texture);
            glBufferData(GL_ARRAY_BUFFER, sizeof(textures), textures, GL_STATIC_DRAW);
            glVertexAttribPointer([currentProgram attributeIndex:@"texCoord"], 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), (GLvoid*)0);
            glEnableVertexAttribArray([currentProgram attributeIndex:@"texCoord"]);
            glBindBuffer(GL_ARRAY_BUFFER, 0);
        }else if (playerLocation == KBPlayerLocationLeft) {
            GLfloat textures[] = {
                0.0f, 0.0f,
                 0.5f, 0.0f,
                 0.5f, 1.0f,
                 0.0f, 1.0f,
            };
            glGenBuffers(1, &VBO_Texture);
            glBindBuffer(GL_ARRAY_BUFFER, VBO_Texture);
            glBufferData(GL_ARRAY_BUFFER, sizeof(textures), textures, GL_STATIC_DRAW);
            glVertexAttribPointer([currentProgram attributeIndex:@"texCoord"], 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), (GLvoid*)0);
            glEnableVertexAttribArray([currentProgram attributeIndex:@"texCoord"]);
            glBindBuffer(GL_ARRAY_BUFFER, 0);
        }else if (playerLocation == KBPlayerLocationRight) {
            GLfloat textures[] = {
                0.5f, 0.0f,
                1.0f, 0.0f,
                1.0f, 1.0f,
                0.5f, 1.0f,
            };
            glGenBuffers(1, &VBO_Texture);
            glBindBuffer(GL_ARRAY_BUFFER, VBO_Texture);
            glBufferData(GL_ARRAY_BUFFER, sizeof(textures), textures, GL_STATIC_DRAW);
            glVertexAttribPointer([currentProgram attributeIndex:@"texCoord"], 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), (GLvoid*)0);
            glEnableVertexAttribArray([currentProgram attributeIndex:@"texCoord"]);
            glBindBuffer(GL_ARRAY_BUFFER, 0);
        }
        
        
    }
    
    glBindVertexArrayOES(0);

    _playerLocation = playerLocation;
    _videoType = videoType;
    
    
}
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer{
    [EAGLContext setCurrentContext:context];
    
    glClearColor(0.0f, 0, 0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    [self bindTexture:pixelBuffer];
    
    [self presentFramebuffer];
    
}

-(void)bindTexture:(CVPixelBufferRef)pixelBuffer{
    CVReturn err;
    if (pixelBuffer != NULL) {
        glBindVertexArrayOES(VAO);

        int frameWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
        int frameHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
        
        if (!_videoTextureCache) {
            NSLog(@"No video texture cache");
            return;
        }
        
        [self cleanUpTextures];
        glActiveTexture(GL_TEXTURE0);
        err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                           _videoTextureCache,
                                                           pixelBuffer,
                                                           NULL,
                                                           GL_TEXTURE_2D,
                                                           GL_RED_EXT,
                                                           frameWidth,
                                                           frameHeight,
                                                           GL_RED_EXT,
                                                           GL_UNSIGNED_BYTE,
                                                           0,
                                                           &_lumaTexture);
        if (err) {
            NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
        }
        
        glBindTexture(CVOpenGLESTextureGetTarget(_lumaTexture), CVOpenGLESTextureGetName(_lumaTexture));
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        // UV-plane.
        glActiveTexture(GL_TEXTURE1);
        err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                           _videoTextureCache,
                                                           pixelBuffer,
                                                           NULL,
                                                           GL_TEXTURE_2D,
                                                           GL_RG_EXT,
                                                           frameWidth / 2,
                                                           frameHeight / 2,
                                                           GL_RG_EXT,
                                                           GL_UNSIGNED_BYTE,
                                                           1,
                                                           &_chromaTexture);
        if (err) {
            NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
        }
        
        glBindTexture(CVOpenGLESTextureGetTarget(_chromaTexture), CVOpenGLESTextureGetName(_chromaTexture));
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        
//        glBindVertexArrayOES(VAO);
        if (_videoType == VideoType_360 || _videoType == VideoType_updown_360) {
            
            
            GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
            modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 300.0, 300.0, 300.0);
            CMDeviceMotion *d = _motionManager.deviceMotion;
            CMAttitude *attitude = d.attitude;
            //
            double cRoll = -fabs(attitude.roll); // Up/Down en landscape
            double cYaw = attitude.yaw;  // Left/ Right en landscape -> pas
            float aspect = fabs(self.bounds.size.width / self.bounds.size.height);
            GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85), aspect, 0.1f, 400.0f);
            
            if (!self.isLandScape) {
                projectionMatrix = GLKMatrix4Rotate(projectionMatrix, ES_PI, 1.0f, 0.0f, 0.0f);
                
                double temRoll = attitude.roll+attitude.yaw;

                modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix,temRoll); // Up/Down axis

                modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, ROLL_CORRECTION);

            }else{
                
                
                projectionMatrix = GLKMatrix4Rotate(projectionMatrix, ES_PI, 1.0f, 0.0f, 0.0f);
                
                if (_notUseMotion) {
                    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, 0);
                    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, 0);
                }else{
                    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, cRoll); // Up/Down axis
                    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, ROLL_CORRECTION);
                    //
                    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, cYaw);
                    
                }

                
            }
            GLKMatrix4 _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
            glUniformMatrix4fv([panaProgram uniformIndex:@"modelViewProjectionMatrix"], 1, 0, _modelViewProjectionMatrix.m);

            glDrawElements ( GL_TRIANGLES, _numIndices,GL_UNSIGNED_SHORT, 0 );
            
            
        }else{
            glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
        }
        glBindVertexArrayOES(0);
        
        
    }
}

- (void)presentFramebuffer{
    glBindRenderbuffer(GL_RENDERBUFFER, displayRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - private method

- (void)cleanUpTextures
{
    if (_lumaTexture) {
        CFRelease(_lumaTexture);
        _lumaTexture = NULL;
    }
    
    if (_chromaTexture) {
        CFRelease(_chromaTexture);
        _chromaTexture = NULL;
    }
    
    // Periodic texture cache flush every frame
    CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
}

-(void)destoryVertex{
    glBindVertexArrayOES(0);
    if (VAO) {
        glDeleteVertexArraysOES(1,&VAO);
    }
    if (VBO) {
        glDeleteBuffers(1, &VBO);
    }
    if (VBO_Texture) {
        glDeleteBuffers(1, &VBO_Texture);
    }
    if (EBO) {
        glDeleteBuffers(1, &EBO);

    }
}

-(void)loadNormalShader{
    if (normalProgram) {
        return;
    }
    normalProgram = [[GLProgram alloc] initWithVertexShaderFilename:@"Shader" fragmentShaderFilename:@"Shader"];
    if (!normalProgram.initialized)
    {
        [normalProgram addAttribute:@"position"];
        [normalProgram addAttribute:@"texCoord"];

        if (![normalProgram link])
        {
            NSString *progLog = [normalProgram programLog];
            NSLog(@"Program link log: %@", progLog);
            NSString *fragLog = [normalProgram fragmentShaderLog];
            NSLog(@"Fragment shader compile log: %@", fragLog);
            NSString *vertLog = [normalProgram vertexShaderLog];
            NSLog(@"Vertex shader compile log: %@", vertLog);
            normalProgram = nil;
            NSAssert(NO, @"Filter shader link failed");
        }
    }
    
    [normalProgram use];
    glUniform1i([normalProgram uniformIndex:@"SamplerY"], 0);
    glUniform1i([normalProgram uniformIndex:@"SamplerUV"], 1);
    // BT.709, which is the standard for HDTV.
    const GLfloat kColorConversion709[] = {
        1.164,  1.164, 1.164,
        0.0, -0.213, 2.112,
        1.793, -0.533,   0.0,
    };
    
    glUniformMatrix3fv([normalProgram uniformIndex:@"colorConversionMatrix"], 1, GL_FALSE, kColorConversion709);
    
}

-(void)loadPanoShader{
    if (panaProgram) {
        return;
    }
    panaProgram = [[GLProgram alloc] initWithVertexShaderFilename:@"PanormalShader" fragmentShaderFilename:@"PanormalShader"];
    if (!panaProgram.initialized)
    {
        [panaProgram addAttribute:@"position"];
        [panaProgram addAttribute:@"texCoord"];
        
        if (![panaProgram link])
        {
            NSString *progLog = [panaProgram programLog];
            NSLog(@"Program link log: %@", progLog);
            NSString *fragLog = [panaProgram fragmentShaderLog];
            NSLog(@"Fragment shader compile log: %@", fragLog);
            NSString *vertLog = [panaProgram vertexShaderLog];
            NSLog(@"Vertex shader compile log: %@", vertLog);
            panaProgram = nil;
            NSAssert(NO, @"Filter shader link failed");
        }
    }
    
    [panaProgram use];
    glUniform1i([panaProgram uniformIndex:@"SamplerY"], 0);
    glUniform1i([panaProgram uniformIndex:@"SamplerUV"], 1);
    // BT.709, which is the standard for HDTV.
    const GLfloat kColorConversion709[] = {
        1.164,  1.164, 1.164,
        0.0, -0.213, 2.112,
        1.793, -0.533,   0.0,
    };
    
    glUniformMatrix3fv([panaProgram uniformIndex:@"colorConversionMatrix"], 1, GL_FALSE, kColorConversion709);
    
}


#pragma mark - Framebuffer
- (void)createDisplayFramebuffer{
    [EAGLContext setCurrentContext:context];
    
    glGenRenderbuffers(1, &displayRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, displayRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    
    GLint backingWidth, backingHeight;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    sizeInPixels.width = (CGFloat)backingWidth;
    sizeInPixels.height = (CGFloat)backingHeight;
    
    glGenFramebuffers(1, &displayFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, displayFramebuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, displayRenderbuffer);
    
    __unused GLuint framebufferCreationStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    NSAssert(framebufferCreationStatus == GL_FRAMEBUFFER_COMPLETE, @"Failure with display framebuffer generation for display of size: %f, %f", self.bounds.size.width, self.bounds.size.height);
    
}

- (void)destroyDisplayFramebuffer;
{
    [EAGLContext setCurrentContext:context];
    
    if (displayFramebuffer)
    {
        glDeleteFramebuffers(1, &displayFramebuffer);
        displayFramebuffer = 0;
    }
    
    if (displayRenderbuffer)
    {
        glDeleteRenderbuffers(1, &displayRenderbuffer);
        displayRenderbuffer = 0;
    }
    
}

#pragma mark generate sphere

int esGenSphere_3 ( int numSlices, float radius, float **vertices, float **normals,
                 float **texCoords, uint16_t **indices, int *numVertices_out,int videoType) {
    int i;
    int j;
    int numParallels = numSlices / 2;
    int numVertices = ( numParallels + 1 ) * ( numSlices + 1 );
    int numIndices = numParallels * numSlices * 6;
    
    float angleStep = (2.0f * ES_PI) / ((float) numSlices);
    
    if ( vertices != NULL )
        *vertices = malloc ( sizeof(float) * 3 * numVertices );
    
    // Pas besoin des normals pour l'instant
    //    if ( normals != NULL )
    //        *normals = malloc ( sizeof(float) * 3 * numVertices );
    
    if ( texCoords != NULL )
        *texCoords = malloc ( sizeof(float) * 2 * numVertices );
    
    if ( indices != NULL )
        *indices = malloc ( sizeof(uint16_t) * numIndices );
    
    for ( i = 0; i < numParallels + 1; i++ ) {
        for ( j = 0; j < numSlices + 1; j++ ) {
            int vertex = ( i * (numSlices + 1) + j ) * 3;
            
            if ( vertices ) {
                (*vertices)[vertex + 0] = radius * sinf ( angleStep * (float)i ) *
                sinf ( angleStep * (float)j );
                (*vertices)[vertex + 1] = radius * cosf ( angleStep * (float)i );
                (*vertices)[vertex + 2] = radius * sinf ( angleStep * (float)i ) *
                cosf ( angleStep * (float)j );
            }
            
            if (texCoords) {
                int texIndex = ( i * (numSlices + 1) + j ) * 2;
                if (videoType == KBPlayerLocationNone) {
                    (*texCoords)[texIndex + 0] = (float) j / (float) numSlices;
                    (*texCoords)[texIndex + 1] = 1.0f - ((float) i / (float) (numParallels));
                    
                }else if (videoType == KBPlayerLocationLeft){
                    (*texCoords)[texIndex + 0] = (float) j / (float) numSlices;
                    (*texCoords)[texIndex + 1] = (1.0f - ((float) i / (float) (numParallels)))/2;
                }else if (videoType == KBPlayerLocationRight){
                    (*texCoords)[texIndex + 0] = (float) j / (float) numSlices;
                    (*texCoords)[texIndex + 1] = (1.0f - ((float) i / (float) (numParallels)))/2+0.5f;
                }
                
            }
        }
    }
    
    // Generate the indices
    if ( indices != NULL ) {
        uint16_t *indexBuf = (*indices);
        for ( i = 0; i < numParallels ; i++ ) {
            for ( j = 0; j < numSlices; j++ ) {
                *indexBuf++  = i * ( numSlices + 1 ) + j;
                *indexBuf++ = ( i + 1 ) * ( numSlices + 1 ) + j;
                *indexBuf++ = ( i + 1 ) * ( numSlices + 1 ) + ( j + 1 );
                
                *indexBuf++ = i * ( numSlices + 1 ) + j;
                *indexBuf++ = ( i + 1 ) * ( numSlices + 1 ) + ( j + 1 );
                *indexBuf++ = i * ( numSlices + 1 ) + ( j + 1 );
            }
        }
    }
    
    if (numVertices_out) {
        *numVertices_out = numVertices;
    }
    
    return numIndices;
}

#pragma mark - setters and getters

-(void)notUseMotion:(BOOL)use{
    _notUseMotion = use;
}

-(PlayerBackgroundView *)playerBackgroundView{
    if (_playerBackgroundView == nil) {
        _playerBackgroundView = [[PlayerBackgroundView alloc] init];
        _playerBackgroundView.hidden = YES;
    }
    return _playerBackgroundView;
}

@end
