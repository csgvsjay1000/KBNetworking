//
//  KBAPIBaseManager.m
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "KBAPIBaseManager.h"
#import "KBNetAppContext.h"
#import "KBURLResponse.h"
#import "KBApiProxy.h"

@interface KBAPIBaseManager ()

@property(nonatomic,readwrite)KBAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong, readwrite) id fetchedRawData;


@end

@implementation KBAPIBaseManager

-(instancetype)init{
    self = [super init];
    if (self) {
        _errorType = KBAPIManagerErrorTypeDefault;
        if ([self conformsToProtocol:@protocol(KBAPIManager)]) {
            self.child = (id <KBAPIManager>)self;
        }
    }
    return self;
}

- (id)fetchDataWithReformer:(id<KBAPIManagerCallbackDataReformer>)reformer{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

- (void)cancelAllRequests
{
    [[KBApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}


#pragma mark calling api
-(NSInteger)loadData{
    
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params{
    NSInteger requestId = 0;
    
    if ([self isReachable]) {
        //如果有网络
        requestId = [[KBApiProxy sharedInstance]callPOSTWithParams:params methodName:self.child.methodName success:^(KBURLResponse *response) {
            [self successedOnCallingAPI:response];
        } fail:^(KBURLResponse *response) {
            [self failedOnCallingAPI:response withErrorType:KBAPIManagerErrorTypeDefault];
        }];
        [self.requestIdList addObject:@(requestId)];
        
    }else{
        //没有网络
        [self failedOnCallingAPI:nil withErrorType:KBAPIManagerErrorTypeNoNetWork];
    }
    
    return requestId;
}

#pragma mark - api callbacks
-(void)successedOnCallingAPI:(KBURLResponse *)response{
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    [self.delegate managerCallAPIDidSuccess:self];
}

- (void)failedOnCallingAPI:(KBURLResponse *)response withErrorType:(KBAPIManagerErrorType)errorType{
    self.errorType = errorType;
    [self.delegate managerCallAPIDidFailed:self];
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}


#pragma mark - getters and setters
- (BOOL)isReachable
{
    BOOL isReachability = [KBNetAppContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = KBAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}


@end
