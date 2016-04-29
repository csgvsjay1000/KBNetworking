//
//  VRShowTabbarView.m
//  VRShow
//
//  Created by jwd on 3/3/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "VRShowTabbarView.h"
#import "Constants.h"
#import "BusinessTools.h"

@interface VRShowTabbarView ()<VRShowItemViewDelegate>

@property(nonatomic,strong)UIImageView *bgImageView;

@property(nonatomic,strong)NSMutableArray *valueMArray;
@property(nonatomic,strong)NSMutableArray *itemMArray;

@end

@implementation VRShowTabbarView

//初始化
-(id)initWithFrame:(CGRect)frame AndItemDelegate:(id<VRShowItemViewDelegate>)itemDelegate{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width / 4;
        
        NSDictionary *dic_1 = @{@"name":@"首页",
                                @"selectedImageName":@"tabbar_home_selected",
                                @"unselectedImageName":@"tabbar_home_normal"};
        NSDictionary *dic_2 = @{@"name":@"影视",
                                @"selectedImageName":@"tabbar_movie_selected",
                                @"unselectedImageName":@"tabbar_movie_normal"};
        NSDictionary *dic_3 = @{@"name":@"游戏",
                                @"selectedImageName":@"tabbar_game_selected",
                                @"unselectedImageName":@"tabbar_game_normal"};
        NSDictionary *dic_4 = @{@"name":@"个人",
                                @"selectedImageName":@"tabbar_personal_selected",
                                @"unselectedImageName":@"tabbar_personal_normal"};
        
        NSMutableArray *marray = [[NSMutableArray alloc] init];
        [marray addObject:dic_1];
        [marray addObject:dic_2];
        [marray addObject:dic_3];
        [marray addObject:dic_4];
        
        _valueMArray = marray;
        _itemMArray = [[NSMutableArray alloc] init];
        

        for (int i = 0; i < 4; i++) {
            VRShowItemView *itemView = (VRShowItemView *)[BusinessTools loadXibToViewWithName:@"VRShowItemView"];
            NSDictionary *tmpDic = [marray objectAtIndex:i];
            itemView.itemDelegate = self;
            _itemDelegate = itemDelegate;
            itemView.itemIndex = i;
            itemView.itemTitle = tmpDic[@"name"];
           
            if (i == 0) {
                itemView.isItemSelected = YES;
                itemView.selectedImageName = tmpDic[@"selectedImageName"];
                 itemView.itemTitleLabel.textColor = UIColorFromRGB(0xfefefe);
                
            }else{
                itemView.isItemSelected = NO;
                itemView.unselectedImageName = tmpDic[@"unselectedImageName"];
            }
            

            itemView.frame = CGRectMake(i*width, 0, width, height);

            [self addSubview:itemView];
            [_itemMArray addObject:itemView];

        }
        [self setBackgroundColor:UIColorFromRGB(0x00cdd0)];
    }
    return self;
}

- (void)itemClick:(VRShowItemView *)showItemView{
    if (showItemView.isItemSelected) {
        return;
    }
    for (int i = 0; i < _valueMArray.count; i++) {
        VRShowItemView *itemView = [_itemMArray objectAtIndex:i];
        if (itemView.itemIndex == showItemView.itemIndex) {
            itemView.isItemSelected = YES;
            itemView.selectedImageName = [_valueMArray[i] objectForKey:@"selectedImageName"];
            itemView.itemTitleLabel.textColor = UIColorFromRGB(0xfefefe);
        }else{
            itemView.isItemSelected = NO;
            itemView.selectedImageName = [_valueMArray[i] objectForKey:@"unselectedImageName"];
            itemView.itemTitleLabel.textColor = UIColorFromRGB(0x077173);
        }
        
    }
    if (self.itemDelegate) {
        [self.itemDelegate itemClick:(showItemView)];
    }
}

@end
