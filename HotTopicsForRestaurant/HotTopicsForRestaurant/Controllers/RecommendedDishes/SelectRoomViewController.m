//
//  SelectRoomViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SelectRoomViewController.h"
#import "SelectRoomCollectionCell.h"
#import "RDBoxModel.h"
#import "SAVORXAPI.h"
#import "HTTPServerManager.h"

@interface SelectRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) NSInteger resultCount;
@property (nonatomic, assign) BOOL isNeedUpdateList;
@property (nonatomic, strong) RDBoxModel * tempModel;

@end

@implementation SelectRoomViewController

- (instancetype)initWithNeedUpdateList
{
    if (self = [super init]) {
        self.isNeedUpdateList = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self creatSubViews];
    
}

- (void)initInfor{
    
//    self.dataSource = [NSMutableArray new];
//    for (int i = 0 ; i < 18; i ++) {
//        RecoDishesModel * tmpModel = [[RecoDishesModel alloc] init];
//        tmpModel.chinese_name = @"房间号";
//        [self.dataSource addObject:tmpModel];
//    }
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
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
    [_collectionView registerClass:[SelectRoomCollectionCell class] forCellWithReuseIdentifier:@"selectRoomCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64));
        make.top.mas_equalTo(64 *scale);
        make.left.mas_equalTo(0);
    }];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,64 *scale));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5 * scale);
        make.top.mas_equalTo(20 * scale);
        make.width.mas_equalTo(40 * scale);
        make.height.mas_equalTo(44 * scale);
    }];

    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = kPingFangMedium(15);
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = @"请选择投屏包间";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30 *scale);
        make.top.mas_equalTo(27 *scale);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
    }];
}

#pragma mark - UICollectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectRoomCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"selectRoomCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    RDBoxModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell configModelData:tmpModel];
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGFloat width = (kMainBoundsWidth - 60) / 3;
    return CGSizeMake(width , 36 *scale);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectRoomCollectionCell *tmpCell = (SelectRoomCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    tmpCell.titleLabel.backgroundColor = UIColorFromRGB(0xff783e);
    tmpCell.titleLabel.textColor = UIColorFromRGB(0xffffff);
    RDBoxModel *tmpModel = self.dataSource[indexPath.row];
    
    if (self.backDatas) {
        self.backDatas(tmpModel);
    }
    
    [self back];
    
}

- (void)updateList
{
    self.resultCount = 0;
    self.requestCount = 0;
    [MBProgressHUD showLoadingWithText:@"正在加载" inView:self.view];
    if ([GlobalData shared].callQRCodeURL.length > 0) {
        self.requestCount++;
        [self updateListWithBaseURL:[GlobalData shared].callQRCodeURL];
    }
    if ([GlobalData shared].secondCallCodeURL.length > 0){
        self.requestCount++;
        [self updateListWithBaseURL:[GlobalData shared].secondCallCodeURL];
    }
    if([GlobalData shared].thirdCallCodeURL.length > 0){
        self.requestCount++;
        [self updateListWithBaseURL:[GlobalData shared].thirdCallCodeURL];
    }
}

- (void)updateListWithBaseURL:(NSString *)baseURL
{
    if ([GlobalData shared].hotelId != [GlobalData shared].userModel.hotelID) {
        self.resultCount++;
        if (self.resultCount == self.requestCount) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showTextHUDwithTitle:@"投屏失败, 请连接到对应酒楼网络"];
        }
        return;
    }
    
    NSString *platformUrl = [NSString stringWithFormat:@"%@/command/getHotelBox", baseURL];
    NSDictionary * parameters = @{@"hotelId" : [NSString stringWithFormat:@"%ld", [GlobalData shared].hotelId]};
    [AFHTTPSessionManager manager].requestSerializer.timeoutInterval = 8.f;
    [[AFHTTPSessionManager manager] GET:platformUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 10000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSArray * boxArray = [responseObject objectForKey:@"result"];
            if ([boxArray isKindOfClass:[NSArray class]]) {
                
                RDBoxModel * tmpModel;
                NSMutableArray * tempArray = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < boxArray.count; i++) {
                    NSDictionary * boxInfo = [boxArray objectAtIndex:i];
                    if ([boxInfo isKindOfClass:[NSDictionary class]]) {
                        RDBoxModel * model = [[RDBoxModel alloc] init];
                        model.BoxID = [boxInfo objectForKey:@"box_mac"];
                        model.BoxIP = [[boxInfo objectForKey:@"box_ip"] stringByAppendingString:@":8080"];
                        model.roomID = [[boxInfo objectForKey:@"room_id"] integerValue];
                        model.sid = [boxInfo objectForKey:@"box_name"];
                        model.hotelID = [GlobalData shared].hotelId;
                        
                        if ([model.sid isEqualToString:self.tempModel.sid]) {
                            tmpModel = model;
                        }
                        
                        [tempArray addObject:model];
                    }
                }
                [GlobalData shared].boxSource = [NSArray arrayWithArray:tempArray];
                
                if ([HTTPServerManager checkHttpServerWithBoxIP:tmpModel.BoxIP]) {
                    
                    if (![tmpModel.sid isEqualToString:[Helper getWifiName]]){
                        [GlobalData shared].cacheModel = tmpModel;
                        [SAVORXAPI showAlertWithWifiName:tmpModel.sid];
                    }else{
                        [GlobalData shared].RDBoxDevice = [[RDBoxModel alloc] init];
                        [[GlobalData shared] bindToRDBoxDevice:tmpModel];
                    }
                    
                    [self back];
                }else if (![tmpModel.sid isEqualToString:[Helper getWifiName]]) {
                    [GlobalData shared].cacheModel = tmpModel;
                    [SAVORXAPI showAlertWithWifiName:tmpModel.sid];
                    [self back];
                }else{
                    [MBProgressHUD showTextHUDwithTitle:@"包间电视连接失败，请检查是否开机"];
                }
                
            }
        }else{
            self.resultCount++;
            if (self.resultCount == self.requestCount) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showTextHUDwithTitle:@"投屏失败"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.resultCount++;
        if (self.resultCount == self.requestCount) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showTextHUDwithTitle:@"投屏失败, 请检查网络连接"];
        }
    }];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:^{
                             }];
}

//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回当前屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
