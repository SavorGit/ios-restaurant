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
#import "UIView+Additional.h"
#import "ConnectMaskingView.h"

@interface RestaurantHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) UIView * bottomView; //底部控制栏
@property (nonatomic, strong) NSArray * classNameArray;
@property (nonatomic, strong) UIButton *confirmWifiBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic ,strong) UIView *maskingView;

@end

@implementation RestaurantHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:VCBackgroundColor];
    [self addNotifiCation];

    self.classNameArray = @[@"幻灯片",@"图片",@"视频",@"文件"];
    
    [self creatSubViews];

}

//创建子视图
- (void)creatSubViews{
    
    // 设置自定义的title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    titleLabel.text = @"小热点-餐厅版";
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
   self.navigationItem.titleView = titleLabel;
    
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
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 10)];
    _tableView.tableHeaderView = view;
    
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
    [self.confirmWifiBtn addTarget:self action:@selector(quitScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.confirmWifiBtn];
    self.confirmWifiBtn.hidden = YES;
    [self.confirmWifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 34));
        make.centerY.mas_equalTo(self.bottomView);
        make.right.mas_equalTo(-15);
    }];
    
    if ([GlobalData shared].scene != RDSceneHaveRDBox) {
        self.tipLabel.text = [NSString stringWithFormat:@"当前连接WiFi:%@",[Helper getWifiName]];
        self.confirmWifiBtn.hidden = NO;
    }
}

#pragma mark - show view
-(void)showViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _maskingView.bottom = keyWindow.bottom;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        _maskingView.bottom = keyWindow.top;
        
    } completion:^(BOOL finished) {
        
        [_maskingView removeFromSuperview];
        _maskingView = nil;
        
    }];
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
    [RestaurantPhotoTool checkUserLibraryAuthorizationStatusWithSuccess:^{
        ResSliderViewController * slider = [[ResSliderViewController alloc] init];
        [self.navigationController pushViewController:slider animated:YES];
    } failure:^(NSError *error) {
        
    }];
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

- (void)quitScreen{
    
    if ([GlobalData shared].scene != RDSceneHaveRDBox) {
        
        RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确定要退出\"%@\"包间的投屏吗",[Helper getWifiName]]];
        RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
        } bold:NO];
        RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
            NSLog(@"退出投屏。");
        } bold:NO];
        [alertView addActions:@[action,actionOne]];
        [alertView show];
        
    }else{
        
        [[GCCDLNA defaultManager] startSearchPlatform];
        [self creatMaskingView];
    }
    
}

- (void)creatMaskingView{
    
    _maskingView = [[ConnectMaskingView alloc] initWithFrame:self.view.frame];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    _maskingView.bottom = keyWindow.top;
    [keyWindow addSubview:_maskingView];
    [self showViewWithAnimationDuration:0.3];
    
}

// 发现了盒子环境
- (void)foundBoxSence{
    
    if ([GlobalData shared].hotelId) {
        self.tipLabel.text = [NSString stringWithFormat:@"当前连接包间:%@",[Helper getWifiName]];
    }else{
        self.tipLabel.text = [NSString stringWithFormat:@"当前连接WiFi:%@",[Helper getWifiName]];
    }
    self.confirmWifiBtn.hidden = NO;
    if (_maskingView) {
        [self dismissViewWithAnimationDuration:0.5f ];
    }
}

// 没有发现环境
- (void)notFoundSence{
    
    self.tipLabel.text = @"请连接包间WiFi后进行操作";
    self.confirmWifiBtn.hidden = YES;
}

- (void)stopSearchDevice{
    
    [self dismissViewWithAnimationDuration:0.5f];
    
    RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"连接失败，请重新连接"]];
    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
        if (_maskingView) {
            [self dismissViewWithAnimationDuration:0.5f ];
        }
    } bold:NO];
    RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
        [[GCCDLNA defaultManager] startSearchPlatform];
        [self creatMaskingView];
        NSLog(@"重新连接");
    } bold:NO];
    [alertView addActions:@[action,actionOne]];
    [alertView show];

}

- (void)addNotifiCation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundBoxSence) name:RDDidFoundBoxSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notFoundSence) name:RDDidNotFoundSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSearchDevice) name:RDStopSearchDeviceNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidFoundBoxSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidNotFoundSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDStopSearchDeviceNotification object:nil];
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
