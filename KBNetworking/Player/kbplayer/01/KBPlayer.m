//
//  KBPlayer.m
//  KBNetworking
//
//  Created by chengshenggen on 9/8/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "KBPlayer.h"
#import "KxAudioManager.h"
#import "Constants.h"

@interface KBPlayer ()

@property(nonatomic,strong)KxAudioManager *audioManager;

@end

@implementation KBPlayer

#pragma mark - init
-(id)initWithPath:(NSString *)path parameters:(NSDictionary *)parameters{
    self = [super init];
    if (self) {
        [self.audioManager activateAudioSession];
    }
    return self;
}

-(void)dealloc{
    NSLog(@"%@",[self class]);
}

#pragma mark - public method
-(void)play{
    
}

-(void)pause{
    
}


#pragma mark - setters and getters
-(KxAudioManager *)audioManager{
    if (_audioManager == nil) {
        _audioManager = [KxAudioManager shareInstance];
    }
    return _audioManager;
}

@end
