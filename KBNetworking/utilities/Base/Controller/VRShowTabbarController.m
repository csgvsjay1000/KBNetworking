//
//  VRShowTabbarController.m
//  VRShow
//
//  Created by jwd on 3/3/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "VRShowTabbarController.h"
#import "VRShowTabbarView.h"
#import "MoviesViewController.h"
#import "GameViewController.h"
#import <objc/runtime.h>
#import "Constants.h"
#import "HomePageViewController.h"
#import "MyselfViewController.h"


@interface VRShowTabbarController ()<VRShowItemViewDelegate>

@property(nonatomic,strong)VRShowTabbarView *vrShowTabbarView;
@property(nonatomic,strong)HomePageViewController *homeVC;
@property(nonatomic,strong)MoviesViewController *moviesVC;
@property(nonatomic,strong)GameViewController *gameVC;
@property(nonatomic,strong)MyselfViewController *personVC;
@property(nonatomic,strong)NSMutableArray *subVCMArray;

@end

@implementation VRShowTabbarController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.vrShowTabbarView];
    self.viewControllers = self.subVCMArray;
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    UIViewController *vc = self.selectedViewController;
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
    UIViewController *vc = self.selectedViewController;
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


#pragma mark - VRShowItemViewDelegate

-(void)itemClick:(VRShowItemView *)itemView{
    self.selectedIndex = itemView.itemIndex;
}

#pragma mark - setters and getters

- (VRShowTabbarView *)vrShowTabbarView{
    if (_vrShowTabbarView == nil) {
        CGFloat height = self.view.frame.size.height;
        CGFloat width = self.view.frame.size.width;

        _vrShowTabbarView = [[VRShowTabbarView alloc] initWithFrame:CGRectMake(0, height - 49, width, 49) AndItemDelegate:self];

    }
    return _vrShowTabbarView;
}

-(NSMutableArray *)subVCMArray{
    if (_subVCMArray == nil) {
        _subVCMArray = [[NSMutableArray alloc] init];
        [_subVCMArray addObject:self.homeVC];
        [_subVCMArray addObject:self.moviesVC];
        [_subVCMArray addObject:self.gameVC];
        [_subVCMArray addObject:self.personVC];

    }
    return _subVCMArray;
}

-(HomePageViewController *)homeVC{
    if (_homeVC == nil) {
        _homeVC = [[HomePageViewController alloc] init];
    }
    return _homeVC;
}

-(MoviesViewController *)moviesVC{
    if (_moviesVC == nil) {
        _moviesVC = [[MoviesViewController alloc] init];
    }
    return _moviesVC;
}

-(GameViewController *)gameVC{
    if (_gameVC == nil) {
        _gameVC = [[GameViewController alloc] init];
    }
    return _gameVC;
}

-(MyselfViewController *)personVC{
    if (_personVC == nil) {
        _personVC = [[MyselfViewController alloc] init];
    }
    return _personVC;
}

@end
