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
#import "AddressBookTableViewCell.h"

@interface CustomerListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * customerList;
@property (nonatomic, strong) NSDictionary * dataDict;
@property (nonatomic, strong) NSArray * keys;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UISearchController * searchController;

@end

@implementation CustomerListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CustomerBookDidUpdateNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客户列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增客户" style:UIBarButtonItemStyleDone target:self action:@selector(rightAddButtonDidClicked)];
    
    [self createCustomerListUI];
    self.customerList = [[NSMutableArray alloc] init];
    
    [[RDAddressManager manager] getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        self.dataDict = addressBookDict;
        self.keys = nameKeys;
        
        for (NSString * key in self.keys) {
            [self.customerList addObjectsFromArray:[self.dataDict objectForKey:key]];
        }
        
        [self.tableView reloadData];
        
    } authorizationFailure:^(NSError *error) {
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customBookUpdate) name:CustomerBookDidUpdateNotification object:nil];
}

- (void)customBookUpdate
{
    [[RDAddressManager manager] getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        self.dataDict = addressBookDict;
        self.keys = nameKeys;
        [self.tableView reloadData];
        
    } authorizationFailure:^(NSError *error) {
        
    }];
}

- (void)createCustomerListUI
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AddressBookTableViewCell class] forCellReuseIdentifier:@"CustomerListCell"];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    RDSearchView * searchView = [[RDSearchView alloc] initWithFrame:CGRectMake(20, 5, kMainBoundsWidth - 40, 34) placeholder:@"输入姓名/手机号" cornerRadius:5.f font:kPingFangRegular(16 * scale)];
    [headerView addSubview:searchView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchDidClicked)];
    tap.numberOfTapsRequired = 1;
    [headerView addGestureRecognizer:tap];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)searchDidClicked
{
    ResSearchAddressController * search = [[ResSearchAddressController alloc] initWithDataSoucre:self.dataDict keys:self.keys customList:self.customerList isNeedAddButton:NO];
    [self presentViewController:search animated:NO completion:^{
        
    }];
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
    AddressBookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerListCell" forIndexPath:indexPath];
    
    NSString * key = [self.keys objectAtIndex:indexPath.section];
    NSArray * dataArray = [self.dataDict objectForKey:key];
    RDAddressModel * model = [dataArray objectAtIndex:indexPath.row];
    [cell configWithAddressModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 70 * scale;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.keys[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
