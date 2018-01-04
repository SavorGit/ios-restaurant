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

@interface MultiSelectAddressController ()<UITableViewDelegate, UITableViewDataSource, ResSearchAddressDelegate>

@property (nonatomic, strong) NSDictionary * dataDict;
@property (nonatomic, strong) NSArray * keys;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UISearchController * searchController;

@property (nonatomic, strong) NSMutableArray * selectArray;

@property (nonatomic, assign) BOOL isMultiSelect;

@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIButton * allChooseButton;
@property (nonatomic, strong) UIButton * multiAddButton;
@property (nonatomic, assign) BOOL isAllChoose;

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
    
    if (!self.customerList) {
        self.customerList = [[NSMutableArray alloc] init];
        [[RDAddressManager manager] getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
            
            for (NSString * key in nameKeys) {
                [self.customerList addObjectsFromArray:[addressBookDict objectForKey:key]];
            }
            
            [self.tableView reloadData];
            
        } authorizationFailure:^(NSError *error) {
            
        }];
    }
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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 45)];
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
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor grayColor];
    [self.bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    self.allChooseButton = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16) backgroundColor:[UIColor clearColor] title:@"全选"];
    [self.allChooseButton addTarget:self action:@selector(allChooseButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.allChooseButton];
    [self.allChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
    }];
    
    self.multiAddButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(16) backgroundColor:kAPPMainColor title:@"导入" cornerRadius:20];
    [self.bottomView addSubview:self.multiAddButton];
    [self.multiAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(kMainBoundsWidth - 120);
        make.height.mas_equalTo(40);
    }];
    [self.multiAddButton addTarget:self action:@selector(multiAddButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    self.bottomView.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"多选" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked)];
}

- (void)multiAddButtonDidClicked
{
    if (self.selectArray.count == 0) {
        [MBProgressHUD showTextHUDwithTitle:@"至少选择一个联系人"];
    }else{
        MBProgressHUD * hud = [MBProgressHUD showLoadingWithText:@"正在导入" inView:self.view];
        
        [[RDAddressManager manager] addCustomerBook:self.selectArray success:^{
            [hud hideAnimated:YES];
            [self.customerList addObjectsFromArray:self.selectArray];
            [self.selectArray removeAllObjects];
            [self.tableView reloadData];
            [MBProgressHUD showTextHUDwithTitle:@"导入成功"];
        } authorizationFailure:^(NSError *error) {
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDwithTitle:@"导入失败"];
        }];
    }
}

- (void)allChooseButtonDidClicked
{
    self.isAllChoose = !self.isAllChoose;
    if (self.isAllChoose) {
        [self.selectArray removeAllObjects];
        for (NSString * key in self.keys) {
            NSArray * customers = [self.dataDict objectForKey:key];
            [self.selectArray addObjectsFromArray:customers];
        }
        [self.selectArray removeObjectsInArray:self.customerList];
        [self.tableView reloadData];
    }else{
        [self.selectArray removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)rightBarButtonItemDidClicked
{
    self.isMultiSelect = !self.isMultiSelect;
    [self.selectArray removeAllObjects];
    if (self.isMultiSelect) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked)];
        self.bottomView.hidden = NO;
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"多选" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked)];
        self.bottomView.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)searchDidClicked
{
    ResSearchAddressController * search;
    if (self.isMultiSelect) {
        search = [[ResSearchAddressController alloc] initWithDataSoucre:self.dataDict keys:self.keys customList:self.customerList type:SearchAddressTypeMulti];
    }else{
        search = [[ResSearchAddressController alloc] initWithDataSoucre:self.dataDict keys:self.keys customList:self.customerList type:SearchAddressTypeSignle];
    }
    search.delegate = self;
    [self presentViewController:search animated:NO completion:^{
        
    }];
}

- (void)multiAddressDidSelect:(RDAddressModel *)model
{
    NSString * pinYin = model.pinYin;
    NSString * key = [[pinYin substringToIndex:1] uppercaseString];
    NSInteger section = [self.keys indexOfObject:key];
    if (section >= self.keys.count) {
        for (NSInteger i = 0; i < self.keys.count; i++) {
            if ([[self.keys objectAtIndex:i] isEqualToString:key]) {
                key = [self.keys objectAtIndex:i];
                section = i;
            }
        }
    }
    NSArray * array = [self.dataDict objectForKey:key];
    NSInteger row = [array indexOfObject:model];
    NSIndexPath * indexPath =[NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    MultiSelectAddressCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell.hasExist) {
        if ([self.selectArray containsObject:model]) {
            [self.selectArray removeObject:model];
            [cell mulitiSelected:NO];
        }else{
            [self.selectArray addObject:model];
            [cell mulitiSelected:YES];
        }
    }
}

- (void)multiAddressDidUpdate
{
    [self.tableView reloadData];
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
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", model.searchKey];
        NSArray * resultArray = [self.customerList filteredArrayUsingPredicate:predicate];
        if (resultArray && resultArray.count > 0) {
            [cell existCustomer:YES];
        }else{
            [cell existCustomer:NO];
        }
        
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
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", model.searchKey];
    NSArray * resultArray = [self.customerList filteredArrayUsingPredicate:predicate];
    if (resultArray && resultArray.count > 0) {
        [cell existCustomer:YES];
    }else{
        [cell existCustomer:NO];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.addButtonHandle = ^(RDAddressModel *model) {
        
        MBProgressHUD * hud = [MBProgressHUD showLoadingWithText:@"正在导入" inView:weakSelf.view];
        [[RDAddressManager manager] addCustomerBook:@[model] success:^{
            
            [hud hideAnimated:YES];
            [weakSelf.customerList addObject:model];
            [UIView performWithoutAnimation:^{
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [MBProgressHUD showTextHUDwithTitle:@"添加成功"];
            
        } authorizationFailure:^(NSError *error) {
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDwithTitle:@"添加失败"];
            
        }];
    };
    
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

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * key = [self.keys objectAtIndex:indexPath.section];
    NSArray * dataArray = [self.dataDict objectForKey:key];
    RDAddressModel * model = [dataArray objectAtIndex:indexPath.row];
    
    if (self.isMultiSelect) {
        MultiSelectAddressCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (!cell.hasExist) {
            if ([self.selectArray containsObject:model]) {
                [self.selectArray removeObject:model];
                [cell mulitiSelected:NO];
            }else{
                [self.selectArray addObject:model];
                [cell mulitiSelected:YES];
            }
        }
        
        if (self.isAllChoose) {
            self.isAllChoose = NO;
        }
        if (self.selectArray.count == self.customerList.count) {
            [self allChooseButtonDidClicked];
        }
        
    }else{
        
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
