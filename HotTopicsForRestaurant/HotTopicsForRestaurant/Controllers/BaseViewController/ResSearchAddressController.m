//
//  ResSearchAddressController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResSearchAddressController.h"
#import "RDAddressModel.h"
#import "AddressBookTableViewCell.h"

@interface ResSearchAddressController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary * dataDict;
@property (nonatomic, strong) NSArray * keys;
@property (nonatomic, strong) NSArray * searchResult;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ResSearchAddressController

- (instancetype)initWithDataSoucre:(NSDictionary *)dataDict
{
    if (self = [super init]) {
        self.dataDict = dataDict;
        self.keys = dataDict.allKeys;
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
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    textField.font = kPingFangRegular(15.f * scale);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = UIColorFromRGB(0x333333);
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 18)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [leftImageView setImage:[UIImage imageNamed:@""]];
    [leftView addSubview:leftImageView];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.cornerRadius = 5.f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor grayColor].CGColor;
    textField.layer.borderWidth = .5f;
    textField.placeholder = @"输入搜索信息";
    [searchView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25.f);
        make.left.mas_equalTo(10.f);
        make.bottom.mas_equalTo(-5.f);
        make.right.mas_equalTo(-60.f);
    }];
    [textField addTarget:self action:@selector(searchTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(endSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(textField.mas_right).offset(10);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-5);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AddressBookTableViewCell class] forCellReuseIdentifier:@"CustomerListCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textField.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
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
    AddressBookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerListCell" forIndexPath:indexPath];
    
    RDAddressModel * model = [self.searchResult objectAtIndex:indexPath.row];
    [cell configWithAddressModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 70 * scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    [self dismissViewControllerAnimated:NO completion:^{
        
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
