//
//  VRShowItemView.m
//  VRShow
//
//  Created by jwd on 3/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "VRShowItemView.h"

#import "Constants.h"

@implementation VRShowItemView

- (IBAction)buttonClick:(id)sender {
    
    if (self.itemDelegate && [_itemDelegate respondsToSelector:@selector(itemClick:)]) {
        [self.itemDelegate itemClick:self];
    }
}

/**
 item属性值字典
 keys: name,imageName
 */
-(void)setItemTitle:(NSString *)itemTitle{
    _itemTitleLabel.text = itemTitle;
    _itemTitleLabel.font = [UIFont systemFontOfSize:11.0];
    _itemTitleLabel.textColor = UIColorFromRGB(0x077173);
}

-(void)setSelectedImageName:(NSString *)selectedImageName{
    
    _itemImageView.image = [UIImage imageNamed:selectedImageName];
    
}

-(void)setUnselectedImageName:(NSString *)unselectedImageName{
    _itemImageView.image = [UIImage imageNamed:unselectedImageName];
}


@end
