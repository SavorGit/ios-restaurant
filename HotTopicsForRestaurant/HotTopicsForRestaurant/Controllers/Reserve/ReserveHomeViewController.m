//
//  ReserveHomeViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReserveHomeViewController.h"
#import "CustomDateView.h"
#import "ReserveTableViewCell.h"
#import "ReserveModel.h"
#import "ReserveSelectDateViewController.h"
#import "AddNewReserveViewController.h"
#import "ReserveDetailViewController.h"
#import "ReserveOrderListRequest.h"

#import "MJRefresh.h"

@interface ReserveHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, strong) NSMutableArray * dateArray; //数据源
@property (nonatomic, strong) NSString * currentDayStr;
@property (nonatomic, strong) UILabel *noDatalabel;

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIView * blackView;
@property (nonatomic, assign) NSInteger pageNum;


@end

@implementation ReserveHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
     [self ReserveListRequest];
    [self creatSubViews];
}

- (void)initInfo{
    
    self.pageNum = 1;
    self.dataSource = [NSMutableArray new];
    self.dateArray = [NSMutableArray new];
    self.currentDayStr = [[NSString alloc] init];
    self.view.backgroundColor = UIColorFromRGB(0xece6de);
    
    [self initDateSouce];
    
}

- (void)ReserveListRequest{
    
    [self.dataSource removeAllObjects];
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_date":self.currentDayStr,
                              @"page_num":@"",
                              };
    ReserveOrderListRequest * request = [[ReserveOrderListRequest alloc] initWithPubData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        NSArray *resultArr = [response objectForKey:@"result"];
        
        if ([[response objectForKey:@"code"] integerValue]  == 10000) {
            if (resultArr.count > 0) {
                 self.noDatalabel.hidden = YES;
                for (int i = 0 ; i < resultArr.count ; i ++) {
                    
                    NSDictionary *tmpDic = resultArr[i];
                    ReserveModel * tmpModel = [[ReserveModel alloc] initWithDictionary:tmpDic];
                    [self.dataSource addObject:tmpModel];
                    
                }
                [self.tableView reloadData];
            }else{
                self.noDatalabel.hidden = NO;
                [self.tableView reloadData];
            }
            
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}

- (void)getMoreListRequest{
    
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_date":self.currentDayStr,
                              @"page_num":[NSString stringWithFormat:@"%ld",self.pageNum],
                              };
//    NSLog(@"------%@",parmDic);
    ReserveOrderListRequest * request = [[ReserveOrderListRequest alloc] initWithPubData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
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
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        self.pageNum --;
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}

#pragma mark - 初始化日期数据
- (void)initDateSouce{
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterOne = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatterOne setDateFormat:@"MM/dd"];
    NSDate *date = [NSDate date];//今天
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
    NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSDate *afterToDat = [NSDate dateWithTimeInterval: 2 *24*60*60 sinceDate:date];//大后天
    
    NSArray *peraonArray = [NSArray arrayWithObjects:@"昨天",@"今天",@"明天",@"后天", nil];
    NSArray *tmpArray = [NSArray arrayWithObjects:lastDay,date, nextDat,afterToDat,nil];
    for (int i = 0; i < tmpArray.count; i ++) {
        ReserveModel *tmpModel = [[ReserveModel alloc] init];
        tmpModel.totalDay = [formatter stringFromDate:tmpArray[i]];
        tmpModel.displayDay = [formatterOne stringFromDate:tmpArray[i]];
        tmpModel.personDay = peraonArray[i];
        tmpModel.dishNum = @"18";
        [self.dateArray addObject:tmpModel];
    }
    self.currentDayStr = [formatter stringFromDate:date];
    
}

- (void)creatSubViews{
    
    [self creatHeadView];
    [self creatDatePickView];
    
    CGFloat scale = kMainBoundsWidth / 375.0;
    
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
        make.top.mas_equalTo(87.5 + 15);
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
        make.bottom.mas_equalTo(- (44 + 15));
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
    
    self.noDatalabel =[[UILabel alloc] init];
    self.noDatalabel.text = @"请添加预定信息，开始大数据管理";
    self.noDatalabel.backgroundColor = [UIColor clearColor];
    self.noDatalabel.font = kPingFangRegular(15);
    self.noDatalabel.textColor = UIColorFromRGB(0x434343);
    self.noDatalabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noDatalabel];
    [self.noDatalabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth , 20));
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
    }];
    self.noDatalabel.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addReserveClick)];
    tap.numberOfTapsRequired = 1;
    [addReBgView addGestureRecognizer:tap];
    
}

#pragma mark - 头部刷新
- (void)headerRefresh{
    self.pageNum = 1;
    [self ReserveListRequest];
    
}

#pragma mark - 底部刷新
- (void)footerRefresh{
    
    self.pageNum ++;
    // 结束刷新
    [self.tableView.mj_footer endRefreshing];
    [self getMoreListRequest];
}

- (void)creatHeadView{
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = UIColorFromRGB(0xeee8e0);
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 87.5));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xe1dbd4);
    [headView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 0.5f));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(headView.mas_bottom).offset(- 0.5f);
    }];
    
    CustomDateView *dateView = [[CustomDateView alloc] initWithData:self.dateArray handler:^(ReserveModel *tmpModel){
        self.currentDayStr = tmpModel.totalDay;
        [self ReserveListRequest];
    }];
    [dateView configSelectWithTag:1];
    [headView addSubview:dateView];
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
    self.currentDayStr = [formatter stringFromDate:date];
    [self.blackView removeFromSuperview];
    
    ReserveSelectDateViewController *rsVC = [[ReserveSelectDateViewController alloc] initWithDate:self.currentDayStr];
    [self.navigationController pushViewController:rsVC animated:YES];
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

#pragma mark - 点击弹出日期
- (void)rightItemDidClicked{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
}

#pragma mark - 新增预定
- (void)addReserveClick{
    
    AddNewReserveViewController *rsVC = [[AddNewReserveViewController alloc] initWithDataModel:nil andType:YES];
    [self.navigationController pushViewController:rsVC animated:YES];
    rsVC.backB = ^(NSString *backStr) {
        [self ReserveListRequest];
    };
    
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
    rdVC.backB = ^(NSString *backStr) {
        [self ReserveListRequest];
    };
    
}

- (void)dealloc{
    
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

@end
