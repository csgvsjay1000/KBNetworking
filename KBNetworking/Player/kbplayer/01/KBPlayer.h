//
//  KBPlayer.h
//  KBNetworking
//
//  Created by chengshenggen on 9/8/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const KxMovieParameterMinBufferedDuration;  // Float
extern NSString *const KxMovieParameterMaxBufferedDuration;  // Float
extern NSString *const KxMovieParameterDisableDeinterlacing;  // BOOL

@interface KBPlayer : NSObject

-(id)initWithPath:(NSString *)path parameters: (NSDictionary *) parameters;

-(void)play;
-(void)pause;

@end
