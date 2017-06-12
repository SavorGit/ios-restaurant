//
//  RestaurantHomePageViewController.m
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/6/9.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import "RestaurantHomePageViewController.h"
#import "RestHomePageTableViewCell.h"
#import "Masonry.h"

@interface RestaurantHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) UIView * bottomView; //底部控制栏
@property (nonatomic, strong) NSArray * classNameArray;

@end

@implementation RestaurantHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.title = @"小热点-餐厅版";
    self.classNameArray = @[@"幻灯片",@"图片",@"视频",@"文件"];
    [self creatSubViews];

}

//创建子视图
- (void)creatSubViews{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[RestHomePageTableViewCell class] forCellReuseIdentifier:@"homeTableCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    _tableView.backgroundView = nil;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50));
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.textColor = UIColorFromRGB(0x333333);
    tipLabel.text = @"请连接包间WiFi后进行操作";
    [self.bottomView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 95, 30));
        make.top.mas_equalTo(self.bottomView.mas_top).offset(10);
        make.left.mas_equalTo(10);
        
    }];
    
    UIButton *confirmWifiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmWifiBtn setBackgroundColor:RGBCOLOR(253,120,70)];
    confirmWifiBtn.layer.cornerRadius = 5.0;
    [confirmWifiBtn setTitle:@"退出投屏" forState:UIControlStateNormal];
    [confirmWifiBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [confirmWifiBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [confirmWifiBtn addTarget:self action:@selector(goConfirmWifi) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:confirmWifiBtn];
    [confirmWifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 34));
        make.centerY.mas_equalTo(self.bottomView);
        make.right.mas_equalTo(-15);
    }];
}

- (void)goConfirmWifi{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestHomePageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"homeTableCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell configDatas:self.classNameArray withIndex:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([UIScreen mainScreen].bounds.size.height - 124)/4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"---%long",indexPath.row);
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
