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

@interface RestaurantHomePageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * menuSource;
@property (nonatomic, strong) UILabel * topTipLabel;

@end

@implementation RestaurantHomePageViewController

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
    ResLoginViewController * login = [[ResLoginViewController alloc] initWithAutoLogin:autoLogin];
    [self presentViewController:login animated:YES completion:^{
        
    }];
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
    layout.itemSize = CGSizeMake(170 * scale, 150 * scale);
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
    
    self.topTipLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xe43018) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentCenter];
    self.topTipLabel.backgroundColor = UIColorFromRGB(0xe9e5db);
    [self.view addSubview:self.topTipLabel];
    [self.topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(36 * scale);
    }];
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
    ResHomeListModel * model = [self.menuSource objectAtIndex:indexPath.row];
    switch (model.type) {
        case ResHomeListType_Dishes:
        {
            
        }
            break;
            
        case ResHomeListType_Trailer:
        {
            
        }
            break;
            
        case ResHomeListType_Words:
        {
            
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
