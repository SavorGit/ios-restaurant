//
//  MultiSelectAddressController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "MultiSelectAddressController.h"
#import "RDAddressManager.h"
#import "SingleAddressCell.h"
#import "MultiSelectAddressCell.h"
#import "RDSearchView.h"
#import "ResSearchAddressController.h"

@interface MultiSelectAddressController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary * dataDict;
@property (nonatomic, strong) NSArray * keys;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UISearchController * searchController;

@property (nonatomic, strong) NSMutableArray * selectArray;

@property (nonatomic, assign) BOOL isMultiSelect;

@end

@implementation MultiSelectAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"通讯录";
    
    [self createAddressBookUI];
    [[RDAddressManager manager] getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        self.dataDict = addressBookDict;
        self.keys = nameKeys;
        [self.tableView reloadData];
        
    } authorizationFailure:^(NSError *error) {
        
    }];
}

- (void)createAddressBookUI
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SingleAddressCell class] forCellReuseIdentifier:@"SingleAddressCell"];
    [self.tableView registerClass:[MultiSelectAddressCell class] forCellReuseIdentifier:@"MultiSelectAddressCell"];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"多选" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked)];
}

- (void)rightBarButtonItemDidClicked
{
    self.isMultiSelect = !self.isMultiSelect;
    [self.selectArray removeAllObjects];
    if (self.isMultiSelect) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"多选" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked)];
    }
    [self.tableView reloadData];
}

- (void)searchDidClicked
{
    ResSearchAddressController * search = [[ResSearchAddressController alloc] initWithDataSoucre:self.dataDict];
    [self presentViewController:search animated:NO completion:^{
        
    }];
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
    if (self.isMultiSelect) {
        MultiSelectAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MultiSelectAddressCell" forIndexPath:indexPath];
        
        NSString * key = [self.keys objectAtIndex:indexPath.section];
        NSArray * dataArray = [self.dataDict objectForKey:key];
        RDAddressModel * model = [dataArray objectAtIndex:indexPath.row];
        [cell configWithAddressModel:model];
        
        if ([self.selectArray containsObject:model]) {
            [cell mulitiSelected:YES];
        }else{
            [cell mulitiSelected:NO];
        }
        
        return cell;
    }
    SingleAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SingleAddressCell" forIndexPath:indexPath];
    
    NSString * key = [self.keys objectAtIndex:indexPath.section];
    NSArray * dataArray = [self.dataDict objectForKey:key];
    RDAddressModel * model = [dataArray objectAtIndex:indexPath.row];
    [cell configWithAddressModel:model];
    
    cell.addButtonHandle = ^(RDAddressModel *model) {
        
    };
    
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
    if (self.isMultiSelect) {
        NSString * key = [self.keys objectAtIndex:indexPath.section];
        NSArray * dataArray = [self.dataDict objectForKey:key];
        RDAddressModel * model = [dataArray objectAtIndex:indexPath.row];
        
        MultiSelectAddressCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([self.selectArray containsObject:model]) {
            [cell mulitiSelected:NO];
        }else{
            [self.selectArray addObject:model];
            [cell mulitiSelected:YES];
        }
    }
}

- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
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
