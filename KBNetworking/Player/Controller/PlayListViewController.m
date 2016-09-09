//
//  PlayListViewController.m
//  KBNetworking
//
//  Created by chengshenggen on 5/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "PlayListViewController.h"
#import "Constants.h"
#import "ResourcesNewUrlManager.h"
#import "PlayerControlView1_0.h"
#import "KBEAGLView.h"
#import "KBPlayer.h"


@interface PlayListViewController ()<KBAPIManagerApiCallBackDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)ResourcesDetailApiManager *detailManager;
@property(nonatomic,strong)PlayerControlView1_0 *controlView;
@property(nonatomic,strong)KBEAGLView *normalGLView;
@property(nonatomic,strong)KBPlayer *player;

@end

@implementation PlayListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.controlView];
    [self.view insertSubview:self.normalGLView belowSubview:self.controlView];
    
    [self layoutSubPages];
    
    [_normalGLView wait:YES];
    [self.player play];
}


- (void)layoutSubPages {
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@210);
    }];
    
    [_normalGLView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(_controlView);
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
- (PlayerControlView1_0 *)controlView
{
    if (_controlView == nil) {
        _controlView = [[PlayerControlView1_0 alloc] init];
        WS(weakSelf);
        _controlView.navView.navLeftButtonBlock = ^(id sender){
            [weakSelf back];
        };
        _controlView.navView.navLeftButton.hidden = NO;
        
    }
    return _controlView;
}

-(KBEAGLView *)normalGLView{
    if (_normalGLView == nil) {
        _normalGLView = [[KBEAGLView alloc] initWithFrame:CGRectZero];
    }
    return _normalGLView;
}

-(KBPlayer *)player{
    if (_player == nil) {
        _player = [[KBPlayer alloc] initWithPath:nil parameters:nil];
    }
    return _player;
}

@end
