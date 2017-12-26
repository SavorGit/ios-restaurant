//
//  CustomerViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CustomerViewController.h"
#import "CustomerListViewController.h"

@interface CustomerViewController ()

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客户管理";
    [self createCustomerUI];
}

- (void)createCustomerUI
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"客户列表" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked)];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 150 * scale + 50 * scale + 40 * scale)];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150 * scale + 50 * scale + 40 * scale);
    }];
    
    UIButton * addCumtomerButton  = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) backgroundColor:[UIColor clearColor] title:@"新增客户" cornerRadius:5.f];
    [headerView addSubview:addCumtomerButton];
    [addCumtomerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
        make.height.mas_equalTo(150 * scale);
    }];
    
    UIButton * addInfoButton  = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) backgroundColor:[UIColor clearColor] title:@"新增消费记录" cornerRadius:5.f];
    [headerView addSubview:addInfoButton];
    [addInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
        make.height.mas_equalTo(150 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor grayColor];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.centerX.mas_equalTo(0);
        make.width.mas_offset(.5f);
        make.height.mas_equalTo(130 * scale);
    }];
    
    UILabel * searchTopicLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    searchTopicLabel.text = @"查找客户信息";
    [headerView addSubview:searchTopicLabel];
    [searchTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(20 * scale);
        make.height.mas_equalTo(18 * scale);
    }];
    
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectZero];
    searchView.layer.cornerRadius = 10.f;
    searchView.layer.masksToBounds = YES;
    searchView.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    searchView.layer.borderWidth = .5f;
    [headerView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchTopicLabel.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-20 * scale);
        make.height.mas_equalTo(50 * scale);
    }];
    
    UILabel * searchTitleLabel = [Helper labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    searchTitleLabel.text = @"输入姓名/手机号";
    [searchView addSubview:searchTitleLabel];
    [searchTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(40 * scale);
    }];
}

- (void)rightBarButtonItemDidClicked
{
    CustomerListViewController * list = [[CustomerListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
