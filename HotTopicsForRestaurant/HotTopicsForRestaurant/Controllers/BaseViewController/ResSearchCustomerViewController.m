//
//  ResSearchCustomerViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "ResSearchCustomerViewController.h"
#import "CustomerTableViewCell.h"
#import "RDAddressManager.h"
#import "AddNewCustomerController.h"

@interface ResSearchCustomerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * customerSource;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) NSArray * searchResult;
@property (nonatomic, strong) UIView * noDataView;

@end

@implementation ResSearchCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customerSource = [[NSMutableArray alloc] init];
    [[RDAddressManager manager] getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        for (NSString * key in nameKeys) {
            [self.customerSource addObjectsFromArray:[addressBookDict objectForKey:key]];
        }
        
    } authorizationFailure:^(NSError *error) {
        
    }];
    
    [self createSearchCustomerUI];
}

- (void)createSearchCustomerUI
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
        make.top.mas_equalTo(kStatusBarHeight + 5.f);
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
    [self.tableView registerClass:[CustomerTableViewCell class] forCellReuseIdentifier:@"CustomerTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchTextField.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    if ([self.searchTextField canBecomeFirstResponder]) {
        [self.searchTextField becomeFirstResponder];
    }
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

- (void)searchTextDidChange:(UITextField *)textField
{
    NSString * searchKey = textField.text;
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!isEmptyString(searchKey)) {
        self.searchResult = [self searchAddressBookWithKeyWord:searchKey];
        
        if (self.searchResult.count == 0) {
            [self showNoDataView];
        }else{
            [self hiddenNoDataView];
        }
        
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
    CustomerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerTableViewCell" forIndexPath:indexPath];
    RDAddressModel * model = [self.searchResult objectAtIndex:indexPath.row];
    [cell configWithAddressModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 62 * scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(searchCustomerDidSelect:)]) {
        
        [_delegate searchCustomerDidSelect:[self.searchResult objectAtIndex:indexPath.row]];
        
    }
    
    [self endSearch];
}

- (NSArray<RDAddressModel *> *)searchAddressBookWithKeyWord:(NSString *)keyWord
{
    NSString * searchStr = keyWord;
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    
    searchStr = [searchStr uppercaseString];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", searchStr];
    NSArray * searchArray = [self.customerSource filteredArrayUsingPredicate:predicate];
    [resultArray addObjectsFromArray:searchArray];
    
    return [NSArray arrayWithArray:resultArray];
}

- (void)endSearch
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (UIView *)noDataView
{
    if (!_noDataView) {
        CGFloat scale = kMainBoundsWidth / 375.f;
        
        _noDataView = [[UIView alloc] initWithFrame:CGRectZero];
        
        UILabel * label = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentCenter];
        label.text = @"请添加客户信息，开始大数据管理";
        [_noDataView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-35 * scale);
            make.height.mas_equalTo(16 * scale);
        }];
        
        UIButton * button = [Helper buttonWithTitleColor:UIColorFromRGB(0x922c3e) font:kPingFangRegular(16 * scale) backgroundColor:[UIColor clearColor] title:@"添加" cornerRadius:5 * scale];
        [_noDataView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).offset(25 * scale);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(90 * scale);
            make.height.mas_equalTo(36 * scale);
        }];
        button.layer.borderColor = kAPPMainColor.CGColor;
        button.layer.borderWidth = .5f;
        [button addTarget:self action:@selector(addButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noDataView;
}

- (void)addButtonDidClicked
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        AddNewCustomerController * addNew = [[AddNewCustomerController alloc] init];
        addNew.customerList = self.customerSource;
        [self.superNavigationController pushViewController:addNew animated:YES];
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
