//
//  ResourcesNewUrlManager.h
//  VRSHOW
//
//  Created by chengshenggen on 6/12/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "KBAPIBaseManager.h"


/**
    根据资源id获取资源url
 */
@interface ResourcesNewUrlManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , copy) NSString *resourceID;

@end

/**
 根据资源tagid获取视频列表
 */
@interface ResourcesListByTagManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , copy) NSString *tagID;
@property (nonatomic , assign) NSInteger currentPage;

@end

/**
    获取播放视频历史
 */
@interface ResourcesHistoryListManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , assign) NSInteger currentPage;

@end

/**
 获取全部视频列表
 */
@interface ResourcesAllListManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , assign) NSInteger currentPage;

@end

/**
    获取资源详情
 */
@interface ResourcesDetailApiManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , copy) NSString *resourceID;

@end


/**
 用户发送评论
 */
@interface UserSendCommentManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , copy) NSString *resourceID;
@property (nonatomic , copy) NSString *sendMsg;

@end


/**
 用户评论列表
 */
@interface CommentListManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , copy) NSString *resourceID;
@property (nonatomic , assign) NSInteger pageSize;
@property (nonatomic , assign) NSInteger currentPage;

@end

/**
 用户资源点赞
 */
@interface ResourceDianzhanManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , copy) NSString *resourceID;

@end

/**
 用户收藏
 */
@interface CollectionManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , copy) NSString *resourceID;

@end

/**
 用户取消收藏
 */
@interface CancelCollectionManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , copy) NSString *collectID;

@end




