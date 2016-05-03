//
//  HomeCollectionViewCell.m
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "CarouselReformerKeys.h"

@implementation HomeCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)configWithData:(NSDictionary *)data{
    NSLog(@"%@",data[kPropertyFocusImgPath]);
}

@end
