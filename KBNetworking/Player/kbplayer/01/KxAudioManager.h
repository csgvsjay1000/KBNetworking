//
//  KxAudioManager.h
//  KBNetworking
//
//  Created by chengshenggen on 9/9/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^KxAudioManagerOutputBlock)(float *data,UInt32 numFrames,UInt32 numChannels);

@interface KxAudioManager : NSObject

@property(readwrite)UInt32 numOutputChannels;
@property(readwrite)Float64 samplingRate;
@property(readwrite)UInt32 numBytesPerSample;
@property(readwrite)Float32 outputVolume;
@property(readwrite)BOOL playing;
@property(strong)NSString *audioRoute;

@property(readwrite,copy)KxAudioManagerOutputBlock outputBlock;

-(BOOL)activateAudioSession;
-(void)deactivateAudioSession;
-(BOOL)play;
-(void)pause;

+(KxAudioManager *)shareInstance;

@end
