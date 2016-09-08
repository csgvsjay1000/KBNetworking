//
//  KBNetAppContext.m
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "KBNetAppContext.h"
#import "AFNetworking.h"
#import "KeychainItemWrapper.h"
#import "Constants.h"
#import "BusinessTools.h"

@interface KBNetAppContext (){
    NSString *_identificationCode;
    NSString *_encryUserID;

}

@end

@implementation KBNetAppContext

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

+ (instancetype)sharedInstance{
    static KBNetAppContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBNetAppContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

-(NSString *)ipAddr{
    return @"-1";
}

-(NSString *)clientType{
    return @"2";
}

-(NSString *)version{
    return @"1.0";
}

-(NSString *)MD5_Key{
    return @"92A864886F70D010101050101010500048202613082025D02010002818";
}

-(NSString *)identificationCode{
    if (_identificationCode == nil) {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"VRShow" accessGroup:nil];
        NSString *_identifier = [wrapper objectForKey:(id)kSecValueData];
        if (NULL_STR(_identifier)) {
            _identifier  = [[UIDevice currentDevice].identifierForVendor UUIDString];
            _identifier = [_identifier stringByAppendingString:@"_iOS"];
            _identifier = [BusinessTools encryptWithPublicKey:_identifier];
            [wrapper setObject:_identifier forKey:(id)kSecValueData];
        }
        _identificationCode = _identifier;
    }
    return _identificationCode;
}

-(NSString *)encryUserID{
    if (_encryUserID == nil) {
        UserDefaultGet(userId, KUserID);
        if (NULL_STR(userId)) {
            userId = @"-1";
        }
        _encryUserID = [BusinessTools encryptWithPublicKey:userId];
    }
    return _encryUserID;
}

@end
