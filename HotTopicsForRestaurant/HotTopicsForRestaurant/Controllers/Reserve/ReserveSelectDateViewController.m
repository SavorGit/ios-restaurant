//
//  ReserveSelectDateViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReserveSelectDateViewController.h"
#import "ReserveTableViewCell.h"
#import "ReserveModel.h"
#import "AddNewReserveViewController.h"
#import "ReserveSelectDateViewController.h"
#import "ReserveOrderListRequest.h"
#import "ReserveDetailViewController.h"
#import "MJRefresh.h"

@interface ReserveSelectDateViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIView * blackView;

@property(nonatomic, copy) NSString *dateString;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation ReserveSelectDateViewController

- (instancetype)initWithDate:(NSString *)dateStr
{
    if (self = [super init]) {
        self.dateString = dateStr;
        self.title = dateStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self creatSubViews];
    [self ReserveListRequest];
}

- (void)initInfo{
    self.pageNum = 1;
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:100];
}

- (void)ReserveListRequest{
    
    [self.dataSource removeAllObjects];
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_date":self.dateString,
                              @"page_num":@"",
                              };
    ReserveOrderListRequest * request = [[ReserveOrderListRequest alloc] initWithPubData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *resultArr = [response objectForKey:@"result"];
        
        if ([[response objectForKey:@"code"] integerValue]  == 10000) {
            for (int i = 0 ; i < resultArr.count ; i ++) {
                
                NSDictionary *tmpDic = resultArr[i];
                ReserveModel * tmpModel = [[ReserveModel alloc] initWithDictionary:tmpDic];
                [self.dataSource addObject:tmpModel];
            }
            [self.tableView reloadData];
        }
        
        
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

- (void)getMoreListRequest{
    
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_date":self.dateString,
                              @"page_num":[NSString stringWithFormat:@"%ld",self.pageNum],
                              };
//    NSLog(@"------%@",parmDic);
    ReserveOrderListRequest * request = [[ReserveOrderListRequest alloc] initWithPubData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *resultArr = [response objectForKey:@"result"];
        
        if (resultArr.count == 0 || resultArr == nil) {
            self.pageNum --;
            [MBProgressHUD showTextHUDwithTitle:@"没有更多的数据了"];
            return ;
        }
        if ([[response objectForKey:@"code"] integerValue]  == 10000) {
            for (int i = 0 ; i < resultArr.count ; i ++) {
                
                NSDictionary *tmpDic = resultArr[i];
                ReserveModel * tmpModel = [[ReserveModel alloc] initWithDictionary:tmpDic];
                [self.dataSource addObject:tmpModel];
            }
            [self.tableView reloadData];
        }
        
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        self.pageNum --;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        self.pageNum --;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    [self creatDatePickView];
    
    UIButton * rightButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xff783e) font:kPingFangRegular(16) backgroundColor:[UIColor clearColor] title:@""];
    [rightButton addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"rili"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 18, 18);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    //创建tableView动画加载头视图
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRefresh];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerRefresh];
    }];
    
    UIView *addReBgView = [[UIView alloc] init];
    addReBgView.backgroundColor = UIColorFromRGB(0x922c3e);
    addReBgView.layer.cornerRadius = 20.f;
    addReBgView.layer.masksToBounds = YES;
    [self.view addSubview:addReBgView];
    [addReBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240 *scale , 40 *scale));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(- 30);
    }];
    
    UILabel *addReTlabel =[[UILabel alloc] init];
    addReTlabel.text = @"添加预定信息";
    addReTlabel.backgroundColor = [UIColor clearColor];
    addReTlabel.font = kPingFangLight(16);
    addReTlabel.textColor = UIColorFromRGB(0xf6f2ed);
    [addReBgView addSubview:addReTlabel];
    [addReTlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90 *scale , 20 *scale));
        make.centerX.mas_equalTo(addReBgView.mas_centerX).offset(19 *scale);
        make.centerY.mas_equalTo(addReBgView.mas_centerY);
    }];
    
    UIImageView *icnImageview = [[UIImageView alloc] init];
    icnImageview.image = [UIImage imageNamed:@"tj"];
    [addReBgView addSubview:icnImageview];
    [icnImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14 *scale , 14 *scale));
        make.right.mas_equalTo(addReTlabel.mas_left).offset(- 5 *scale);
        make.centerY.mas_equalTo(addReBgView.mas_centerY);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addReserveClick)];
    tap.numberOfTapsRequired = 1;
    [addReBgView addGestureRecognizer:tap];
    
}

#pragma mark - 头部刷新
- (void)headerRefresh{
    self.pageNum = 1;
    // 结束刷新
    [self.tableView.mj_header endRefreshing];
    [self ReserveListRequest];
    
}

#pragma mark - 底部刷新
- (void)footerRefresh{
    
    self.pageNum ++;
    // 结束刷新
    [self.tableView.mj_footer endRefreshing];
    [self getMoreListRequest];
}

#pragma mark - 新增预定
- (void)addReserveClick{
    
    AddNewReserveViewController *rsVC = [[AddNewReserveViewController alloc] initWithDataModel:nil andType:YES];
    [self.navigationController pushViewController:rsVC animated:YES];
    
}

- (void)creatDatePickView{
    
    self.blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    
    [self.blackView addSubview:self.datePicker];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.datePicker.frame.origin.y - 50, kMainBoundsWidth, 50)];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    [self.blackView addSubview:view];
    
    UIButton * cancle = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(18) backgroundColor:[UIColor clearColor] title:@"取消"];
    cancle.frame = CGRectMake(10, 10, 60, 40);
    [view addSubview:cancle];
    [cancle addTarget:self.blackView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(18) backgroundColor:[UIColor clearColor] title:@"完成"];
    button.frame = CGRectMake(kMainBoundsWidth - 70, 10, 60, 40);
    [view addSubview:button];
    [button addTarget:self action:@selector(dateDidBeChoose) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 日期选择完成
- (void)dateDidBeChoose
{
    NSDate * date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateString = [formatter stringFromDate:date];
    [self.blackView removeFromSuperview];
    
    [self ReserveListRequest];
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kMainBoundsHeight / 3 * 2, kMainBoundsWidth, kMainBoundsHeight / 3)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minimumDate = [NSDate date];
        _datePicker.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _datePicker;
}

- (void)rightItemDidClicked{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReserveModel * model = [self.dataSource objectAtIndex:indexPath.row];
    static NSString *cellID = @"ReserveTableViewCell";
    ReserveTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ReserveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    [cell configWithModel:model andIndex:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReserveModel *tmpModel = self.dataSource[indexPath.row];
    
    ReserveDetailViewController *rdVC = [[ReserveDetailViewController alloc] initWithDataModel:tmpModel];
    [self.navigationController pushViewController:rdVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
