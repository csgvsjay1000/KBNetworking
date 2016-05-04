//
//  ResourcesDetailApiManager.h
//  KBNetworking
//
//  Created by chengshenggen on 5/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "KBAPIBaseManager.h"

@interface ResourcesDetailApiManager : KBAPIBaseManager<KBAPIManager,KBAPIManagerParamSourceDelegate>

@property (nonatomic , copy) NSString *resourceID;

@end
