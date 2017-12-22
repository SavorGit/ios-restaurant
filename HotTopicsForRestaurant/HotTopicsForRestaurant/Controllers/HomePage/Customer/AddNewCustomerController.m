//
//  AddNewCustomerController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddNewCustomerController.h"

@interface AddNewCustomerController ()

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) UITextField * firstTelField;
@property (nonatomic, strong) UITextField * secondTelField;
@property (nonatomic, strong) UITextField * nameField;

//性别
@property (nonatomic, strong) UIButton * maleButton;
@property (nonatomic, strong) UIButton * femaleButton;
@property (nonatomic, assign) NSInteger gender;

@end

@implementation AddNewCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xece6de);
    self.navigationItem.title = @"新增客户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"导入通讯录" style:UIBarButtonItemStyleDone target:self action:@selector(addCustomerFromSystemAddress)];
    [self createAddNewCustomerUI];
}

- (void)createAddNewCustomerUI
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120 * scale);
    }];
    
    self.nameField = [self textFieldWithPlaceholder:@"请输入姓名" leftImageNamed:@""];
    [self.topView addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(60 * scale);
        make.right.mas_equalTo(-100 * scale);
    }];
    [self addLineTo:self.nameField];
    
    self.firstTelField = [self textFieldWithPlaceholder:@"请输入手机号" leftImageNamed:@""];
    [self.topView addSubview:self.firstTelField];
    [self.firstTelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameField.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(60 * scale);
        make.right.mas_equalTo(-100 * scale);
    }];
    
    self.secondTelField = [self textFieldWithPlaceholder:@"请输入手机号" leftImageNamed:@""];
    
    UIButton * addTelButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addTelButton.frame = CGRectMake(0, 0, 20 * scale, 20 * scale);
    [addTelButton addTarget:self action:@selector(addTelButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.firstTelField.rightView = addTelButton;
    self.firstTelField.rightViewMode = UITextFieldViewModeAlways;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(10 * scale);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    UILabel * optionalTopicLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    optionalTopicLabel.text = @"以下为选填内容（可不填）";
    [self.bottomView addSubview:optionalTopicLabel];
    [optionalTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(18 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    UIView * gender = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32 * scale, 18 * scale)];
    [self.bottomView addSubview:gender];
    [gender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(optionalTopicLabel.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(60 * scale);
        make.right.mas_equalTo(0);
    }];
    [self addLineTo:gender];
    
    UIImageView * genderImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [genderImageView setImage:[UIImage imageNamed:@""]];
    [gender addSubview:genderImageView];
    [genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(18 * scale);
    }];
    
    self.maleButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(15 * scale) backgroundColor:[UIColor clearColor] title:@"男" cornerRadius:3.f];
    self.femaleButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(15 * scale) backgroundColor:[UIColor clearColor] title:@"女" cornerRadius:3.f];
    
    self.maleButton.layer.borderColor = kAPPMainColor.CGColor;
    self.maleButton.layer.borderWidth = .5f;
    [gender addSubview:self.maleButton];
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(genderImageView.mas_right).offset(25.f);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(50 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
    [self.maleButton addTarget:self action:@selector(genderButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.femaleButton.layer.borderColor = kAPPMainColor.CGColor;
    self.femaleButton.layer.borderWidth = .5f;
    [gender addSubview:self.femaleButton];
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.maleButton.mas_right).offset(30 * scale);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(50 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
    [self.femaleButton addTarget:self action:@selector(genderButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)genderButtonDidClicked:(UIButton *)button
{
    if (button == self.maleButton) {
        
        [self.femaleButton setBackgroundColor:[UIColor clearColor]];
        [self.femaleButton setTitleColor:kAPPMainColor forState:UIControlStateNormal];
        
        [self.maleButton setBackgroundColor:kAPPMainColor];
        [self.maleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        self.gender = 0;
        
    }else if (button == self.femaleButton) {
        
        [self.maleButton setBackgroundColor:[UIColor clearColor]];
        [self.maleButton setTitleColor:kAPPMainColor forState:UIControlStateNormal];
        
        [self.femaleButton setBackgroundColor:kAPPMainColor];
        [self.femaleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        self.gender = 1;
    }
}

- (void)addCustomerFromSystemAddress
{
    
}

- (void)addTelButtonDidClicked:(UIButton *)button
{
    self.firstTelField.rightView = nil;
    
    [button removeFromSuperview];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    [self.view addSubview:self.secondTelField];
    [self addLineTo:self.firstTelField];
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(180 * scale);
    }];
    
    [self.secondTelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTelField.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(60 * scale);
        make.right.mas_equalTo(-100 * scale);
    }];
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
    
    return textField;
}

- (void)addLineTo:(UIView *)view
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor grayColor];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
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
