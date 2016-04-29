//
//  KBNetAppContext.h
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBNetAppContext : NSObject

@property(nonatomic,readonly)BOOL isReachable;



+ (instancetype)sharedInstance;

@end
