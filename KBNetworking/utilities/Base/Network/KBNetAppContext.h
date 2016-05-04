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

@property(nonatomic,readonly)NSString *ipAddr;
@property(nonatomic,readonly)NSString *clientType;
@property(nonatomic,readonly)NSString *version;
@property(nonatomic,readonly)NSString *MD5_Key;
@property(nonatomic,readonly)NSString *identificationCode;


+ (instancetype)sharedInstance;

@end
