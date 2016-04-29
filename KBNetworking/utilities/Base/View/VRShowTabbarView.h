//
//  VRShowTabbarView.h
//  VRShow
//
//  Created by jwd on 3/3/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRShowItemView.h"

@interface VRShowTabbarView : UIView

-(id)initWithFrame:(CGRect)frame AndItemDelegate:(id<VRShowItemViewDelegate>) itemDelegate;

@property(nonatomic,weak)id<VRShowItemViewDelegate> itemDelegate;

@end
