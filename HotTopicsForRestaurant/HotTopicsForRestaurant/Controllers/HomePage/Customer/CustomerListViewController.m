//
//  CustomerListViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CustomerListViewController.h"
#import "RDAddressManager.h"
#import "RDSearchView.h"
#import "AddNewCustomerController.h"
#import "ResSearchAddressController.h"
#import "CustomerTableViewCell.h"
#import "CustomerDetailViewController.h"
#import "ResSearchCustomerViewController.h"

@interface CustomerListViewController ()<UITableViewDelegate, UITableViewDataSource,ResSearchCustomerDelegate>

@property (nonatomic, strong) NSMutableArray * customerList;
@property (nonatomic, strong) NSDictionary * dataDict;
@property (nonatomic, strong) NSArray * keys;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UISearchController * searchController;
@property (nonatomic, strong) UIView * noDataView;

@end

@implementation CustomerListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CustomerBookDidUpdateNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客户列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"tjkh2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightAddButtonDidClicked)];
    
    [self createCustomerListUI];
    self.customerList = [[NSMutableArray alloc] init];
    
    [[RDAddressManager manager] getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        self.dataDict = addressBookDict;
        self.keys = nameKeys;
        
        for (NSString * key in self.keys) {
            [self.customerList addObjectsFromArray:[self.dataDict objectForKey:key]];
        }
        
        [self.tableView reloadData];
        if (nameKeys.count == 0) {
            [self showNoDataView];
        }
        
    } authorizationFailure:^(NSError *error) {
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customBookUpdate) name:CustomerBookDidUpdateNotification object:nil];
}

- (void)showNoDataView
{
    if (!self.noDataView.superview) {
        [self.view addSubview:self.noDataView];
        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
}

- (void)hiddenNoDataView
{
    if (self.noDataView.superview) {
        [self.noDataView removeFromSuperview];
    }
}

- (void)customBookUpdate
{
    [[RDAddressManager manager] getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        self.dataDict = addressBookDict;
        self.keys = nameKeys;
        
        [self.tableView reloadData];
        if (nameKeys.count == 0) {
            [self showNoDataView];
        }
        
    } authorizationFailure:^(NSError *error) {
        
    }];
}

- (void)createCustomerListUI
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CustomerTableViewCell class] forCellReuseIdentifier:@"CustomerTableViewCell"];
    self.tableView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = UIColorFromRGB(0x666666);
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 54 * scale)];
    headerView.backgroundColor = UIColorFromRGB(0xece6de);
    RDSearchView * searchView = [[RDSearchView alloc] initWithFrame:CGRectMake(10 * scale, 9 * scale, kMainBoundsWidth - 20 * scale, 36 * scale) placeholder:@"输入姓名或手机号查找客户" cornerRadius:5.f font:kPingFangRegular(13 * scale)];
    searchView.backgroundColor = searchView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [headerView addSubview:searchView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchDidClicked)];
    tap.numberOfTapsRequired = 1;
    [headerView addGestureRecognizer:tap];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)searchDidClicked
{
    ResSearchCustomerViewController * search = [[ResSearchCustomerViewController alloc] init];
    search.delegate = self;
    search.superNavigationController = self.navigationController;
    [self presentViewController:search animated:NO completion:^{
        
    }];
}

- (void)searchCustomerDidSelect:(RDAddressModel *)model
{
    CustomerDetailViewController *cdVC = [[CustomerDetailViewController alloc] initWithDataModel:model];
    [self.navigationController pushViewController:cdVC animated:YES];
}

- (void)rightAddButtonDidClicked
{
    AddNewCustomerController * addNew = [[AddNewCustomerController alloc] init];
    addNew.customerList = self.customerList;
    [self.navigationController pushViewController:addNew animated:YES];
}

#pragma mark -- UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataDict.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * key = [self.keys objectAtIndex:section];
    return [self.dataDict[key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerTableViewCell" forIndexPath:indexPath];
    
    NSString * key = [self.keys objectAtIndex:indexPath.section];
    NSArray * dataArray = [self.dataDict objectForKey:key];
    RDAddressModel * model = [dataArray objectAtIndex:indexPath.row];
    [cell configWithAddressModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 62 * scale;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.keys[section];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = UIColorFromRGB(0x666666);
    header.contentView.backgroundColor = UIColorFromRGB(0xe2ded9);
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * key = [self.keys objectAtIndex:indexPath.section];
    NSArray * dataArray = [self.dataDict objectForKey:key];
    RDAddressModel * model = [dataArray objectAtIndex:indexPath.row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(customerListDidSelect:)]) {
        [_delegate customerListDidSelect:model];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        CustomerDetailViewController *cdVC = [[CustomerDetailViewController alloc] initWithDataModel:model];
        [self.navigationController pushViewController:cdVC animated:YES];
    }
}

- (UIView *)noDataView
{
    if (!_noDataView) {
        CGFloat scale = kMainBoundsWidth / 375.f;
        
        _noDataView = [[UIView alloc] initWithFrame:CGRectZero];
        
        UILabel * label = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentCenter];
        label.text = @"暂无此号码的记录";
        [_noDataView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-35 * scale);
            make.height.mas_equalTo(16 * scale);
        }];
        
        UIButton * button = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(16 * scale) backgroundColor:[UIColor clearColor] title:@"添加" cornerRadius:5 * scale];
        [_noDataView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).offset(25 * scale);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(90 * scale);
            make.height.mas_equalTo(36 * scale);
        }];
        button.layer.borderColor = kAPPMainColor.CGColor;
        button.layer.borderWidth = .5f;
        [button addTarget:self action:@selector(rightAddButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noDataView;
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
