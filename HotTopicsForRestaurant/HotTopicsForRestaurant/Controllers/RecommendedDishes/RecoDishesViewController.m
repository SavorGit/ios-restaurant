//
//  RecoDishesViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/11/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RecoDishesViewController.h"
#import "RecoDishesCollectionViewCell.h"
#import "RecoDishesModel.h"
#import "HelpViewController.h"
#import "SelectRoomViewController.h"
#import "SAVORXAPI.h"
#import "GetHotelRecFoodsRequest.h"
#import "GetRoomListRequest.h"
#import "ReGetRoomModel.h"
#import "GetAdvertisingVideoRequest.h"

@interface RecoDishesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,RecoDishesDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *roomDataSource;
@property (nonatomic, assign) BOOL isFoodDishs;

@end

@implementation RecoDishesViewController

- (instancetype)initWithType:(BOOL )isFoodDishs{
    if (self = [super init]) {
        self.isFoodDishs = isFoodDishs;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    if (self.isFoodDishs == YES) {
        [self RecoDishesRequest];
    }else{
        [self AdVideoListRequest];
    }
    [self GetRoomListRequest];
    [self creatSubViews];
}

- (void)RecoDishesRequest{
    
    [self.dataSource removeAllObjects];
    GetHotelRecFoodsRequest * request = [[GetHotelRecFoodsRequest alloc] initWithHotelId:@"7"];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {

        NSArray *resultArr = [response objectForKey:@"result"];
        NSArray * sameArr ;
        if ([[NSFileManager defaultManager] fileExistsAtPath:UserSelectDishPath]) {
            sameArr = [NSArray arrayWithContentsOfFile:UserSelectDishPath];
        }
        for (int i = 0 ; i < resultArr.count ; i ++) {
            
            NSDictionary *tmpDic = resultArr[i];
            RecoDishesModel * tmpModel = [[RecoDishesModel alloc] initWithDictionary:tmpDic];
            tmpModel.selectType = 0;
            for (int i = 0; i < sameArr.count; i ++ ) {
                if (tmpModel.cid == [sameArr[i] integerValue]) {
                    tmpModel.selectType = 1;
                }
            }
            [self.dataSource addObject:tmpModel];
        }
        
        [self.collectionView reloadData];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}


- (void)AdVideoListRequest{
    
    [self.dataSource removeAllObjects];
    GetAdvertisingVideoRequest * request = [[GetAdvertisingVideoRequest alloc] initWithHotelId:@"7"];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray *resultArr = [response objectForKey:@"result"];
        NSArray * sameArr ;
        if ([[NSFileManager defaultManager] fileExistsAtPath:UserSelectADPath]) {
            sameArr = [NSArray arrayWithContentsOfFile:UserSelectADPath];
        }
        for (int i = 0 ; i < resultArr.count ; i ++) {
            
            NSDictionary *tmpDic = resultArr[i];
            RecoDishesModel * tmpModel = [[RecoDishesModel alloc] initWithDictionary:tmpDic];
            tmpModel.selectType = 0;
            for (int i = 0; i < sameArr.count; i ++ ) {
                if (tmpModel.cid == [sameArr[i] integerValue]) {
                    tmpModel.selectType = 1;
                }
            }
            [self.dataSource addObject:tmpModel];
        }
        
        [self.collectionView reloadData];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}

- (void)GetRoomListRequest{
    
    GetRoomListRequest * request = [[GetRoomListRequest alloc] initWithHotelId:@"7"];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([[response objectForKey:@"code"] integerValue] == 10000) {
            NSArray *resultArr = [response objectForKey:@"result"];
            for (int i = 0 ; i < resultArr.count ; i ++) {
                NSDictionary *tmpDic = resultArr[i];
                ReGetRoomModel * tmpModel = [[ReGetRoomModel alloc] initWithDictionary:tmpDic];
                [self.roomDataSource addObject:tmpModel];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}

- (void)initInfor{

    self.dataSource = [NSMutableArray new];
    self.roomDataSource = [NSMutableArray new];
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    UIButton*rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"yixuanzhong.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    [self autoTitleButtonWith:@"请选择投屏包间"];
}

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 15.f;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(15.f *scale, 15 *scale, 15.f *scale, 15 *scale);
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled =  YES;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[RecoDishesCollectionViewCell class] forCellWithReuseIdentifier:@"imgCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 50 - 64));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,50 *scale));
        make.top.mas_equalTo(self.view.mas_bottom).offset(- 50 *scale);
        make.left.mas_equalTo(0);
    }];
    
    UIButton *toScreenBtn = [SAVORXAPI buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(15) backgroundColor:[UIColor clearColor] title:@"一键投所选内容" cornerRadius:5.f];
    toScreenBtn.backgroundColor = UIColorFromRGB(0xff783d);
    [toScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:toScreenBtn];
    [toScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(277 *scale, 36 *scale));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(bottomView.mas_top).offset(7 *scale);
    }];
    toScreenBtn.layer.borderColor = UIColorFromRGB(0xff783d).CGColor;
    toScreenBtn.layer.borderWidth = 1.f;
    [toScreenBtn addTarget:self action:@selector(toScreenBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 点击一键投屏所选内容
-(void)toScreenBtnDidClicked:(UIButton *)Btn{
    NSMutableArray *selectArr = [NSMutableArray new];
    for (int i = 0 ; i < self.dataSource.count ; i ++) {
        RecoDishesModel *tmpModel = self.dataSource[i];
        if (tmpModel.selectType == 1) {
            [selectArr addObject:[NSString stringWithFormat:@"%ld",tmpModel.cid]];
        }
    }
    if (self.isFoodDishs == YES) {
        [Helper saveFileOnPath:UserSelectDishPath withArray:selectArr];
    }else{
        [Helper saveFileOnPath:UserSelectADPath withArray:selectArr];
    }
    
}

#pragma mark - 点击投屏单个内容
-(void)toScreen:(RecoDishesModel *)currentModel{
    
}

#pragma mark - UICollectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecoDishesCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    
    RecoDishesModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell configModelData:tmpModel andIsFoodDish:self.isFoodDishs];
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGFloat width = (kMainBoundsWidth - 45) / 2;
    return CGSizeMake(width , 162 *scale);
}

- (void)autoTitleButtonWith:(NSString *)title
{
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTintColor:UIColorFromRGB(0xece6de)];
    [titleButton setImage:[UIImage imageNamed:@"xczk"] forState:UIControlStateNormal];
    titleButton.titleLabel.font = kPingFangMedium(17);
    [titleButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
    titleButton.imageView.contentMode = UIViewContentModeCenter;
    
    CGFloat maxWidth = kMainBoundsWidth - 100;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    if (size.width > maxWidth) {
        size.width = maxWidth;
    }
    titleButton.frame = CGRectMake(0, (kMainBoundsWidth - size.width - 30) / 2, size.width + 30, size.height);
    
    [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width + 15, 0, 0)];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10 + 10)];
    
    [titleButton setTitle:title forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
}

//标题被点击的时候
- (void)titleButtonDidBeClicked{
    
    SelectRoomViewController *srVC = [[SelectRoomViewController alloc] init];
    srVC.dataSource = self.roomDataSource;
    [self presentViewController:srVC animated:YES completion:^{
    }];
    srVC.backDatas = ^(ReGetRoomModel *tmpModel) {
        if (!isEmptyString(tmpModel.name)) {
            [self autoTitleButtonWith:tmpModel.name];
        }
    };
}

- (void)help{
    
    HelpViewController * help = [[HelpViewController alloc] initWithURL:@"http://h5.littlehotspot.com/Public/html/help3"];
    help.title = @"推荐菜";
    [self.navigationController pushViewController:help  animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
