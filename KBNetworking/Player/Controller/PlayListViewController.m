//
//  PlayListViewController.m
//  KBNetworking
//
//  Created by chengshenggen on 5/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "PlayListViewController.h"
#import "Constants.h"
#import "ResourcesDetailApiManager.h"

@interface PlayListViewController ()<KBAPIManagerApiCallBackDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)VRShowNavView *navView;

@property(nonatomic,strong)ResourcesDetailApiManager *detailManager;

@end

@implementation PlayListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view addSubview:self.navView];
    
    
    [self layoutSubPages];
    
    [self.detailManager loadData];
    
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_detailManager cancelAllRequests];

}

-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}

#pragma mark - button actions
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KBAPIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(KBAPIBaseManager *)manager{
    NSLog(@"managerCallAPIDidSuccess");
}

- (void)managerCallAPIDidFailed:(KBAPIBaseManager *)manager{
    NSLog(@"managerCallAPIDidFailed");

}


#pragma mark - setters and getters
- (VRShowNavView *)navView {
    if (_navView == nil) {
        _navView = [[VRShowNavView alloc] init];
        _navView.leftTitleLabel.text = @"详情";
        _navView.leftTitleLabel.hidden = NO;
        _navView.titleLabel.hidden = YES;
        _navView.navLeftButton.hidden = NO;
        WS(weakSelf)
        _navView.navLeftButtonBlock = ^(id sender){
            [weakSelf back];
        };
    }
    return _navView;
}

-(ResourcesDetailApiManager *)detailManager{
    if (_detailManager == nil) {
        _detailManager = [[ResourcesDetailApiManager alloc] init];
        _detailManager.delegate = self;
    }
    return _detailManager;
}

@end
