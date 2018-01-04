//
//  CustomerViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CustomerViewController.h"
#import "CustomerListViewController.h"
#import "AddNewCustomerController.h"
#import "AddNewPayViewController.h"
#import "CustomerHandleTableViewCell.h"
#import "GetCustomerHistoryRequest.h"
#import "ResSearchAddressController.h"
#import "RDAddressManager.h"
#import "RDSearchView.h"

@interface CustomerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel * alertLabel;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客户管理";
    self.dataSource = [[NSMutableArray alloc] init];
    [self createCustomerUI];
}

- (void)createCustomerUI
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"khlb"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked)];
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 130 * scale + 54 * scale + 33 * scale)];
    headerView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(130 * scale + 50 * scale + 40 * scale);
    }];
    
    UIButton * addCumtomerButton  = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) backgroundColor:UIColorFromRGB(0xf6f2ed) title:@""];
    [addCumtomerButton addTarget:self action:@selector(addCustomerButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addCumtomerButton];
    [addCumtomerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
        make.height.mas_equalTo(130 * scale);
    }];
    
    UIImageView * addImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [addImageView setImage:[UIImage imageNamed:@"tjkh"]];
    [addCumtomerButton addSubview:addImageView];
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-20 * scale);
        make.width.height.mas_equalTo(60 * scale);
    }];
    
    UILabel * addLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentCenter];
    addLabel.text = @"添加客户";
    [addCumtomerButton addSubview:addLabel];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addImageView.mas_bottom).offset(10 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIButton * addInfoButton  = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) backgroundColor:UIColorFromRGB(0xf6f2ed) title:@""];
    [addInfoButton addTarget:self action:@selector(addInfoDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addInfoButton];
    [addInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
        make.height.mas_equalTo(130 * scale);
    }];
    
    UIImageView * addInfoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [addInfoImageView setImage:[UIImage imageNamed:@"tjkh"]];
    [addInfoButton addSubview:addInfoImageView];
    [addInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-20 * scale);
        make.width.height.mas_equalTo(60 * scale);
    }];
    
    UILabel * addInfoLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentCenter];
    addInfoLabel.text = @"添加消费记录";
    [addInfoButton addSubview:addInfoLabel];
    [addInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addInfoImageView.mas_bottom).offset(10 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.centerX.mas_equalTo(0);
        make.width.mas_offset(.5f);
        make.height.mas_equalTo(100 * scale);
    }];
    
    UIView * searchBgView = [[UIView alloc] initWithFrame:CGRectZero];
    searchBgView.backgroundColor = UIColorFromRGB(0xece6de);
    [headerView addSubview:searchBgView];
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addInfoButton.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(54 * scale);
    }];
    
    UITapGestureRecognizer * searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapDidClicked)];
    searchTap.numberOfTapsRequired = 1;
    [searchBgView addGestureRecognizer:searchTap];
    
    RDSearchView * searchView = [[RDSearchView alloc] initWithFrame:CGRectZero placeholder:@"输入姓名或手机号查找客户" cornerRadius:5 * scale font:kPingFangRegular(13 * scale)];
    searchView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [searchBgView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9 * scale);
        make.left.mas_equalTo(10 * scale);
        make.right.mas_equalTo(-10 * scale);
        make.height.mas_equalTo(36 * scale);
    }];
    
    UILabel * searchTopicLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    searchTopicLabel.backgroundColor = UIColorFromRGB(0xf6f2ed);
    searchTopicLabel.text = @"最近操作";
    [headerView addSubview:searchTopicLabel];
    [searchTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(18 * scale);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CustomerHandleTableViewCell class] forCellReuseIdentifier:@"CustomerHandleTableViewCell"];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchTopicLabel.mas_bottom).offset(25 * scale);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    self.alertLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentCenter];
    self.alertLabel.numberOfLines = 0;
    self.alertLabel.text = @"这里展示近期操作的客户列表\n方便您快速查找与维护客户信息";
    [self.view addSubview:self.alertLabel];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableView);
        make.centerY.mas_equalTo(self.tableView).offset(-25);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
    }];
}

- (void)searchTapDidClicked
{
//    [[RDAddressManager manager] getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
//        
//        ResSearchAddressController * search = [[ResSearchAddressController alloc] initWithDataSoucre:addressBookDict keys:nameKeys customList:<#(NSMutableArray *)#> type:<#(SearchAddressType)#>]
//        
//    } authorizationFailure:^(NSError *error) {
//        
//    }];
}

- (void)setCustomerData
{
    GetCustomerHistoryRequest * request = [[GetCustomerHistoryRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray * list = [result objectForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:list];
                [self.tableView reloadData];
            }
        }
        
        if (self.dataSource.count == 0) {
            self.alertLabel.hidden = NO;
        }else{
            self.alertLabel.hidden = YES;
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (self.dataSource.count == 0) {
            self.alertLabel.hidden = NO;
        }else{
            self.alertLabel.hidden = YES;
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        if (self.dataSource.count == 0) {
            self.alertLabel.hidden = NO;
        }else{
            self.alertLabel.hidden = YES;
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerHandleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerHandleTableViewCell" forIndexPath:indexPath];
    
    NSDictionary * info = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithInfo:info];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 62 * scale;
}

- (void)addInfoDidClicked
{
    AddNewPayViewController * add = [[AddNewPayViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)addCustomerButtonDidClicked
{
    AddNewCustomerController * addNew = [[AddNewCustomerController alloc] init];
    [self.navigationController pushViewController:addNew animated:YES];
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
    [self setCustomerData];
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
