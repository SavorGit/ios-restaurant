//
//  NewDishesViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "NewDishesViewController.h"
#import "NewDishesCollectionViewCell.h"
#import "RecoDishesModel.h"
#import "HelpViewController.h"
#import "SelectRoomViewController.h"
#import "SAVORXAPI.h"
#import "GetHotelRecFoodsRequest.h"
#import "GetAdvertisingVideoRequest.h"
#import "GlobalData.h"
#import "GCCGetInfo.h"
#import "GCCDLNA.h"

@interface NewDishesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,RecoDishesDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableDictionary *selectDic;
@property (nonatomic, copy)   NSString *selectString;
@property (nonatomic, copy)   NSString *currentTypeUrl;
@property (nonatomic, assign) BOOL isSingleScreen;

@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) NSInteger resultCount;

@property (nonatomic, strong) UIButton *toScreenBtn;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) RestaurantServiceModel *boxModel;

@end

@implementation NewDishesViewController

- (instancetype)initWithBoxModel:(RestaurantServiceModel *)model{
    if (self = [super init]) {
        self.boxModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self RecoDishesRequest];
    self.currentTypeUrl = @"/command/screend/recommend";
    
    [self creatSubViews];
    
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
                    self.toScreenBtn.backgroundColor = kAPPMainColor;
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
        [MBProgressHUD showTextHUDwithTitle:@"网络连接失败，请重试"];
    }];
}

- (void)initInfor{
    
    self.dataSource = [NSMutableArray new];
    self.selectArr = [NSMutableArray new];
    self.selectString = [[NSString alloc] init];
    self.selectDic = [NSMutableDictionary  dictionary];
    self.currentTypeUrl = [[NSString alloc] init];
    
    self.view.backgroundColor = VCBackgroundColor;
    
    self.title = @"推荐菜";

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
    [_collectionView registerClass:[NewDishesCollectionViewCell class] forCellWithReuseIdentifier:@"imgCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 50 - 64));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(50 *scale);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    if (isiPhone_X) {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50 *scale + 34);
        }];
    }
    
    self.toScreenBtn = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(15) backgroundColor:[UIColor clearColor] title:@"投屏" cornerRadius:5.f];
    [self.toScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.toScreenBtn];
    [self.toScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(277 *scale, 36 *scale));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.bottomView.mas_top).offset(7 *scale);
    }];
    self.toScreenBtn.backgroundColor = [kAPPMainColor colorWithAlphaComponent:.5f];
    [self.toScreenBtn addTarget:self action:@selector(toScreenBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.toScreenBtn.userInteractionEnabled = NO;
    
    self.noDataLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xffffff) font:kPingFangLight(15) alignment:NSTextAlignmentCenter];
    self.noDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.noDataLabel.numberOfLines = 0;
    self.noDataLabel.text = @"当前无推荐菜内容\n请联系小热点工作人员";
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
    self.selectString = @"";
    [self.selectArr removeAllObjects];
    [self.selectDic removeAllObjects];
    
    for (int i = 0 ; i < self.dataSource.count ; i ++) {
        RecoDishesModel *tmpModel = self.dataSource[i];
        if (tmpModel.selectType == 1) {
            [self.selectArr addObject:[NSString stringWithFormat:@"%ld",tmpModel.cid]];
            self.selectString = [self.selectString stringByAppendingString:[NSString stringWithFormat:@",%ld",tmpModel.food_id]];
            [self.selectDic setValue:tmpModel.food_name forKey:[NSString stringWithFormat:@"%ld",tmpModel.food_id]];
        }
    }
    if (self.selectArr.count > 0) {
        
       [self toPostScreenDishData];
        
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
        self.toScreenBtn.backgroundColor = kAPPMainColor;
        self.toScreenBtn.userInteractionEnabled = YES;
    }else{
        self.toScreenBtn.backgroundColor = [kAPPMainColor colorWithAlphaComponent:.5f];
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
    NewDishesCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
    cell.delegate = self;
    
    RecoDishesModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell configModelData:tmpModel];
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGFloat width = (kMainBoundsWidth - 45) / 2;
    return CGSizeMake(width , 120 *scale);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)toPostScreenDishData{
    
    self.resultCount = 0;
    self.requestCount = 0;
    [MBProgressHUD showLoadingWithText:@"正在投屏" inView:self.view];
    if ([GlobalData shared].callQRCodeURL.length > 0) {
        self.requestCount++;
        [self toPostScreenDataRequest:[GlobalData shared].callQRCodeURL];
    }
    if ([GlobalData shared].secondCallCodeURL.length > 0){
        self.requestCount++;
        [self toPostScreenDataRequest:[GlobalData shared].secondCallCodeURL];
    }
    if([GlobalData shared].thirdCallCodeURL.length > 0){
        self.requestCount++;
        [self toPostScreenDataRequest:[GlobalData shared].thirdCallCodeURL];
    }
}

- (void)toPostScreenDataRequest:(NSString *)baseUrl{
    
    NSString *selectIdStr =  [self.selectString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    NSString *platformUrl = [NSString stringWithFormat:@"%@%@", baseUrl,self.currentTypeUrl];
    NSDictionary * parameters;
    NSInteger totalScreenTime = 0;
    NSString *intervalStr;
    if (self.selectArr.count > 1) {
        intervalStr = @"10";
        totalScreenTime = [intervalStr integerValue] *self.selectArr.count;
    }else{
        intervalStr = @"20";
        totalScreenTime = 120;
    }
    parameters = @{@"boxMac" : self.boxModel.BoxID,@"deviceId" : [GlobalData shared].deviceID,@"deviceName" : [GCCGetInfo getIphoneName],@"interval" : intervalStr,@"specialtyId" : selectIdStr};
    
    [[AFHTTPSessionManager manager] GET:platformUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 10000) {
            [MBProgressHUD showTextHUDwithTitle:@"投屏成功"];
            [self upLogsRequest:@"1" withScreemTime:[NSString stringWithFormat:@"%ld",totalScreenTime]];
            [self.boxModel startPlayDishWithCount:self.selectArr.count];
            [self.navigationController popViewControllerAnimated:YES];

        }else if ([[responseObject objectForKey:@"code"] integerValue] == 10002) {
            
            [MBProgressHUD showTextHUDwithTitle:[responseObject objectForKey:@"msg"]];
            [self upLogsRequest:@"0" withScreemTime:[NSString stringWithFormat:@"%ld",totalScreenTime]];
            
        }else if ([[responseObject objectForKey:@"code"] integerValue] == 10008){
            
            NSString *msgString = [responseObject objectForKey:@"msg"];
            NSArray *msgArray = [msgString componentsSeparatedByString:@","];
            NSMutableString *alertString = [[NSMutableString alloc] init];
            for (int i = 0 ; i < msgArray.count; i ++) {
                NSString *foodName = [self.selectDic objectForKey:msgArray[i]];
                if (i == 0) {
                    [alertString appendString:foodName];
                }else{
                    [alertString appendString:[NSString stringWithFormat:@"、%@",foodName]];
                }
                
            }
            [MBProgressHUD showTextHUDwithTitle:[NSString stringWithFormat:@"您选择的\"%@\"在电视中不存在，无法进行投屏",alertString]];
            [self upLogsRequest:@"0" withScreemTime:[NSString stringWithFormat:@"%ld",totalScreenTime]];
            
        }else{
            if (!isEmptyString([responseObject objectForKey:@"msg"])) {
                [MBProgressHUD showTextHUDwithTitle:[responseObject objectForKey:@"msg"]];
            }else{
                [MBProgressHUD showTextHUDwithTitle:@"投屏失败"];
            }
            [self upLogsRequest:@"0" withScreemTime:[NSString stringWithFormat:@"%ld",totalScreenTime]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.resultCount++;
        if (self.resultCount == self.requestCount) {
            
            if ([GlobalData shared].networkStatus == RDNetworkStatusNotReachable) {
                [MBProgressHUD showTextHUDwithTitle:@"网络已断开，请检查网络"];
            }else {
                [MBProgressHUD showTextHUDwithTitle:@"网络连接超时，请重试"];
            }
            
            [self upLogsRequest:@"0" withScreemTime:[NSString stringWithFormat:@"%ld",totalScreenTime]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)done{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.boxModel.indexPath,@"NSIndexPath", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RDRestaurantServiceModelDidUpdate object:nil userInfo:dic];
}

- (void)upLogsRequest:(NSString *)reState withScreemTime:(NSString *)screemTime{
    
    NSString *screen_type = @"3";
    NSDictionary *parmDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.boxModel.roomID],@"room_id",[NSString stringWithFormat:@"%ld",self.selectArr.count],@"screen_num",reState,@"screen_result",screemTime,@"screen_time",screen_type,@"screen_type", nil];
    [SAVORXAPI upLoadLogRequest:parmDic];
    
}

@end
