//
//  AddNewPayViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/26.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddNewPayViewController.h"
#import "CustomerListViewController.h"
#import "CustomerTagView.h"
#import "CustomerPayHistory.h"

@interface AddNewPayViewController ()<UITableViewDelegate, UITableViewDataSource, CustomerListDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UITextField * firstTelField; //手机号
@property (nonatomic, strong) UITextField * nameField; //姓名

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * logoLabel;
@property (nonatomic, strong) CustomerTagView * tagView;
@property (nonatomic, strong) CustomerPayHistory * historyView;

@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) NSMutableArray * tagSource;

@property (nonatomic, strong) RDAddressModel * model;

@end

@implementation AddNewPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createAddNewPayView];
}

- (void)createAddNewPayView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 190 * scale)];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    self.nameField = [self textFieldWithPlaceholder:@"请输入姓名" leftImageNamed:@""];
    [self.topView addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(30 * scale);
        make.width.mas_equalTo(kMainBoundsWidth-125 * scale);
    }];
    
    self.firstTelField = [self textFieldWithPlaceholder:@"请输入手机号" leftImageNamed:@""];
    [self.topView addSubview:self.firstTelField];
    [self.firstTelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameField.mas_bottom).offset(30 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(30 * scale);
        make.width.mas_equalTo(kMainBoundsWidth-125 * scale);
    }];
    [self.firstTelField addTarget:self action:@selector(telNumberValueDidChange) forControlEvents:UIControlEventEditingChanged];
    
    UIButton * logoButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(14 * scale) backgroundColor:[UIColor clearColor] title:@""];
    [logoButton addTarget:self action:@selector(logoButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:logoButton];
    [logoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.nameField.mas_right);
        make.bottom.mas_equalTo(self.firstTelField.mas_bottom);
        make.width.mas_equalTo(110 * scale);
    }];
    
    self.logoImageView = [[UIImageView alloc] init];
    [logoButton addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40 * scale);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(50 * scale);
    }];
    self.logoImageView.backgroundColor = [UIColor grayColor];
    
    self.logoLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentCenter];
    self.logoLabel.text = @"选择客户";
    [logoButton addSubview:self.logoLabel];
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(90 * scale);
        make.height.mas_equalTo(15 * scale);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(10 *scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = VCBackgroundColor;
    [self.topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTelField.mas_bottom).offset(15 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(5 * scale);
    }];
    
    UILabel * tagLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    [self.topView addSubview:tagLabel];
    tagLabel.text = @"标签";
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(18 * scale);
    }];
    
    UIButton * editTagButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(14 * scale) backgroundColor:[UIColor clearColor] title:@"编辑" cornerRadius:3.f];
    editTagButton.layer.borderColor = kAPPMainColor.CGColor;
    editTagButton.layer.borderWidth = .5f;
    [self.topView addSubview:editTagButton];
    [editTagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(40 * scale);
    }];
    
    self.tagView = [[CustomerTagView alloc] initWithFrame:CGRectMake(0, 190 * scale, kMainBoundsWidth, 40 * scale)];
    [self.tagView reloadTagSource:self.tagSource];
    CGRect rect = self.topView.frame;
    rect.size.height = rect.size.height + self.tagView.frame.size.height + 10 * scale;
    self.topView.frame = rect;
    [self.topView addSubview:self.tagView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 40 * scale)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    UILabel * historyLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    [self.bottomView addSubview:historyLabel];
    historyLabel.text = @"消费记录";
    [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(18 * scale);
    }];
    
    UIButton * historyButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(14 * scale) backgroundColor:[UIColor clearColor] title:@"添加" cornerRadius:3.f];
    historyButton.layer.borderColor = kAPPMainColor.CGColor;
    historyButton.layer.borderWidth = .5f;
    [self.bottomView addSubview:historyButton];
    [historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(40 * scale);
    }];
    
    self.historyView = [[CustomerPayHistory alloc] initWithFrame:CGRectMake(0, 40 * scale, kMainBoundsWidth, 40 * scale)];
    [self.historyView addImageWithImage:[UIImage new]];
    [self.historyView addImageWithImage:[UIImage new]];
    [self.historyView addImageWithImage:[UIImage new]];
    [self.historyView addImageWithImage:[UIImage new]];
    [self.historyView addImageWithImage:[UIImage new]];
    rect = self.bottomView.frame;
    rect.size.height = rect.size.height + self.historyView.frame.size.height + 10 * scale;
    self.bottomView.frame = rect;
    [self.bottomView addSubview:self.historyView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.bottomView;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)telNumberValueDidChange
{
    NSString * regex = @"^1[34578]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *str = self.firstTelField.text;
    if ([predicate evaluateWithObject:str]) {
        
    }
}

- (void)customerListDidSelect:(RDAddressModel *)model
{
    self.model = model;
    self.nameField.text = model.name;
    if (model.mobileArray && model.mobileArray.count > 0) {
        self.firstTelField.text = [model.mobileArray firstObject];
    }
}

- (void)logoButtonDidClicked
{
    CustomerListViewController * list = [[CustomerListViewController alloc] init];
    list.delegate = self;
    [self.navigationController pushViewController:list animated:YES];
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder leftImageNamed:(NSString *)imageName
{
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    textField.font = kPingFangRegular(15.f * scale);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = UIColorFromRGB(0x333333);
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32 * scale, 18 * scale)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18 * scale, 18 * scale)];
    [leftImageView setImage:[UIImage imageNamed:imageName]];
    [leftView addSubview:leftImageView];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                      @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),
                                        NSFontAttributeName:kHiraginoSansW3(15.f * scale)
                                        }];
    textField.attributedPlaceholder = attrString;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor grayColor];
    [textField addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25 * scale);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    return textField;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = UIColorFromRGB(0xece6de);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 5.f * scale;
}

- (NSMutableArray *)tagSource
{
    if (!_tagSource) {
        _tagSource = [[NSMutableArray alloc] init];
        NSArray * nameArray = @[@"偏辣", @"爱吃海鲜", @"不喜欢香菜", @"好面子", @"喜欢推荐菜", @"投屏", @"喜欢漂亮的妹子", @"喜欢漂亮的妹子喜欢漂亮的妹子喜欢漂亮的妹子喜欢漂亮的妹子喜欢漂亮的妹子"];
        for (NSInteger i = 0; i < nameArray.count; i++) {
            NSDictionary * dict = @{@"id" : [NSString stringWithFormat:@"%ld", i+1],
                                     @"name" :[nameArray objectAtIndex:i]
                                     };
            [_tagSource addObject:dict];
        }
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
