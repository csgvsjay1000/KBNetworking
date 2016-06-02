//
//  KBAPIBaseManager.h
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KBAPIBaseManager;


@protocol KBAPIManagerApiCallBackDelegate <NSObject>

@required
- (void)managerCallAPIDidSuccess:(KBAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(KBAPIBaseManager *)manager;

@end

@protocol KBAPIManagerParamSourceDelegate <NSObject>

@required
- (NSDictionary *)paramsForApi:(KBAPIBaseManager *)manager;

@end

typedef NS_ENUM (NSUInteger, KBAPIManagerErrorType){
    KBAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    KBAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    KBAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    KBAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    KBAPIManagerErrorTypeTimeout,       //请求超时。RTApiProxy设置的是20秒超时，具体超时时间的设置请自己去看RTApiProxy的相关代码。
    KBAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

@protocol KBAPIManagerCallbackDataReformer <NSObject>
@required
- (id)manager:(KBAPIBaseManager *)manager reformData:(NSDictionary *)data;

@end



/*
 RTAPIBaseManager的派生类必须符合这些protocal
 */
@protocol KBAPIManager <NSObject>

@required
- (NSString *)methodName;

@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (BOOL)shouldCache;

@end

@interface KBAPIBaseManager : NSObject

@property(nonatomic,weak)id<KBAPIManagerApiCallBackDelegate> delegate;
@property (nonatomic, weak) id<KBAPIManagerParamSourceDelegate> paramSource;
@property (nonatomic, weak) NSObject<KBAPIManager> *child; //里面会调用到NSObject的方法，所以这里不用id

@property (nonatomic, readonly) KBAPIManagerErrorType errorType;

@property (nonatomic, assign) BOOL isLoading;  //是否正在加载



- (id)fetchDataWithReformer:(id<KBAPIManagerCallbackDataReformer>)reformer;

-(NSInteger)loadData;

- (void)cancelAllRequests;

@end
