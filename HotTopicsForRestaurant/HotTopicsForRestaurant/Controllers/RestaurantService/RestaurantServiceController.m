//
//  RestaurantServiceController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RestaurantServiceController.h"
#import "RestaurantServiceCell.h"
#import "RestaurantServiceStatusView.h"
#import "RestaurantServiceModel.h"
#import "NewKeyWordViewController.h"
#import "NewDishesViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "GCCGetInfo.h"
#import "SAVORXAPI.h"

@interface RestaurantServiceController ()<UITableViewDelegate, UITableViewDataSource, RestaurantServiceDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) RestaurantServiceStatusView * statusView;

@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) NSInteger resultCount;

@property (nonatomic, strong) RestaurantServiceModel * model;

@end

@implementation RestaurantServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self createSubViews];
    
    [self setUpBoxSource];
}

- (void)setUpBoxSource
{
    if (nil == [GlobalData shared].resServiceModelSource || [GlobalData shared].resServiceModelSource.count == 0) {
        [self updateList];
    }else{
        [self setUpModelSource];
    }
}


#pragma mark - 点击投屏欢迎词和推荐菜
- (void)toPostWelAndDishData{
    
    self.resultCount = 0;
    self.requestCount = 0;
    [MBProgressHUD showLoadingWithText:@"正在投屏" inView:self.view];
    if ([GlobalData shared].callQRCodeURL.length > 0) {
        self.requestCount++;
        [self toScreenWelAndDishDataRequest:[GlobalData shared].callQRCodeURL];
    }
    if ([GlobalData shared].secondCallCodeURL.length > 0){
        self.requestCount++;
        [self toScreenWelAndDishDataRequest:[GlobalData shared].secondCallCodeURL];
    }
    if([GlobalData shared].thirdCallCodeURL.length > 0){
        self.requestCount++;
        [self toScreenWelAndDishDataRequest:[GlobalData shared].thirdCallCodeURL];
    }
}

- (void)toScreenWelAndDishDataRequest:(NSString *)baseUrl{
    
    NSString *platformUrl = [NSString stringWithFormat:@"%@/command/screend/word_recomm", baseUrl];
    
    NSDictionary *parameters = @{@"boxMac" : self.model.BoxID,@"deviceId" : [GlobalData shared].deviceID,@"deviceName" : [GCCGetInfo getIphoneName],@"templateId" : @"1",@"word" : self.model.DefaultWord};
    
    [[AFHTTPSessionManager manager] GET:platformUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 10000) {
            
            [MBProgressHUD showTextHUDwithTitle:@"投屏成功"];
            [self.model startPlayWord];
            
        }else if ([[responseObject objectForKey:@"code"] integerValue] == 10002) {
            
            [MBProgressHUD showTextHUDwithTitle:[responseObject objectForKey:@"msg"]];
            
        }else{
            if (!isEmptyString([responseObject objectForKey:@"msg"])) {
                [MBProgressHUD showTextHUDwithTitle:[responseObject objectForKey:@"msg"]];
            }else{
                [MBProgressHUD showTextHUDwithTitle:@"投屏失败"];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.resultCount++;
        if (self.resultCount == self.requestCount) {
            
            if ([GlobalData shared].networkStatus == RDNetworkStatusNotReachable) {
                [MBProgressHUD showTextHUDwithTitle:@"网络已断开，请检查网络"];
            }else {
                [MBProgressHUD showTextHUDwithTitle:@"网络连接超时，请重试"];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

#pragma mark - 点击停止投屏
- (void)toStopScreenType:(RestaurantServiceHandleType)type{
    
    self.resultCount = 0;
    self.requestCount = 0;
    [MBProgressHUD showLoadingWithText:@"正在投屏" inView:self.view];
    if ([GlobalData shared].callQRCodeURL.length > 0) {
        self.requestCount++;
        [self toStopScreen:[GlobalData shared].callQRCodeURL type:type];
    }
    if ([GlobalData shared].secondCallCodeURL.length > 0){
        self.requestCount++;
        [self toStopScreen:[GlobalData shared].secondCallCodeURL type:type];
    }
    if([GlobalData shared].thirdCallCodeURL.length > 0){
        self.requestCount++;
        [self toStopScreen:[GlobalData shared].thirdCallCodeURL type:type];
    }
}

- (void)toStopScreen:(NSString *)baseUrl type:(RestaurantServiceHandleType)type{
    
    NSString *platformUrl = [NSString stringWithFormat:@"%@/command/screend/stop", baseUrl];
    
    NSDictionary *parameters = @{@"boxMac" : self.model.BoxID,@"deviceId" : [GlobalData shared].deviceID,@"deviceName" : [GCCGetInfo getIphoneName]};
    
    [[AFHTTPSessionManager manager] GET:platformUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 10000) {
            
            [MBProgressHUD showTextHUDwithTitle:@"已停止投屏"];
            
            if (type == RestaurantServiceHandle_WordStop) {
                [self.model userStopPlayWord];
            }else if (type == RestaurantServiceHandle_DishStop){
                [self.model userStopPlayDish];
            }
            
        }else if ([[responseObject objectForKey:@"code"] integerValue] == 10002) {
            
            [MBProgressHUD showTextHUDwithTitle:[responseObject objectForKey:@"msg"]];
            
        }else{
            if (!isEmptyString([responseObject objectForKey:@"msg"])) {
                [MBProgressHUD showTextHUDwithTitle:[responseObject objectForKey:@"msg"]];
            }else{
                [MBProgressHUD showTextHUDwithTitle:@"操作失败"];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.resultCount++;
        if (self.resultCount == self.requestCount) {
            
            if ([GlobalData shared].networkStatus == RDNetworkStatusNotReachable) {
                [MBProgressHUD showTextHUDwithTitle:@"网络已断开，请检查网络"];
            }else {
                [MBProgressHUD showTextHUDwithTitle:@"网络连接超时，请重试"];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
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
            [MBProgressHUD showTextHUDwithTitle:@"请连接到对应酒楼网络"];
        }
        return;
    }
    
    NSString *platformUrl = [NSString stringWithFormat:@"%@/command/getHotelBox", baseURL];
    NSDictionary * parameters = @{@"hotelId" : [NSString stringWithFormat:@"%ld", [GlobalData shared].hotelId]};
    [AFHTTPSessionManager manager].requestSerializer.timeoutInterval = 8.f;
    [[AFHTTPSessionManager manager] GET:platformUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 10000) {
            NSArray * boxArray = [responseObject objectForKey:@"result"];
            if ([boxArray isKindOfClass:[NSArray class]]) {
                
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
                        
                        if ([model.sid isEqualToString:[Helper getWifiName]]) {
                            [[GlobalData shared] bindToRDBoxDevice:model];
                        }
                        
                        [tempArray addObject:model];
                    }
                }
                if (tempArray.count == 0) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showTextHUDwithTitle:@"暂时没有可操作的包间"];
                }else{
                    [GlobalData shared].boxSource = [NSArray arrayWithArray:tempArray];
                    
                    NSMutableArray * serviceArray = [[NSMutableArray alloc] init];
                    for (RDBoxModel * model in tempArray) {
                        RestaurantServiceModel * serviceModel = [[RestaurantServiceModel alloc] initWithBoxModel:model];
                        [serviceArray addObject:serviceModel];
                    }
                    [GlobalData shared].resServiceModelSource = [NSArray arrayWithArray:serviceArray];
                    
                    [self setUpModelSource];
                }
            }
        }else{
            self.resultCount++;
            if (self.resultCount == self.requestCount) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showTextHUDwithTitle:@"包间获取失败"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.resultCount++;
        if (self.resultCount == self.requestCount) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showTextHUDwithTitle:@"包间获取失败"];
        }
    }];
}

- (void)setUpModelSource
{
    [self.dataSource addObjectsFromArray:[GlobalData shared].resServiceModelSource];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewCellShouldUpdate:) name:RDRestaurantServiceModelDidUpdate object:nil];
}

- (void)tableViewCellShouldUpdate:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;
    NSIndexPath * indexPath = [info objectForKey:@"indexPath"];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)createSubViews
{
    self.navigationItem.title = @"餐厅服务";
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.statusView = [[RestaurantServiceStatusView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[RestaurantServiceCell class] forCellReuseIdentifier:@"RestaurantServiceCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusView.mas_bottom).offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantServiceCell" forIndexPath:indexPath];
    
    RestaurantServiceModel * model = [self.dataSource objectAtIndex:indexPath.row];
    model.indexPath = indexPath;
    cell.delegate = self;
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 235 * scale;
}

 - (void)RestaurantServiceDidHandle:(RestaurantServiceHandleType)type model:(RestaurantServiceModel *)model
{
    self.model = model;
    switch (type) {
        case RestaurantServiceHandle_Word:
        {
            NewKeyWordViewController * word = [[NewKeyWordViewController alloc] initWithModel:model];
            [self.navigationController pushViewController:word animated:YES];
        }
            
            break;
            
        case RestaurantServiceHandle_Dish:
            
        {
            NewDishesViewController * dish= [[NewDishesViewController alloc] initWithBoxModel:model];
            [self.navigationController pushViewController:dish animated:YES];
        }
            break;
            
        case RestaurantServiceHandle_WordPlay:
        {
            [self toPostWelAndDishData];
        }
            
            break;
            
        case RestaurantServiceHandle_WordStop:
        {
            [self toStopScreenType:RestaurantServiceHandle_WordStop];
        }
            break;
            
        case RestaurantServiceHandle_DishPlay:
            
            break;
            
        case RestaurantServiceHandle_DishStop:
        {
            [self toStopScreenType:RestaurantServiceHandle_DishStop];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDRestaurantServiceModelDidUpdate object:nil];
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
