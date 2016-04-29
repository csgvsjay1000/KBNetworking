//
//  VRShowNavView.h
//  VRShow
//
//  Created by jwd on 3/3/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface VRShowNavView : UIView

//声明block
//typedef void(^VRSHowButtonPressedBlock)(id);

//标题
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UILabel *leftTitleLabel;

//返回按钮
@property(nonatomic, strong) UIButton *navLeftButton;

//返回按钮响应(定义block)
@property (nonatomic, copy) VRSHowButtonPressedBlock navLeftButtonBlock;

@end

@interface VRNoDataView : UIView


@end

