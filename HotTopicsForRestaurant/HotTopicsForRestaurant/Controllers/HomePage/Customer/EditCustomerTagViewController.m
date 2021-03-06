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

@interface EditCustomerTagViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITextField * tagTextFiled;

@property (nonatomic, strong) RDAddressModel * model;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) CustomerTagView * tagView;
@property (nonatomic, strong) NSMutableArray * tagSource;
@property (nonatomic, assign) BOOL isCustomer;

@end

@implementation EditCustomerTagViewController

- (instancetype)initWithModel:(RDAddressModel *)model andIsCustomer:(BOOL)isCustomer
{
    if (self = [super init]) {
        self.model = model;
        self.isCustomer = isCustomer;
        [self createEditCustomerTagView];
    }
    return self;
}

- (void)didSelectWithIDs:(NSArray *)idArray
{
    self.tagView.lightIDArray = [NSMutableArray arrayWithArray:idArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择标签";
    
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
    self.tagTextFiled.placeholder = @"请手动添加列表中没有的标签";
    [self.view addSubview:self.tagTextFiled];
    [self.tagTextFiled addTarget:self action:@selector(infoTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tagTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(40 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
    }];
    
    UIButton * addButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(16 * scale) backgroundColor:kAPPMainColor title:@"添加"];
    addButton.frame = CGRectMake(0, 0, 70 * scale, 40 * scale);
    [addButton addTarget:self action:@selector(addButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.tagTextFiled.rightView = addButton;
    self.tagTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    self.tagView = [[CustomerTagView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 40 * scale)];
    self.tagView.lightEnbale = YES;
    self.tagView.isCustomer = self.isCustomer;
    self.tagView.addressModel = self.model;
    
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

- (void)infoTextDidChange:(UITextField *)textField
{
    NSInteger kMaxLength = 10;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

- (void)addButtonDidClicked:(UIButton *)button
{
    button.enabled = NO;
    NSString * tagText = self.tagTextFiled.text;
    if (isEmptyString(tagText)) {
        [MBProgressHUD showTextHUDwithTitle:@"请输入标签信息"];
        button.enabled = YES;
    }else{
        if ([self.tagView.titleArray containsObject:tagText]) {
            
            [MBProgressHUD showTextHUDwithTitle:@"已经存在相同标签"];
            button.enabled = YES;
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
                    self.tagTextFiled.text = @"";
                }
                button.enabled = YES;
                
            } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                if ([response objectForKey:@"msg"]) {
                    [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
                }else{
                    [MBProgressHUD showTextHUDwithTitle:@"添加失败"];
                }
                button.enabled = YES;
                
            } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
                
                [MBProgressHUD showTextHUDwithTitle:@"标签添加失败"];
                button.enabled = YES;
                
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(customerTagDidUpdateWithLightData:lightID:)]) {
        
        [_delegate customerTagDidUpdateWithLightData:[self.tagView getLightTagSource] lightID:self.tagView.lightIDArray];
        
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
