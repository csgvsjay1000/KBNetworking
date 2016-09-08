//
//  ResourcesNewUrlManager.m
//  VRSHOW
//
//  Created by chengshenggen on 6/12/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "ResourcesNewUrlManager.h"
#import "KBNetAppContext.h"

@implementation ResourcesNewUrlManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [KBNetAppContext sharedInstance].encryUserID,@"userId",
                            self.resourceID, @"resourcesId",nil];
    return params;
}


#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"resources/new/url/service";
}

@end


@implementation ResourcesListByTagManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
              [NSString stringWithFormat:@"%ld",(long)self.currentPage], @"currPage",
              @"9", @"queryCount",
              self.tagID, @"tagId" ,nil];
    
    return params;
}

#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"app/tag/resources/list/service";
}

@end

@implementation ResourcesHistoryListManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld",self.currentPage], @"currPage",
                            @"9", @"pageSize",
                            [KBNetAppContext sharedInstance].encryUserID, @"userId", nil];
    return params;
}

#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"user/play/history/list/service";
}

@end

@implementation ResourcesAllListManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld",(long)self.currentPage], @"currPage",
                            @"9", @"pageSize",
                            @"1", @"bySort",
                            @"1",@"typeId",
                            @"-1",@"tagId",
                            @"0",@"isFree",
                            @"-1",@"clientId", nil];
    return params;
}




#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"resources/list/service";
}

@end

@implementation ResourcesDetailApiManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [KBNetAppContext sharedInstance].encryUserID,@"userId",
                            self.resourceID, @"resourcesId",nil];
    return params;
}

#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"app/resources/id/detail/service";
}

@end


@implementation UserSendCommentManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
              self.sendMsg, @"commentContent",
              self.resourceID, @"resourcesId",
              [KBNetAppContext sharedInstance].encryUserID, @"userId", nil];
    return params;
}

#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"resources/comment/service";
}

@end

@implementation CommentListManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%ld",self.currentPage], @"currPage",
                            @"10", @"pageSize",
                            self.resourceID, @"resourcesId",nil];
    return params;
}

#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"resources/comment/list/service";
}

@end


@implementation ResourceDianzhanManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [KBNetAppContext sharedInstance].encryUserID,@"userId",
                            self.resourceID, @"resourceId",nil];
    return params;
}

#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"resource/like/service";
}

@end


@implementation CollectionManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [KBNetAppContext sharedInstance].encryUserID,@"userId",
                            @"1",@"collectionType",
                            self.resourceID, @"sourceId",nil];
    return params;
}

#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"user/resources/collection/service";
}

@end

@implementation CancelCollectionManager

-(id)init{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [KBNetAppContext sharedInstance].encryUserID,@"userId",
                            self.collectID, @"collectIds",nil];
    return params;
}

#pragma mark - KBAPIManager
- (NSString *)methodName{
    return @"user/resources/collection/cancel/service";
}

@end

