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
@property (nonatomic, assign) BOOL isNeedAddButton; //是否是多选状态
@property (nonatomic, assign) BOOL singleIsUpdate; //单选添加是否需要更新

@end

@implementation ResSearchAddressController

- (instancetype)initWithDataSoucre:(NSDictionary *)dataDict keys:(NSArray *)keys customList:(NSMutableArray *)customerList isNeedAddButton:(BOOL)isNeedAddButton
{
    if (self = [super init]) {
        self.dataDict = dataDict;
        self.keys = keys;
        self.customerList = customerList;
        self.isNeedAddButton = isNeedAddButton;
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
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44 + kStatusBarHeight);
    }];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    self.searchTextField.font = kPingFangRegular(15.f * scale);
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.textColor = UIColorFromRGB(0x333333);
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 18)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [leftImageView setImage:[UIImage imageNamed:@""]];
    [leftView addSubview:leftImageView];
    
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.layer.cornerRadius = 5.f;
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.searchTextField.layer.borderWidth = .5f;
    self.searchTextField.placeholder = @"输入搜索信息";
    [searchView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25.f);
        make.left.mas_equalTo(10.f);
        make.bottom.mas_equalTo(-5.f);
        make.right.mas_equalTo(-60.f);
    }];
    [self.searchTextField addTarget:self action:@selector(searchTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(endSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(self.searchTextField.mas_right).offset(10);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-5);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SingleAddressCell class] forCellReuseIdentifier:@"SingleAddressCell"];
    [self.tableView registerClass:[AddressBookTableViewCell class] forCellReuseIdentifier:@"AddressBookTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchTextField.mas_bottom);
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
    if (self.isNeedAddButton) {
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
    return 70 * scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isNeedAddButton) {
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
    if (self.isNeedAddButton && self.singleIsUpdate) {
        if (_delegate && [_delegate respondsToSelector:@selector(multiAddressDidUpdate)]) {
            [_delegate multiAddressDidUpdate];
        }
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.searchTextField.isFirstResponder) {
            [self.searchTextField resignFirstResponder];
        }
    }];
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
