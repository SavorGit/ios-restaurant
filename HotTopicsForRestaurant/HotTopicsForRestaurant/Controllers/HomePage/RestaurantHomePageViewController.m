//
//  RestaurantHomePageViewController.m
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/6/9.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import "RestaurantHomePageViewController.h"
#import "ResSliderViewController.h"
#import "RestaurantPhotoTool.h"
#import "SAVORXAPI.h"
#import "HomeMenuCollectionViewCell.h"
#import "ResVideoViewController.h"
#import "ResLoginViewController.h"
#import "RecoDishesViewController.h"
#import "ResKeyWordViewController.h"
#import "GCCDLNA.h"

@interface RestaurantHomePageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * menuSource;

@property (nonatomic, strong) UIView * topTipView;
@property (nonatomic, strong) UIImageView * topTipImageView;
@property (nonatomic, strong) UILabel * topTipLabel;

@end

@implementation RestaurantHomePageViewController

- (void)dealloc
{
    [self removeNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    [self creatSubViews];
    
    [SAVORXAPI checkVersionUpgrade];
    
    BOOL autoLogin;
    if ([[NSFileManager defaultManager] fileExistsAtPath:UserAccountPath]) {
        autoLogin = YES;
    }else{
        autoLogin = NO;
    }
    
    [self addNotification];
    
    ResLoginViewController * login = [[ResLoginViewController alloc] initWithAutoLogin:autoLogin];
    [self presentViewController:login animated:YES completion:^{
        
    }];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNotificationStatusDidChange) name:RDUserLoginStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFindHotelID) name:RDDidFoundBoxSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoseHotelID) name:RDDidNotFoundSenceNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDUserLoginStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidFoundBoxSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidNotFoundSenceNotification object:nil];
}

- (void)didFindHotelID
{
    [self checkHotelID];
}

- (void)didLoseHotelID
{
    [self checkHotelID];
}

- (void)userNotificationStatusDidChange
{
    [[GCCDLNA defaultManager] startSearchPlatform];
    [self checkHotelID];
}

- (void)checkHotelID
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if ([GlobalData shared].hotelId == [GlobalData shared].userModel.hotelID) {
        self.topTipLabel.text = [NSString stringWithFormat:@"当前连接酒楼“%@”", [GlobalData shared].userModel.hotelName];
        self.topTipLabel.textColor = UIColorFromRGB(0x0da606);
        if (self.topTipImageView.superview) {
            [self.topTipImageView removeFromSuperview];
        }
    }else{
        self.topTipLabel.text = [NSString stringWithFormat:@"    请连接“%@”的wifi后操作", [GlobalData shared].userModel.hotelName];
        self.topTipLabel.textColor = UIColorFromRGB(0xe43018);
        
        if (!self.topTipImageView.superview) {
            [self.topTipLabel addSubview:self.topTipImageView];
            [self.topTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(15 * scale);
                make.height.mas_equalTo(15 * scale);
            }];
        }
    }
}

- (void)createDataSource
{
    self.menuSource = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        [self.menuSource addObject:[[ResHomeListModel alloc] initWithType:i]];
    }
}

//创建子视图
- (void)creatSubViews{
    
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    // 设置自定义的title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    titleLabel.text = @"小热点-餐厅端";
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.navigationItem.titleView = titleLabel;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(170 * scale - 1, 150 * scale);
    layout.minimumLineSpacing = 15 * scale;
    layout.minimumInteritemSpacing = 5 * scale;
    layout.sectionInset = UIEdgeInsetsMake(51 * scale, 15 * scale, 15 * scale, 15 * scale);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.collectionView registerClass:[HomeMenuCollectionViewCell class] forCellWithReuseIdentifier:@"HomeMenuCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.topTipView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topTipView.backgroundColor = UIColorFromRGB(0xe9e5db);
    [self.view addSubview:self.topTipView];
    [self.topTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(36 * scale);
    }];
    
    self.topTipLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xe43018) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentCenter];
    [self.topTipView addSubview:self.topTipLabel];
    [self.topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36 * scale);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    self.topTipImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.topTipImageView setImage:[UIImage imageNamed:@"tsjg"]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeMenuCollectionViewCell" forIndexPath:indexPath];
    
    ResHomeListModel * model = [self.menuSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([GlobalData shared].hotelId != [GlobalData shared].userModel.hotelID) {
        CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        shake.fromValue = [NSNumber numberWithFloat:-8];
        shake.toValue = [NSNumber numberWithFloat:8];
        shake.duration = 0.1;//执行时间
        shake.autoreverses = YES; //是否重复
        shake.repeatCount = 2;//次数
        [self.topTipLabel.layer addAnimation:shake forKey:@"shakeAnimation"];
        return;
    }
    
    ResHomeListModel * model = [self.menuSource objectAtIndex:indexPath.row];
    switch (model.type) {
        case ResHomeListType_Dishes:
        {
            RecoDishesViewController  * slider = [[RecoDishesViewController alloc] initWithType:YES];
            [self.navigationController pushViewController:slider animated:YES];
        }
            break;
            
        case ResHomeListType_Trailer:
        {
            RecoDishesViewController  * slider = [[RecoDishesViewController alloc] initWithType:NO];
            [self.navigationController pushViewController:slider animated:YES];
        }
            break;
            
        case ResHomeListType_Words:
        {
            ResKeyWordViewController * keyWord = [[ResKeyWordViewController alloc] init];
            [self.navigationController pushViewController:keyWord animated:YES];
        }
            break;
            
        case ResHomeListType_Photo:
        {
            [RestaurantPhotoTool checkUserLibraryAuthorizationStatusWithSuccess:^{
                ResSliderViewController * slider = [[ResSliderViewController alloc] init];
                [self.navigationController pushViewController:slider animated:YES];
            } failure:^(NSError *error) {
                [self openSetting];
            }];
        }
            break;
            
        case ResHomeListType_Video:
        {
            [RestaurantPhotoTool checkUserLibraryAuthorizationStatusWithSuccess:^{
                ResVideoViewController * slider = [[ResVideoViewController alloc] init];
                [self.navigationController pushViewController:slider animated:YES];
            } failure:^(NSError *error) {
                [self openSetting];
            }];
        }
            break;
            
        default:
            break;
    }
}

//打开用户应用设置
- (void)openSetting
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该功能需要开启相册权限，是否前往进行设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //关闭iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
