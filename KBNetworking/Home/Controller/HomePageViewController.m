//
//  HomePageViewController.m
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "HomePageViewController.h"
#import "Constants.h"
#import "IndexApiManager.h"
#import "HomeCollectionViewCell.h"
#import "CarouselReformer.h"

@interface HomePageViewController ()<KBAPIManagerApiCallBackDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)VRShowNavView *navView;
@property(nonatomic,strong)VRNoDataView *noDataView;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)IndexApiManager *indexManager;

@property(nonatomic,strong)id<KBAPIManagerCallbackDataReformer> carselReformer;
@property(nonatomic,strong)id<KBAPIManagerCallbackDataReformer> indexReformer;

@property(nonatomic,strong)NSDictionary *indexDictionary;


@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.collectionView];
    
    [self layoutSubPages];
    
    [self.indexManager loadData];
    
}

- (void)layoutSubPages {
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_navView.mas_bottom);
        make.height.equalTo([NSNumber numberWithFloat:kScreenHeight-64-49]);
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    [cell configWithData:self.indexDictionary[kPropertyFocusImgList]];
    return cell;
}

#pragma mark - KBAPIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(KBAPIBaseManager *)manager{
    
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        //首页api
        self.indexDictionary = [manager fetchDataWithReformer:self.indexReformer];
        [self.collectionView reloadData];
    }
    
}
- (void)managerCallAPIDidFailed:(KBAPIBaseManager *)manager{
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        //首页api
        if (manager.errorType == KBAPIManagerErrorTypeNoNetWork) {
            //没有网络
            [self.noDataView show];
        }
    }
}

#pragma mark - setters and getters

- (VRShowNavView *)navView {
    if (_navView == nil) {
        _navView = [[VRShowNavView alloc] init];
        _navView.titleLabel.text = @"首页";
    }
    return _navView;
}

-(IndexApiManager *)indexManager{
    if (_indexManager == nil) {
        _indexManager = [[IndexApiManager alloc] init];
        _indexManager.delegate = self;
    }
    return _indexManager;
}

-(VRNoDataView *)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[VRNoDataView alloc] init];
        [self.view addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
    }
    return _noDataView;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    }
    return _collectionView;
}


@end
