//
//  HomePageViewController.m
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "HomePageViewController.h"
#import "Constants.h"

@interface HomePageViewController ()

@property(nonatomic,strong)VRShowNavView *navView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.navView];
    
    
    [self layoutSubPages];
    
}

- (void)layoutSubPages {
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(self.view);
        make.height.equalTo(@64);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - setters and getters

- (VRShowNavView *)navView {
    if (_navView == nil) {
        _navView = [[VRShowNavView alloc] init];
        _navView.titleLabel.text = @"首页";
    }
    return _navView;
}

@end
