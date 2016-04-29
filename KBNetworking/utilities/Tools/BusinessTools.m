//
//  BusinessTools.m
//  VRShow
//
//  Created by jwd on 3/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "BusinessTools.h"


@implementation BusinessTools

+ (UIView *)loadXibToViewWithName:(NSString *)name
{
    NSArray *ary = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
    UIView *elationView = (UIView *)[ary lastObject];
    return elationView;
}

@end
