//
//  KxAudioManager.m
//  KBNetworking
//
//  Created by chengshenggen on 9/9/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "KxAudioManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "KxLogger.h"
#import "VRShowFunDefineHeader.pch"

#define MAX_FRAME_SIZE 4096
#define MAX_CHAN 2
#define MAX_SAMPLE_DUMPED 5

@interface KxAudioManager (){
    
    BOOL _initialized;
    BOOL _activated;
    float *_outData;
    AudioUnit _audioUnit;
    AudioStreamBasicDescription _outputFormat;
    
}

@end

@implementation KxAudioManager

#pragma mark - init
+(KxAudioManager *)shareInstance{
    static KxAudioManager *audioManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioManager = [[KxAudioManager alloc] init];
    });
    return audioManager;
}


-(id)init{
    self = [super init];
    if (self) {
        _outData = calloc(MAX_FRAME_SIZE*MAX_CHAN, sizeof(float));
        _outputVolume = 0.5;
        
    }
    return self;
}

-(void)dealloc{
    if (_outData) {
        free(_outData);
        _outData = NULL;
        NSLog(@"%@",[self class]);

    }
}

-(BOOL)activateAudioSession{
    if (!_activated) {
        if (!_initialized) {
            if (checkError(AudioSessionInitialize(NULL, kCFRunLoopDefaultMode, sessionInterruptionListener, (__bridge void*)self), "Couldn't initialize audio session")) {
                return NO;
            }
            _initialized = YES;
        }
        
        if ([self checkAudioRoute] && [self setupAudio]) {
            _activated = YES;
        }
    }
    return _activated;
}

#pragma mark - private method
-(BOOL)checkAudioRoute{
    UInt32 propertySize = sizeof(CFStringRef);
    CFStringRef route;
    if (checkError(AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route), "Couldn't check the audio route")) {
        return NO;
    }
    _audioRoute = CFBridgingRelease(route);
    return YES;
}

-(BOOL)setupAudio{
    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    if (checkError(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory), "Couldn't set audio category")) {
        return NO;
    }
    if (checkError(AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, sessionPropertyListener, (__bridge void*)self), "Couldn't add audio session property listener")) {
        return NO;
    }
    if (checkError(AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, sessionPropertyListener, (__bridge void*)self), "Couldn't add audio session property listener")) {
    }
    
#if !TARGET_IPHONE_SIMULATOR
    Float32 preferredBufferSize = 0.0232;
    if (checkError(AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(preferredBufferSize), &preferredBufferSize), "Co`uldn't set the preferred buffer duration")) {
        
    }
#endif
    if (checkError(AudioSessionSetActive(YES), "Couldn't activate the audio session")) {
        return NO;
    }
    [self checkSessionProperties];
    
    // --- Audio Unit Setup --- //
    
    // Describe the output unit
    
    AudioComponentDescription description = {0};
    description.componentType = kAudioUnitType_Output;
    description.componentSubType = kAudioUnitSubType_RemoteIO;
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    // Get component
    AudioComponent component = AudioComponentFindNext(NULL, &description);
    if (checkError(AudioComponentInstanceNew(component, &_audioUnit), "Couldn't create the output audio unit")) {
        return NO;
    }
    
    UInt32 size;
    
    // Check the output stream format
    size = sizeof(AudioStreamBasicDescription);
    if (checkError(AudioUnitGetProperty(_audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &_outputFormat, &size), "Couldn't get the hardware output stream format")) {
        return NO;
    }
    _outputFormat.mSampleRate = _samplingRate;
    
    
    return YES;
}

-(BOOL)checkSessionProperties{
    [self checkAudioRoute];
    UInt32 numChannels;
    UInt32 size = sizeof(numChannels);
    if (checkError(AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareOutputNumberChannels, &size, &numChannels), "Checking number of output channels")) {
        return NO;
    }
    LoggerAudio(2, @"We've got %lu output channels", numChannels);
    
    size = sizeof(_samplingRate);
    if (checkError(AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &size, &_samplingRate), "Checking hardware sampling rate")) {
        return NO;
    }
    LoggerAudio(2, @"Current sampling rate: %f", _samplingRate);
    
    return YES;
}

#pragma mark - callbacks
static BOOL checkError(OSStatus error,const char *operation){
    if (error == noErr) {
        return NO;
    }
    char str[20] = {0};
    // see if it appears to be a 4-char-code
    *(UInt32 *)(str + 1) = CFSwapInt32HostToBig(error);
    if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
        str[0] = str[5] = '\'';
        str[6] = '\0';
    } else
        // no, format it as an integer
        sprintf(str, "%d", (int)error);
    
    LoggerStream(0, @"Error: %s (%s)\n", operation, str);
    
    return YES;
}

static void sessionPropertyListener(void *inClientData,AudioSessionPropertyID inID,UInt32 inDataSize,const void *inData){
    
    KxAudioManager *sm = (__bridge KxAudioManager *)inClientData;
    
    if (inID == kAudioSessionProperty_AudioRouteChange) {
        
        if ([sm checkAudioRoute]) {
            [sm checkSessionProperties];
        }
        
    }else if (inID == kAudioSessionProperty_CurrentHardwareOutputVolume) {
        if (inData && inDataSize== 4) {
            sm.outputVolume = *(float *)inData;
        }
    }
    
}

static void sessionInterruptionListener(void *inClientData, UInt32 inInterruption){
    
}

@end
