//
//  ResSearchAddressController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResSearchAddressController.h"
#import "RDAddressModel.h"
#import "SingleAddressCell.h"
#import "RDAddressManager.h"
#import "AddressBookTableViewCell.h"

@interface ResSearchAddressController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) NSDictionary * dataDict;
@property (nonatomic, strong) NSArray * keys;
@property (nonatomic, strong) NSArray * searchResult;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * customerList;
@property (nonatomic, assign) SearchAddressType type; //是否是多选状态
@property (nonatomic, assign) BOOL singleIsUpdate; //单选添加是否需要更新

@end

@implementation ResSearchAddressController

- (instancetype)initWithDataSoucre:(NSDictionary *)dataDict keys:(NSArray *)keys customList:(NSMutableArray *)customerList type:(SearchAddressType)type
{
    if (self = [super init]) {
        self.dataDict = dataDict;
        self.keys = keys;
        self.customerList = customerList;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSearchUI];
}

- (void)createSearchUI
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectZero];
    searchView.backgroundColor = UIColorFromRGB(0xece6de);
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(54 * scale + kStatusBarHeight);
    }];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    self.searchTextField.font = kPingFangRegular(13.f * scale);
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.textColor = UIColorFromRGB(0x333333);
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33 * scale, 17 * scale)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8 * scale, 0, 17 * scale, 17 * scale)];
    [leftImageView setImage:[UIImage imageNamed:@"sousuo"]];
    [leftView addSubview:leftImageView];
    
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.layer.cornerRadius = 5.f;
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.layer.borderColor = UIColorFromRGB(0xe1dbd4).CGColor;
    self.searchTextField.layer.borderWidth = .5f;
    self.searchTextField.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.searchTextField.placeholder = @"输入姓名或手机号查找客户";
    [searchView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight + 9 * scale);
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(-9 * scale);
        make.right.mas_equalTo(-60 * scale);
    }];
    [self.searchTextField addTarget:self action:@selector(searchTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton * cancelButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(16 * scale) backgroundColor:[UIColor clearColor] title:@"取消"];
    [cancelButton addTarget:self action:@selector(endSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22 * scale);
        make.left.mas_equalTo(self.searchTextField.mas_right).offset(5 * scale);
        make.bottom.mas_equalTo(-5 * scale);
        make.right.mas_equalTo(-5 * scale);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [self.tableView registerClass:[SingleAddressCell class] forCellReuseIdentifier:@"SingleAddressCell"];
    [self.tableView registerClass:[AddressBookTableViewCell class] forCellReuseIdentifier:@"AddressBookTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    if ([self.searchTextField canBecomeFirstResponder]) {
        [self.searchTextField becomeFirstResponder];
    }
}

- (void)searchTextDidChange:(UITextField *)textField
{
    NSString * searchKey = textField.text;
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!isEmptyString(searchKey)) {
        self.searchResult = [self searchAddressBookWithKeyWord:searchKey];
    }else{
        self.searchResult = [NSArray new];
    }
    [self.tableView reloadData];
}

#pragma mark -- UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == SearchAddressTypeSignle) {
        SingleAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SingleAddressCell" forIndexPath:indexPath];
        
        RDAddressModel * model = [self.searchResult objectAtIndex:indexPath.row];
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
            [[RDAddressManager manager] addCustomerBook:@[model] success:^{
                
                weakSelf.singleIsUpdate = YES;
                [weakSelf.customerList addObject:model];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [MBProgressHUD showTextHUDwithTitle:@"添加成功"];
                
            } authorizationFailure:^(NSError *error) {
                
            }];
        };
        
        return cell;
    }
    
    AddressBookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookTableViewCell" forIndexPath:indexPath];
    RDAddressModel * model = [self.searchResult objectAtIndex:indexPath.row];
    [cell configWithAddressModel:model];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", model.searchKey];
    NSArray * resultArray = [self.customerList filteredArrayUsingPredicate:predicate];
    if (resultArray && resultArray.count > 0) {
        [cell existCustomer:YES];
    }else{
        [cell existCustomer:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 62 * scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == SearchAddressTypeMulti) {
        if (_delegate && [_delegate respondsToSelector:@selector(multiAddressDidSelect:)]) {
            [_delegate multiAddressDidSelect:[self.searchResult objectAtIndex:indexPath.row]];
        }
        [self endSearch];
    }
}

- (NSArray<RDAddressModel *> *)searchAddressBookWithKeyWord:(NSString *)keyWord
{
    NSString * searchStr = keyWord;
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    for (NSString * key in self.keys) {
        NSArray * array = [self.dataDict objectForKey:key];
        
        searchStr = [searchStr uppercaseString];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", searchStr];
        
        NSArray * searchArray = [array filteredArrayUsingPredicate:predicate];
        [resultArray addObjectsFromArray:searchArray];
    }
    return [NSArray arrayWithArray:resultArray];
}

- (void)endSearch
{
    if (self.type == SearchAddressTypeSignle && self.singleIsUpdate) {
        if (_delegate && [_delegate respondsToSelector:@selector(multiAddressDidUpdate)]) {
            [_delegate multiAddressDidUpdate];
        }
    }
    
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回当前屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
