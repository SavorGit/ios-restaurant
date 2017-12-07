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

@interface RecoDishesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,RecoDishesDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong)  NSMutableDictionary *selectDic;
@property (nonatomic, copy)   NSString *selectString;
@property (nonatomic, copy)   NSString *selectBoxMac;
@property (nonatomic, copy)   NSString *currentTypeUrl;
@property (nonatomic, strong) UIButton *toScreenBtn;
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
        self.currentTypeUrl = @"/command/screend/recommend";
    }else{
        [self AdVideoListRequest];
        self.currentTypeUrl = @"/command/screend/vid";
    }
    [self creatSubViews];
}

- (void)RecoDishesRequest{
    
    [self.dataSource removeAllObjects];
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    GetHotelRecFoodsRequest * request = [[GetHotelRecFoodsRequest alloc] initWithHotelId:@"7"];
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
                }
            }
            [self.dataSource addObject:tmpModel];
        }
        
        [self.collectionView reloadData];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response objectForKey:@"msg"]) {
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
    GetAdvertisingVideoRequest * request = [[GetAdvertisingVideoRequest alloc] initWithHotelId:@"7"];
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
                }
            }
            [self.dataSource addObject:tmpModel];
        }
        
        [self.collectionView reloadData];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}

- (void)initInfor{

    self.dataSource = [NSMutableArray new];
    self.selectArr = [NSMutableArray new];
    self.selectString = [[NSString alloc] init];
    self.selectBoxMac = [[NSString alloc] init];
    self.selectDic = [NSMutableDictionary  dictionary];
    self.currentTypeUrl = [[NSString alloc] init];
    
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
    
    self.toScreenBtn = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(15) backgroundColor:[UIColor clearColor] title:@"一键投所选内容" cornerRadius:5.f];
    [self.toScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:self.toScreenBtn];
    [self.toScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(277 *scale, 36 *scale));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(bottomView.mas_top).offset(7 *scale);
    }];
    self.toScreenBtn.backgroundColor = UIColorFromRGB(0xfecab4);
    self.toScreenBtn.layer.borderColor = UIColorFromRGB(0xfecab4).CGColor;
    self.toScreenBtn.layer.borderWidth = 1.f;
    [self.toScreenBtn addTarget:self action:@selector(toScreenBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 点击一键投屏所选内容
-(void)toScreenBtnDidClicked:(UIButton *)Btn{
    
    if (!isEmptyString(self.selectBoxMac)) {
        
        self.selectString = @"";
        [self.selectArr removeAllObjects];
        [self.selectDic removeAllObjects];
        
        if (self.isFoodDishs == YES) {
            for (int i = 0 ; i < self.dataSource.count ; i ++) {
                RecoDishesModel *tmpModel = self.dataSource[i];
                if (tmpModel.selectType == 1) {
                    [self.selectArr addObject:[NSString stringWithFormat:@"%ld",tmpModel.cid]];
                    self.selectString = [self.selectString stringByAppendingString:[NSString stringWithFormat:@",%ld",tmpModel.food_id]];
                    [self.selectDic setValue:tmpModel.chinese_name forKey:[NSString stringWithFormat:@"%ld",tmpModel.food_id]];
                }
            }
            [Helper saveFileOnPath:UserSelectDishPath withArray:self.selectArr];
        }else{
            for (int i = 0 ; i < self.dataSource.count ; i ++) {
                RecoDishesModel *tmpModel = self.dataSource[i];
                if (tmpModel.selectType == 1) {
                    [self.selectArr addObject:[NSString stringWithFormat:@"%ld",tmpModel.cid]];
                    self.selectString = [self.selectString stringByAppendingString:[NSString stringWithFormat:@",%ld",tmpModel.cid]];
                    [self.selectDic setValue:tmpModel.chinese_name forKey:[NSString stringWithFormat:@"%ld",tmpModel.cid]];
                }
            }
            [Helper saveFileOnPath:UserSelectADPath withArray:self.selectArr];
        }
        [self toPostScreenDishData];
    }else{
        [MBProgressHUD showTextHUDwithTitle:@"请选择投屏包间"];
    }
}

#pragma mark - 点击投屏单个内容
-(void)toScreen:(RecoDishesModel *)currentModel{
    
    if (!isEmptyString(self.selectBoxMac)) {
        
        self.selectString = @"";
        [self.selectArr removeAllObjects];
        [self.selectDic removeAllObjects];
        
        if (self.isFoodDishs == YES) {
            [self.selectArr addObject:[NSString stringWithFormat:@"%ld",currentModel.cid]];
            self.selectString = [self.selectString stringByAppendingString:[NSString stringWithFormat:@",%ld",currentModel.food_id]];
            [self.selectDic setValue:currentModel.chinese_name forKey:[NSString stringWithFormat:@"%ld",currentModel.food_id]];
        }else{
            [self.selectArr addObject:[NSString stringWithFormat:@"%ld",currentModel.cid]];
            self.selectString = [self.selectString stringByAppendingString:[NSString stringWithFormat:@",%ld",currentModel.cid]];
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
    }else{
        self.toScreenBtn.backgroundColor = UIColorFromRGB(0xfecab4);
        self.toScreenBtn.layer.borderColor = UIColorFromRGB(0xfecab4).CGColor;
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
    titleButton.frame = CGRectMake(0, (kMainBoundsWidth - size.width - 30) / 2, size.width + 30, size.height);
    
    [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width + 15, 0, 0)];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10 + 10)];
    
    [titleButton setTitle:title forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
}

//标题被点击的时候
- (void)titleButtonDidBeClicked{
    
    SelectRoomViewController *srVC = [[SelectRoomViewController alloc] init];
    srVC.dataSource = [GlobalData shared].boxSource;
    [self presentViewController:srVC animated:YES completion:^{
    }];
    srVC.backDatas = ^(RDBoxModel *tmpModel) {
        if (!isEmptyString(tmpModel.sid)) {
            [self autoTitleButtonWith:tmpModel.sid];
            self.selectBoxMac = tmpModel.BoxID;
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
    
    if ([GlobalData shared].callQRCodeURL.length > 0) {
        [self toPostScreenDataRequest:[GlobalData shared].callQRCodeURL];
    }
    if ([GlobalData shared].secondCallCodeURL.length > 0){
        [self toPostScreenDataRequest:[GlobalData shared].secondCallCodeURL];
    }
    if([GlobalData shared].thirdCallCodeURL.length > 0){
        [self toPostScreenDataRequest:[GlobalData shared].thirdCallCodeURL];
    }
}

- (void)toPostScreenDataRequest:(NSString *)baseUrl{
    
    NSString *selectIdStr =  [self.selectString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    NSString *platformUrl = [NSString stringWithFormat:@"%@%@", baseUrl,self.currentTypeUrl];
    NSDictionary * parameters;
    if (self.isFoodDishs == YES) {
        NSString *intervalStr;
        if (self.selectArr.count > 1) {
            intervalStr = @"30";
        }else{
            intervalStr = @"120";
        }
        parameters = @{@"boxMac" : self.selectBoxMac,@"deviceId" : [GlobalData shared].deviceID,@"deviceName" : [GCCGetInfo getIphoneName],@"interval" : intervalStr,@"specialtyId" : selectIdStr};
    }else{
        parameters = @{@"boxMac" : self.selectBoxMac,@"deviceId" : [GlobalData shared].deviceID,@"deviceName" : [GCCGetInfo getIphoneName],@"vid" : selectIdStr};
    }
    
    [[AFHTTPSessionManager manager] GET:platformUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([[responseObject objectForKey:@"code"] integerValue] == 10000) {
             [MBProgressHUD showTextHUDwithTitle:@"投屏成功"];
        }else if ([[responseObject objectForKey:@"code"] integerValue] == 10002) {
            [MBProgressHUD showTextHUDwithTitle:[responseObject objectForKey:@"msg"]];
        }else if ([[responseObject objectForKey:@"code"] integerValue] == 10008){
            NSString *msgString = [responseObject objectForKey:@"msg"];
            NSArray *msgArray = [msgString componentsSeparatedByString:@","];
            NSString *alertString = [[NSString alloc] init];
            for (int i = 0 ; i < msgArray.count; i ++) {
                NSString *foodName = [self.selectDic objectForKey:msgArray[i]];
                [alertString stringByAppendingString:[NSString stringWithFormat:@",%@",foodName]];
            }
            [MBProgressHUD showTextHUDwithTitle:[NSString stringWithFormat:@"您选择的\"%@\"在电视中不存在，无法进行投屏",alertString]];
        }else{
            if (!isEmptyString([responseObject objectForKey:@"msg"])) {
                [MBProgressHUD showTextHUDwithTitle:[responseObject objectForKey:@"msg"]];
            }else{
                [MBProgressHUD showTextHUDwithTitle:@"投屏失败"];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
