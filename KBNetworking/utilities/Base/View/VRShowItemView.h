//
//  VRShowItemView.h
//  VRShow
//
//  Created by jwd on 3/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VRShowItemView;

@protocol VRShowItemViewDelegate <NSObject>

//传自身的对象过去
-(void)itemClick:(VRShowItemView *)itemView;

@end

@interface VRShowItemView : UIView

//索引
@property(nonatomic)NSInteger itemIndex;
//是否被选中
@property(nonatomic)BOOL isItemSelected;
//图标
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
//文字标签
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;

/**
 item属性值字典
    keys: name,imageName
 */
@property(nonatomic,copy)NSString *itemTitle;
@property(nonatomic,copy)NSString *selectedImageName;
@property(nonatomic,copy)NSString *unselectedImageName;

@property(nonatomic,weak)id<VRShowItemViewDelegate> itemDelegate;

@end
