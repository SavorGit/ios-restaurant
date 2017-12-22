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
#import "RDBoxModel.h"
#import "GetAdvertisingVideoRequest.h"
#import "GlobalData.h"
#import "GCCGetInfo.h"
#import "GCCDLNA.h"
#import "GCCKeyChain.h"

@interface RecoDishesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,RecoDishesDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableDictionary *selectDic;
@property (nonatomic, copy)   NSString *selectString;
@property (nonatomic, copy)   NSString *selectBoxMac;
@property (nonatomic, strong) RDBoxModel *selectBoxModel;
@property (nonatomic, copy)   NSString *currentTypeUrl;
@property (nonatomic, assign) BOOL isFoodDishs;
@property (nonatomic, assign) BOOL isSingleScreen;

@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) NSInteger resultCount;

@property (nonatomic, strong) UIButton *toScreenBtn;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) UIView *bottomView;

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
    
    [self creatSubViews];
}

- (void)initInfor{
    
    self.dataSource = [NSMutableArray new];
    self.selectArr = [NSMutableArray new];
    self.selectString = [[NSString alloc] init];
    self.selectBoxMac = [[NSString alloc] init];
    self.selectDic = [NSMutableDictionary  dictionary];
    self.currentTypeUrl = [[NSString alloc] init];
    self.selectBoxModel = [[RDBoxModel alloc] init];
    
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    [self autoTitleButtonWith:@"请选择投屏包间"];
    
    if (self.isFoodDishs == YES) {

        NSArray *imgNameArray = [NSArray arrayWithObjects:@"鲍汁扣海参",@"石锅海鲜拼",@"海鲜拼盘",@"江南熟醉大闸蟹",@"京葱山药烧海参",@"海鲜刺身拼盘",@"特色菜6",@"特色菜6",@"特色菜6",@"特色菜6", nil];
        NSArray * sameArr ;
        if ([[NSFileManager defaultManager] fileExistsAtPath:UserSelectDishPath]) {
            sameArr = [NSArray arrayWithContentsOfFile:UserSelectDishPath];
        }
        for (int i = 0 ; i < imgNameArray.count ; i ++) {
            
            RecoDishesModel * tmpModel = [[RecoDishesModel alloc] init];
            tmpModel.selectType = 0;
            tmpModel.cid = i + 100;
            tmpModel.ImgName = imgNameArray[i];
            tmpModel.food_name = imgNameArray[i];
            for (int i = 0; i < sameArr.count; i ++ ) {
                if (tmpModel.cid == [sameArr[i] integerValue]) {
                    tmpModel.selectType = 1;
                    self.toScreenBtn.backgroundColor = UIColorFromRGB(0xff783d);
                    self.toScreenBtn.layer.borderColor = UIColorFromRGB(0xff783d).CGColor;
                    self.toScreenBtn.userInteractionEnabled = YES;
                }
            }
            [self.dataSource addObject:tmpModel];
        }
        self.currentTypeUrl = @"/specialty";
        
    }else{

        NSArray *imgNameArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
        
        NSArray * sameArr ;
        if ([[NSFileManager defaultManager] fileExistsAtPath:UserSelectADPath]) {
            sameArr = [NSArray arrayWithContentsOfFile:UserSelectADPath];
        }
        for (int i = 0 ; i < imgNameArray.count ; i ++) {
            
            RecoDishesModel * tmpModel = [[RecoDishesModel alloc] init];
            tmpModel.selectType = 0;
            tmpModel.cid = i + 100;
            tmpModel.ImgName = imgNameArray[i];
            tmpModel.chinese_name = imgNameArray[i];
            for (int i = 0; i < sameArr.count; i ++ ) {
                if (tmpModel.cid == [sameArr[i] integerValue]) {
                    tmpModel.selectType = 1;
                    self.toScreenBtn.backgroundColor = UIColorFromRGB(0xff783d);
                    self.toScreenBtn.layer.borderColor = UIColorFromRGB(0xff783d).CGColor;
                    self.toScreenBtn.userInteractionEnabled = YES;
                }
            }
            
            [self.dataSource addObject:tmpModel];
        }
        
        self.currentTypeUrl = @"/adv?";
    }
}

- (void)RecoDishesRequest{
    
    [self.dataSource removeAllObjects];
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    GetHotelRecFoodsRequest * request = [[GetHotelRecFoodsRequest alloc] initWithHotelId:[NSString stringWithFormat:@"%ld",[GlobalData shared].hotelId]];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                    self.toScreenBtn.backgroundColor = UIColorFromRGB(0xff783d);
                    self.toScreenBtn.layer.borderColor = UIColorFromRGB(0xff783d).CGColor;
                    self.toScreenBtn.userInteractionEnabled = YES;
                }
            }
            [self.dataSource addObject:tmpModel];
        }
        
        if (resultArr.count > 0) {
            [self.collectionView reloadData];
        }else{
            self.bottomView.hidden = YES;
            self.noDataLabel.hidden = NO;
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[response objectForKey:@"code"] integerValue] == 60007) {
            self.bottomView.hidden = YES;
            self.noDataLabel.hidden = NO;
        }else if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}


- (void)AdVideoListRequest{
    
    [self.dataSource removeAllObjects];
    
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    GetAdvertisingVideoRequest * request = [[GetAdvertisingVideoRequest alloc] initWithHotelId:[NSString stringWithFormat:@"%ld",[GlobalData shared].hotelId]];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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
                    self.toScreenBtn.backgroundColor = UIColorFromRGB(0xff783d);
                    self.toScreenBtn.layer.borderColor = UIColorFromRGB(0xff783d).CGColor;
                    self.toScreenBtn.userInteractionEnabled = YES;
                }
            }
            [self.dataSource addObject:tmpModel];
        }
        
        if (resultArr.count > 0) {
            [self.collectionView reloadData];
        }else{
            self.bottomView.hidden = YES;
            self.noDataLabel.hidden = NO;
        }
        
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[response objectForKey:@"code"] integerValue] == 60013) {
            self.bottomView.hidden = YES;
            self.noDataLabel.hidden = NO;
        }else if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
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
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,50 *scale));
        make.top.mas_equalTo(self.view.mas_bottom).offset(- 50 *scale);
        make.left.mas_equalTo(0);
    }];
    
    self.toScreenBtn = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(15) backgroundColor:[UIColor clearColor] title:@"一键投所选内容" cornerRadius:5.f];
    [self.toScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.toScreenBtn];
    [self.toScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(277 *scale, 36 *scale));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.bottomView.mas_top).offset(7 *scale);
    }];
    self.toScreenBtn.backgroundColor = UIColorFromRGB(0xfecab4);
    self.toScreenBtn.layer.borderColor = UIColorFromRGB(0xfecab4).CGColor;
    self.toScreenBtn.layer.borderWidth = 1.f;
    [self.toScreenBtn addTarget:self action:@selector(toScreenBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.toScreenBtn.userInteractionEnabled = NO;
    
    self.noDataLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xffffff) font:kPingFangLight(15) alignment:NSTextAlignmentCenter];
    self.noDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.noDataLabel.numberOfLines = 0;
    if (self.isFoodDishs == YES) {
        self.noDataLabel.text = @"当前酒楼没有推荐菜\n请联系酒楼维护人员添加";
    }else{
        self.noDataLabel.text = @"当前酒楼没有宣传片\n请联系酒楼维护人员添加";
    }
    self.noDataLabel.textColor = [UIColor blackColor];
    self.noDataLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.noDataLabel];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-(44.f + kStatusBarHeight)/2.f);
        make.height.mas_equalTo(60);
        make.width.mas_greaterThanOrEqualTo(kMainBoundsWidth);
    }];
    self.noDataLabel.hidden = YES;
    
}

#pragma mark - 点击一键投屏所选内容
-(void)toScreenBtnDidClicked:(UIButton *)Btn{
    
    self.isSingleScreen = NO;
    if (!isEmptyString(self.selectBoxMac)) {
        
        self.selectString = @"";
        [self.selectArr removeAllObjects];
        [self.selectDic removeAllObjects];
        
        if (self.isFoodDishs == YES) {
            for (int i = 0 ; i < self.dataSource.count ; i ++) {
                RecoDishesModel *tmpModel = self.dataSource[i];
                if (tmpModel.selectType == 1) {
                    [self.selectArr addObject:[NSString stringWithFormat:@"%ld",tmpModel.cid]];
                    self.selectString = [self.selectString stringByAppendingString:[NSString stringWithFormat:@",%@",tmpModel.food_name]];
                    [self.selectDic setValue:tmpModel.food_name forKey:[NSString stringWithFormat:@"%ld",tmpModel.food_id]];
                }
            }
        }else{
            for (int i = 0 ; i < self.dataSource.count ; i ++) {
                RecoDishesModel *tmpModel = self.dataSource[i];
                if (tmpModel.selectType == 1) {
                    [self.selectArr addObject:[NSString stringWithFormat:@"%ld",tmpModel.cid]];
                    self.selectString = [self.selectString stringByAppendingString:[NSString stringWithFormat:@",%@",tmpModel.chinese_name]];
                    [self.selectDic setValue:tmpModel.chinese_name forKey:[NSString stringWithFormat:@"%ld",tmpModel.cid]];
                }
            }
        }
        if (self.selectArr.count > 0) {
            [self toPostScreenDishData];
        }
        
    }else{
        [MBProgressHUD showTextHUDwithTitle:@"请选择投屏包间"];
    }
}

#pragma mark - 点击投屏单个内容
-(void)toScreen:(RecoDishesModel *)currentModel{
    
    self.isSingleScreen = YES;
    if (!isEmptyString(self.selectBoxMac)) {
        
        self.selectString = @"";
        [self.selectArr removeAllObjects];
        [self.selectDic removeAllObjects];
        
        if (self.isFoodDishs == YES) {
            [self.selectArr addObject:[NSString stringWithFormat:@"%@",currentModel.food_name]];
            self.selectString = [self.selectString stringByAppendingString:[NSString stringWithFormat:@",%ld",currentModel.food_id]];
            [self.selectDic setValue:currentModel.food_name forKey:[NSString stringWithFormat:@"%ld",currentModel.food_id]];
        }else{
            [self.selectArr addObject:[NSString stringWithFormat:@"%ld",currentModel.cid]];
            self.selectString = [self.selectString stringByAppendingString:[NSString stringWithFormat:@",%@",currentModel.chinese_name]];
            [self.selectDic setValue:currentModel.chinese_name forKey:[NSString stringWithFormat:@"%ld",currentModel.cid]];
        }
        [self toPostScreenDishData];
        
    }else{
        [MBProgressHUD showTextHUDwithTitle:@"请选择投屏包间"];
    }
}

#pragma mark - 点击选择多个投屏
-(void)clickSelectManyImage{
    BOOL isAtLeastOne = NO;
    for (int i = 0 ; i < self.dataSource.count ; i ++) {
        RecoDishesModel *tmpModel = self.dataSource[i];
        if (tmpModel.selectType == 1) {
            isAtLeastOne = YES;
            break;
        }
    }
    if (isAtLeastOne) {
        self.toScreenBtn.backgroundColor = UIColorFromRGB(0xff783d);
        self.toScreenBtn.layer.borderColor = UIColorFromRGB(0xff783d).CGColor;
        self.toScreenBtn.userInteractionEnabled = YES;
    }else{
        self.toScreenBtn.backgroundColor = UIColorFromRGB(0xfecab4);
        self.toScreenBtn.layer.borderColor = UIColorFromRGB(0xfecab4).CGColor;
        self.toScreenBtn.userInteractionEnabled = NO;
    }
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
    titleButton.frame = CGRectMake(0, (kMainBoundsWidth - size.width - 30) / 2, size.width + 40, size.height);
    
    [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width + 25, 0, 0)];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10 + 10)];
    
    [titleButton setTitle:title forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
}

//标题被点击的时候
- (void)titleButtonDidBeClicked{
    
    if ([GlobalData shared].boxSource.count == 0) {
        [MBProgressHUD showTextHUDwithTitle:@"未获取到包间信息"];
        [[GCCDLNA defaultManager] getBoxInfoList];
        return;
    }
    
    SelectRoomViewController *srVC = [[SelectRoomViewController alloc] init];
    srVC.dataSource = [GlobalData shared].boxSource;
    [self presentViewController:srVC animated:YES completion:^{
    }];
    srVC.backDatas = ^(RDBoxModel *tmpModel) {
        if (!isEmptyString(tmpModel.sid)) {
            [self autoTitleButtonWith:tmpModel.sid];
            self.selectBoxMac = tmpModel.BoxID;
            self.selectBoxModel = tmpModel;
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

- (void)toPostScreenDishData{
    
    [self SingelDishRequest];

}

// 单机版网络请求
- (void)SingelDishRequest{
    
    NSString *selectIdStr =  [self.selectString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    NSDictionary * parameters;
    NSString *intervalStr;
    if (self.isFoodDishs == YES) {
        
        if (self.selectArr.count > 1) {
            intervalStr = @"30";
        }else{
            intervalStr = @"120";
        }
        parameters = @{
                       @"deviceId" : [GlobalData shared].deviceID,
                       @"deviceName" : [GCCGetInfo getIphoneName],
                       @"interval" : intervalStr,
                       @"name" : selectIdStr
                       };
    }else{
        parameters = @{
                       @"deviceId" : [GlobalData shared].deviceID,
                       @"deviceName" : [GCCGetInfo getIphoneName],
                       @"videos" : selectIdStr
                       };
        
    }
    
    NSString *platformUrl = [NSString stringWithFormat:@"%@%@", STBURL,self.currentTypeUrl];
    
    [SAVORXAPI getWithURL:platformUrl parameters:parameters  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                [MBProgressHUD showTextHUDwithTitle:@"投屏成功"];
                if (self.isSingleScreen == NO) {
                    if (self.isFoodDishs == YES) {
                        [Helper saveFileOnPath:UserSelectDishPath withArray:self.selectArr];
                    }else{
                        [Helper saveFileOnPath:UserSelectADPath withArray:self.selectArr];
                    }
                }
            }else{
                if (!isEmptyString([responseObject objectForKey:@"info"])) {
                    [MBProgressHUD showTextHUDwithTitle:[responseObject objectForKey:@"info"]];
                }else{
                    [MBProgressHUD showTextHUDwithTitle:@"投屏失败"];
                }
            }
        }else{
             [MBProgressHUD showTextHUDwithTitle:@"投屏失败"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if ([GlobalData shared].networkStatus == RDNetworkStatusNotReachable) {
            [MBProgressHUD showTextHUDwithTitle:@"网络已断开，请检查网络"];
        }else {
            [MBProgressHUD showTextHUDwithTitle:@"网络连接超时，请重试"];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
