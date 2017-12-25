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

@interface ReserveSelectDateViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIView * blackView;

@property(nonatomic, copy) NSString *dateString;
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
}

- (void)initInfo{
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:100];
    
//    for (int i = 0; i < 10; i ++) {
//        ReserveModel *tmpModel = [[ReserveModel alloc] init];
//        tmpModel.dayTitle = @"上午";
//        tmpModel.peopleNum = @"5人";
//        tmpModel.time = @"13:00";
//        tmpModel.name = @"王先生";
//        tmpModel.phone = @"18510378890";
//        tmpModel.welcom = @"欢迎词";
//        tmpModel.imgUrl = @"";
//
//        [self.dataSource addObject:tmpModel];
//    }
}

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    [self creatDatePickView];
    
    UIButton * rightButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xff783e) font:kPingFangRegular(16) backgroundColor:[UIColor clearColor] title:@""];
    [rightButton addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 57, 44);
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
    //    self.tableView.mj_header = [RD_MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    
    UIView *addReBgView = [[UIView alloc] init];
    addReBgView.backgroundColor = [UIColor orangeColor];
    addReBgView.layer.cornerRadius = 22.5f;
    addReBgView.layer.borderWidth = 0.5f;
    addReBgView.layer.masksToBounds = YES;
    addReBgView.layer.borderColor = [UIColor clearColor].CGColor;
    [self.view addSubview:addReBgView];
    [addReBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(230 *scale , 45 *scale));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(- 30);
    }];
    
    UILabel *addReTlabel =[[UILabel alloc] init];
    addReTlabel.text = @"新增预定信息";
    addReTlabel.font = [UIFont systemFontOfSize:15];
    addReTlabel.textColor = [UIColor whiteColor];
    [addReBgView addSubview:addReTlabel];
    [addReTlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120 *scale , 25 *scale));
        make.centerX.mas_equalTo(addReBgView.mas_centerX).offset(25 *scale);
        make.top.mas_equalTo(10 *scale);
    }];
    
    UIImageView *icnImageview = [[UIImageView alloc] init];
    icnImageview.image = [UIImage imageNamed:@"tianjia"];
    [addReBgView addSubview:icnImageview];
    [icnImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20 *scale , 20 *scale));
        make.right.mas_equalTo(addReTlabel.mas_left).offset(- 5 *scale);
        make.top.mas_equalTo(10.25 *scale);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addReserveClick)];
    tap.numberOfTapsRequired = 1;
    [addReBgView addGestureRecognizer:tap];
    
}

#pragma mark - 新增预定
- (void)addReserveClick{
    
    AddNewReserveViewController *rsVC = [[AddNewReserveViewController alloc] init];
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
    NSString *selectDateStr = [formatter stringFromDate:date];
    [self.blackView removeFromSuperview];
    
    ReserveSelectDateViewController *rsVC = [[ReserveSelectDateViewController alloc] initWithDate:selectDateStr];
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
    
    [cell configWithModel:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
