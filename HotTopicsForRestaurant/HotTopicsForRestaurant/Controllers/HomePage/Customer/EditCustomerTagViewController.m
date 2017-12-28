//
//  EditCustomerTagViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "EditCustomerTagViewController.h"
#import "GetCustomerTagRequest.h"
#import "CustomerTagView.h"
#import "AddCustomerTagRequest.h"

@interface EditCustomerTagViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField * tagTextFiled;

@property (nonatomic, strong) RDAddressModel * model;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) CustomerTagView * tagView;
@property (nonatomic, strong) NSMutableArray * tagSource;

@end

@implementation EditCustomerTagViewController

- (instancetype)initWithModel:(RDAddressModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createEditCustomerTagView];
    
    GetCustomerTagRequest * request;
    if (self.model) {
        request = [[GetCustomerTagRequest alloc] initWithCustomerID:self.model.customer_id];
    }else{
        request = [[GetCustomerTagRequest alloc] initWithCustomerID:nil];
    }
    
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        NSArray * list = [result objectForKey:@"list"];
        if ([list isKindOfClass:[NSArray class]]) {
            [self.tagSource addObjectsFromArray:list];
            [self.tagView reloadTagSource:self.tagSource];
            [self.tableView reloadData];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取标签失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDwithTitle:@"获取标签失败"];
        
    }];
}

- (void)createEditCustomerTagView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tagTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    
    self.tagTextFiled.font = kPingFangRegular(15.f * scale);
    self.tagTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tagTextFiled.textColor = UIColorFromRGB(0x333333);
    self.tagTextFiled.layer.cornerRadius = 5.f;
    self.tagTextFiled.layer.masksToBounds = YES;
    self.tagTextFiled.layer.borderColor = [UIColor grayColor].CGColor;
    self.tagTextFiled.layer.borderWidth = .5f;
    self.tagTextFiled.placeholder = @"输入搜索信息";
    [self.view addSubview:self.tagTextFiled];
    [self.tagTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(40 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
    }];
    
    UIButton * addButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(16 * scale) backgroundColor:kAPPMainColor title:@"添加"];
    addButton.frame = CGRectMake(0, 0, 70 * scale, 40 * scale);
    [addButton addTarget:self action:@selector(addButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tagTextFiled.rightView = addButton;
    self.tagTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    self.tagView = [[CustomerTagView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 40 * scale)];
    self.tagView.lightEnbale = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = self.tagView;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagTextFiled.mas_bottom).offset(20 * scale);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10 * scale);
    }];
}

- (void)addButtonDidClicked
{
    NSString * tagText = self.tagTextFiled.text;
    if (isEmptyString(tagText)) {
        [MBProgressHUD showTextHUDwithTitle:@"请输入标签信息"];
    }else{
        if ([self.tagView.titleArray containsObject:tagText]) {
            
            [MBProgressHUD showTextHUDwithTitle:@"已经存在相同标签"];
            
        }else{
            
            AddCustomerTagRequest * request;
            if (self.model) {
                request = [[AddCustomerTagRequest alloc] initWithCustomerID:self.model.customer_id tagName:tagText];
            }else{
                request = [[AddCustomerTagRequest alloc] initWithCustomerID:nil tagName:tagText];
            }
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSDictionary * result = [response objectForKey:@"result"];
                NSDictionary * list = [result objectForKey:@"list"];
                if ([list isKindOfClass:[NSDictionary class]]) {
                    [self.tagSource addObject:list];
                    [self.tagView reloadTagSource:self.tagSource];
                    [MBProgressHUD showTextHUDwithTitle:@"添加成功"];
                }
                
            } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                if ([response objectForKey:@"msg"]) {
                    [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
                }else{
                    [MBProgressHUD showTextHUDwithTitle:@"添加失败"];
                }
                
            } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
                [MBProgressHUD showTextHUDwithTitle:@"添加失败"];
            }];
            
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xece6de);
    
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_delegate && [_delegate respondsToSelector:@selector(customerTagDidUpdateWithData:)]) {
        
        [_delegate customerTagDidUpdateWithData:[self.tagView getLightTagSource]];
        
    }
}

- (NSMutableArray *)tagSource
{
    if (!_tagSource) {
        _tagSource = [[NSMutableArray alloc] init];
    }
    return _tagSource;
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
