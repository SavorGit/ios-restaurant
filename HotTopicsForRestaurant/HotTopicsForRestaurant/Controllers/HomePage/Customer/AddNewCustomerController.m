//
//  AddNewCustomerController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddNewCustomerController.h"

@interface AddNewCustomerController ()

@property (nonatomic, strong) UITextField * firstTelField;
@property (nonatomic, strong) UITextField * secondTelField;
@property (nonatomic, strong) UITextField * nameField;

@end

@implementation AddNewCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增客户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"导入通讯录" style:UIBarButtonItemStyleDone target:self action:@selector(addCustomerFromSystemAddress)];
    [self createAddNewCustomerUI];
}

- (void)createAddNewCustomerUI
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.firstTelField = [self textFieldWithPlaceholder:@"请输入手机号" leftImageNamed:@""];
    [self.view addSubview:self.firstTelField];
    [self.firstTelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * scale);
        make.left.mas_equalTo(20 * scale);
        make.height.mas_equalTo(30 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    self.secondTelField = [self textFieldWithPlaceholder:@"请输入手机号" leftImageNamed:@""];
    
    self.nameField = [self textFieldWithPlaceholder:@"请输入姓名" leftImageNamed:@""];
    [self.view addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTelField.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(20 * scale);
        make.height.mas_equalTo(30 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    UIButton * addTelButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:addTelButton];
    [addTelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTelField.mas_top).offset(5 * scale);
        make.width.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(self.firstTelField.mas_right).offset(10 * scale);
    }];
    [addTelButton addTarget:self action:@selector(addTelButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addCustomerFromSystemAddress
{
    
}

- (void)addTelButtonDidClicked:(UIButton *)button
{
    [button removeFromSuperview];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    [self.view addSubview:self.secondTelField];
    [self.secondTelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTelField.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(20 * scale);
        make.height.mas_equalTo(30 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    [self.nameField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.secondTelField.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(20 * scale);
        make.height.mas_equalTo(30 * scale);
        make.right.mas_equalTo(-50 * scale);
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
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    [textField addSubview:lineView];
    lineView.backgroundColor =UIColorFromRGB(0xd7d7d7);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftView.frame.size.width);
        make.right.mas_equalTo(0.f);
        make.height.mas_equalTo(.5f);
        make.bottom.mas_equalTo(0.f);
    }];
    
    return textField;
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
