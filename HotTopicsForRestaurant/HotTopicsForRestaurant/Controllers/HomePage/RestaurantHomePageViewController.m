//
//  RestaurantHomePageViewController.m
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/6/9.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import "RestaurantHomePageViewController.h"
#import "RestHomePageTableViewCell.h"
#import "ResSliderViewController.h"
#import "RestaurantPhotoTool.h"
#import "Helper.h"
#import "RDAlertView.h"
#import "RDAlertAction.h"

@interface RestaurantHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) UIView * bottomView; //底部控制栏
@property (nonatomic, strong) NSArray * classNameArray;
@property (nonatomic, strong) UIButton *confirmWifiBtn;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation RestaurantHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addNotifiCation];
    
    self.navigationItem.title = @"小热点-餐厅版";
    self.classNameArray = @[@"幻灯片",@"图片",@"视频",@"文件"];
    [self creatSubViews];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidFoundBoxSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidNotFoundSenceNotification object:nil];
}

- (void)addNotifiCation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundBoxSence) name:RDDidFoundBoxSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notFoundSence) name:RDDidNotFoundSenceNotification object:nil];
}

// 发现了盒子环境
- (void)foundBoxSence{
    
    if ([GlobalData shared].hotelId) {
        self.tipLabel.text = [NSString stringWithFormat:@"当前连接包间:%@",[Helper getWifiName]];
    }else{
        self.tipLabel.text = [NSString stringWithFormat:@"当前连接WiFi:%@",[Helper getWifiName]];
    }
    self.confirmWifiBtn.hidden = NO;
    
}

- (void)notFoundSence{
    
    self.tipLabel.text = @"请连接包间WiFi后进行操作";
    self.confirmWifiBtn.hidden = YES;
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
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:16];
    self.tipLabel.textColor = UIColorFromRGB(0x333333);
    self.tipLabel.text = @"请连接包间WiFi后进行操作";
    [self.bottomView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 95, 30));
        make.top.mas_equalTo(self.bottomView.mas_top).offset(10);
        make.left.mas_equalTo(10);
        
    }];
    
    self.confirmWifiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmWifiBtn setBackgroundColor:RGBCOLOR(253,120,70)];
    self.confirmWifiBtn.layer.cornerRadius = 5.0;
    [self.confirmWifiBtn setTitle:@"退出投屏" forState:UIControlStateNormal];
    [self.confirmWifiBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.confirmWifiBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.confirmWifiBtn addTarget:self action:@selector(goConfirmWifi) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.confirmWifiBtn];
    [self.confirmWifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 34));
        make.centerY.mas_equalTo(self.bottomView);
        make.right.mas_equalTo(-15);
    }];
}

- (void)goConfirmWifi{
    RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确定要退出%@包间的投屏吗",[Helper getWifiName]]];
    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
    } bold:NO];
    RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
        NSLog(@"退出投屏。");
    } bold:NO];
    [alertView addActions:@[action,actionOne]];
    [alertView show];
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
    
//    [[NSFileManager defaultManager] removeItemAtPath:ResSliderLibraryPath error:nil];
    
    NSLog(@"---%long",indexPath.row);
    
    [RestaurantPhotoTool checkUserLibraryAuthorizationStatusWithSuccess:^{
        ResSliderViewController * slider = [[ResSliderViewController alloc] init];
        [self.navigationController pushViewController:slider animated:YES];
    } failure:^(NSError *error) {
        
    }];
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
