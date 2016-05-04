//
//  KBApiProxy.h
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBURLResponse.h"

@interface KBApiProxy : NSObject

typedef void(^AXCallback)(KBURLResponse *response);

+ (instancetype)sharedInstance;

- (NSInteger)callPOSTWithParams:(NSDictionary *)params methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;


@end
