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
#import "PlayListViewController.h"

@interface HomePageViewController ()<KBAPIManagerApiCallBackDelegate,UICollectionViewDataSource,UICollectionViewDelegate,HomeCollectionHeaderViewCellDelegate>

@property(nonatomic,strong)VRShowNavView *navView;
@property(nonatomic,strong)VRNoDataView *noDataView;
@property(nonatomic,strong)VRWaitingView *waitingView;  //跑动的小人view，正在加载。。。
@property(nonatomic,strong)VRFailLoadingView *failLoadingView;  //加载失败view

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)IndexApiManager *indexManager;

@property(nonatomic,strong)CarouselReformer *carselReformer;
@property(nonatomic,strong)IndexReformer *indexReformer;
@property(nonatomic,strong)ThridTagReformer *thridReformer;

@property(nonatomic,strong)NSArray *indexArray;  //首页API返回的数据

@property(nonatomic,strong)UIButton *testButton;

@property(nonatomic,assign)CGFloat kBannerHight;// 轮播图高度

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.indexManager.isLoading) {
        [self.waitingView showInView:self.view];
    }
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.indexArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        //顶部轮播图 + 第三方平台
        return 1;
    }else {
        NSDictionary *dic = self.indexArray[section][kPropertyVideoList];
        return [dic[@"resourcesList"] count];
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //第一个cell包含轮播图和第三方平台按钮
        HomeCollectionHeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionHeaderViewCell" forIndexPath:indexPath];
        cell.itemDelegate = self;
        NSArray *imageArray = [self.carselReformer manager:self.indexManager reformData:self.indexArray[indexPath.section][kPropertyFocusImgList]];
        [cell configNavImageWithData:imageArray];
        
        NSArray *tagImageArray = [self.thridReformer manager:self.indexManager reformData:self.indexArray[indexPath.section][kPropertyTagList]];
        [cell configTagImageWithData:tagImageArray];
        return cell;
    }
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.indexArray[indexPath.section][kPropertyVideoList];
    if (dic) {
        [cell configWithData:dic[@"resourcesList"][indexPath.row]];
    }
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HomeCollectionHeadReusableView *resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HomeCollectionHeadReusableView" forIndexPath:indexPath];
        return resuableView;
    }else if ([kind isEqualToString: UICollectionElementKindSectionFooter]) {
        HomeCollectionFootReusableView *resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HomeCollectionFootReusableView" forIndexPath:indexPath];
        return resuableView;
    }
    return nil;
}

#pragma mark -
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(self.view.frame.size.width, self.kBannerHight);
    }else{
        //图片按比例设置
        CGFloat imageWidth = (kScreenWidth - 55.0) / 2;
        return CGSizeMake(imageWidth, 42.5 + imageWidth * 9/16);
    }
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(5.0, 20, 5.0, 20.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(kScreenWidth, 43);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = self.indexArray[indexPath.section][kPropertyVideoList];
    if (dic) {
        NSDictionary *oneDic = dic[@"resourcesList"][indexPath.row];
        PlayListViewController *vc = [[PlayListViewController alloc] init];
        vc.resourceID = [oneDic objectForKey:@"resourceId"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark - KBAPIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(KBAPIBaseManager *)manager{
    
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        //首页api
        [self.collectionView.mj_header endRefreshing];
        
        [self.waitingView hide];
        self.indexArray = [manager fetchDataWithReformer:self.indexReformer];
        [self.collectionView reloadData];
    }
    
}
- (void)managerCallAPIDidFailed:(KBAPIBaseManager *)manager{
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        //首页api
        if (manager.errorType == KBAPIManagerErrorTypeNoNetWork || manager.errorType == KBAPIManagerErrorTypeTimeout) {
            //没有网络
            [self.collectionView.mj_header endRefreshing];

            [self.waitingView hide];
            WS(weakSelf);
            [self.failLoadingView showInView:self.view reloadBlock:^(id sender) {
                
                [weakSelf.waitingView showInView:weakSelf.view];
                [weakSelf.indexManager loadData];
            }];
        }
    }
}

#pragma mark - button actions
-(void)testButtonPressed{
    PlayListViewController *vc = [[PlayListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - HomeCollectionHeaderViewCellDelegate
//轮播图点击
-(void)focusImageClick:(NSDictionary *)data{
    
}

#pragma mark - headerRereshing
-(void)headerRereshing{
    [self.indexManager loadData];
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
        
        //注册视频列表 item cell
        [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
        //注册第一个轮播图加第三方平台cell
        [_collectionView registerClass:[HomeCollectionHeaderViewCell class] forCellWithReuseIdentifier:@"HomeCollectionHeaderViewCell"];
        //注册视频列表head标签view
        [_collectionView registerClass:[HomeCollectionHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeCollectionHeadReusableView"];
//        //注册视频列表foot更多按钮view
        [_collectionView registerClass:[HomeCollectionFootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeCollectionFootReusableView"];
        
//        //下拉刷新(进入刷新状态就会调用self的headerRereshing)
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        
    }
    return _collectionView;
}

-(CarouselReformer *)carselReformer{
    if (_carselReformer == nil) {
        _carselReformer = [[CarouselReformer alloc] init];
    }
    return _carselReformer;
}

-(IndexReformer *)indexReformer{
    if (_indexReformer == nil) {
        _indexReformer = [[IndexReformer alloc] init];
    }
    return _indexReformer;
}

-(ThridTagReformer *)thridReformer{
    if (_thridReformer == nil) {
        _thridReformer = [[ThridTagReformer alloc] init];
    }
    return _thridReformer;
}

-(CGFloat)kBannerHight{
    if (_kBannerHight == 0) {
        _kBannerHight = 250;
        if (ISIPhone5s) {
            _kBannerHight = _kBannerHight*KCSGSCALE6S_DEFINE;
        }
    }
    return _kBannerHight;
}

-(VRWaitingView *)waitingView{
    if (_waitingView == nil) {
        _waitingView = [[VRWaitingView alloc] init];
    }
    return _waitingView;
}

-(VRFailLoadingView *)failLoadingView{
    if (_failLoadingView == nil) {
        _failLoadingView = [[VRFailLoadingView alloc] init];
    }
    return _failLoadingView;
}

@end
