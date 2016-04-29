//
//  VRShowNavController.m
//  VRShow
//
//  Created by jwd on 3/3/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "VRShowNavController.h"
#import <objc/runtime.h>


@interface VRShowNavController ()

@end

@implementation VRShowNavController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *vc = self.topViewController;
    unsigned int outCount;
    
    Method *meth = class_copyMethodList([vc class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Method thisMethod = meth[i];
        SEL sel = method_getName(thisMethod);
        const char *name = sel_getName(sel);
        NSString *methodName = [NSString stringWithUTF8String:name];
        if ([methodName isEqualToString:@"supportedInterfaceOrientations"]) {
            free(meth);
            return [vc supportedInterfaceOrientations];
            break;
        }
    }
    free(meth);
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController *vc = self.topViewController;
    unsigned int outCount;
    
    Method *meth = class_copyMethodList([vc class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Method thisMethod = meth[i];
        SEL sel = method_getName(thisMethod);
        const char *name = sel_getName(sel);
        NSString *methodName = [NSString stringWithUTF8String:name];
        if ([methodName isEqualToString:@"preferredStatusBarStyle"]) {
            free(meth);
            return [vc preferredStatusBarStyle];
            break;
        }
    }
    free(meth);
    
    return UIStatusBarStyleLightContent;
}

@end
