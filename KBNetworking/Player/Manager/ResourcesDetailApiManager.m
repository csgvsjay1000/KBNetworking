//
//  ResourcesDetailApiManager.m
//  KBNetworking
//
//  Created by chengshenggen on 5/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "ResourcesDetailApiManager.h"
#import "Constants.h"

@implementation ResourcesDetailApiManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    UserDefaultGet(userId, KUserID);
    if (NULL_STR(userId)) {
        userId = @"-1";
    }
    NSString *decryUserID = [BusinessTools encryptWithPublicKey:userId];
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _resourceID, @"resourcesId",
                             decryUserID,@"userId", nil];
    
    return dataDic;
}

#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"app/resources/id/detail/service";
}

@end
