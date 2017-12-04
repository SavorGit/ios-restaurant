//
//  ResLoginViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/30.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResLoginViewController.h"
#import "GetVerifyCodeRequest.h"
#import "LoginRequest.h"

@interface ResLoginViewController ()

@property (nonatomic, assign) BOOL autoLogin;

@property (nonatomic, strong) UITextField * telField; //电话号码
@property (nonatomic, strong) UITextField * veriField; //验证码
@property (nonatomic, strong) UIButton * veriButton;
@property (nonatomic, strong) UITextField * inviField; //邀请码

@property (nonatomic, strong) UIButton * loginButton; //登录按钮

@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, assign) BOOL isChangeTime;

@end

@implementation ResLoginViewController

- (instancetype)initWithAutoLogin:(BOOL)autoLogin
{
    if (self = [super init]) {
        self.autoLogin = autoLogin;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLoginSubViews];
}

- (void)createLoginSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [logoImageView setImage:[UIImage imageNamed:@"ctdl_logo"]];
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(72.f * scale);
        make.top.mas_equalTo(87.f * scale);
    }];
    
    UILabel * logoLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentCenter];
    logoLabel.text = @"小热点餐厅端";
    [self.view addSubview:logoLabel];
    [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(logoImageView.mas_bottom).offset(14.f * scale);
        make.height.mas_equalTo(16.f * scale + 1);
    }];
    
    UILabel * infoLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentCenter];
    infoLabel.text = @"只为高端餐厅服务";
    [self.view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-25.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    self.telField = [self textFieldWithPlaceholder:@"请输入手机号码" leftImageNamed:@"sj"];
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32 * scale, 21 * scale)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18 * scale, 21 * scale)];
    [leftImageView setImage:[UIImage imageNamed:@"sj"]];
    [leftView addSubview:leftImageView];
    self.telField.leftView = leftView;
    self.telField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.telField];
    self.telField.keyboardType = UIKeyboardTypeNumberPad;
    [self.telField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoLabel.mas_bottom).offset(75.f * scale);
        make.left.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-25 * scale);
        make.height.mas_equalTo(45 * scale);
    }];
    
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:lineView1];
    lineView1.backgroundColor =UIColorFromRGB(0xd7d7d7);
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.telField.mas_bottom).offset(3.f);
        make.left.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-25 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    if (self.autoLogin) {
        self.inviField = [self textFieldWithPlaceholder:@"请输入邀请码" leftImageNamed:@"yqm"];
        self.inviField.keyboardType = UIKeyboardTypeASCIICapable;
        [self.view addSubview:self.inviField];
        [self.inviField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView1.mas_bottom);
            make.left.mas_equalTo(25 * scale);
            make.right.mas_equalTo(-25 * scale);
            make.height.mas_equalTo(45 * scale);
        }];
        
        UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:lineView2];
        lineView2.backgroundColor =UIColorFromRGB(0xd7d7d7);
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.inviField.mas_bottom).offset(3.f);
            make.left.mas_equalTo(25 * scale);
            make.right.mas_equalTo(-25 * scale);
            make.height.mas_equalTo(.5f);
        }];
    }else{
        self.veriField = [self textFieldWithPlaceholder:@"请输入验证码" leftImageNamed:@"yzm"];
        [self.view addSubview:self.veriField];
        self.veriField.keyboardType = UIKeyboardTypeNumberPad;
        [self.veriField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView1.mas_bottom);
            make.left.mas_equalTo(25 * scale);
            make.right.mas_equalTo(-25 * scale);
            make.height.mas_equalTo(45 * scale);
        }];
        
        self.veriButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xfecab3) font:kHiraginoSansW3(15.f * scale) backgroundColor:[UIColor clearColor] title:@"获取验证码" cornerRadius:3.f];
        self.veriButton.frame = CGRectMake(0, 0, 98.f * scale, 34.f * scale);
        self.veriButton.layer.borderColor = UIColorFromRGB(0xfecab3).CGColor;
        self.veriButton.layer.borderWidth = .5f;
        self.veriField.rightView = self.veriButton;
        self.veriField.rightViewMode = UITextFieldViewModeAlways;
        [self.veriButton addTarget:self action:@selector(sendButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.veriField addTarget:self action:@selector(veriTextFiledDidChangeValue) forControlEvents:UIControlEventEditingChanged];
        
        UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:lineView2];
        lineView2.backgroundColor =UIColorFromRGB(0xd7d7d7);
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.veriField.mas_bottom).offset(3.f);
            make.left.mas_equalTo(25 * scale);
            make.right.mas_equalTo(-25 * scale);
            make.height.mas_equalTo(.5f);
        }];
        
        self.inviField = [self textFieldWithPlaceholder:@"请输入邀请码" leftImageNamed:@"yqm"];
        [self.view addSubview:self.inviField];
        self.inviField.keyboardType = UIKeyboardTypeASCIICapable;
        [self.inviField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView2.mas_bottom);
            make.left.mas_equalTo(25 * scale);
            make.right.mas_equalTo(-25 * scale);
            make.height.mas_equalTo(45 * scale);
        }];
        
        UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:lineView3];
        lineView3.backgroundColor =UIColorFromRGB(0xd7d7d7);
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.inviField.mas_bottom).offset(3.f);
            make.left.mas_equalTo(25 * scale);
            make.right.mas_equalTo(-25 * scale);
            make.height.mas_equalTo(.5f);
        }];
    }
    
    self.loginButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(17 * scale) backgroundColor:UIColorFromRGB(0xfecab3) title:@"登录" cornerRadius:5];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inviField.mas_bottom).offset(70 * scale);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(325 * scale);
        make.height.mas_equalTo(40 * scale);
    }];
    [self loginButtonDisable];
    [self sendButtonDisable];
    
    [self.telField addTarget:self action:@selector(telTextFiledDidChangeValue) forControlEvents:UIControlEventEditingChanged];
    [self.loginButton addTarget:self action:@selector(loginButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.inviField addTarget:self action:@selector(inviTextFiledDidChangeValue) forControlEvents:UIControlEventEditingChanged];
    
    if (self.autoLogin) {
        NSDictionary * userInfo = [[NSDictionary alloc] initWithContentsOfFile:UserAccountPath];
        self.telField.text = [userInfo objectForKey:@"name"];
        self.inviField.text = [userInfo objectForKey:@"password"];
        [self loginButtonDidClicked];
    }else{
        if ([self.telField canBecomeFirstResponder]) {
            [self.telField becomeFirstResponder];
        }
    }
}

- (void)sendButtonDidClicked
{
    NSString * telNumber = self.telField.text;
    if (isEmptyString(telNumber)) {
        [MBProgressHUD showTextHUDwithTitle:@"手机号码不能为空"];
        return;
    }
    
    [GetVerifyCodeRequest cancelRequest];
    GetVerifyCodeRequest * request = [[GetVerifyCodeRequest alloc] initWithMobile:telNumber];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (![self.veriField isFirstResponder]) {
            [self.veriField becomeFirstResponder];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
    
    [self createTimeCount];
}

- (void)loginButtonDidClicked
{
    NSString * telNumber = self.telField.text;
    if (isEmptyString(telNumber)) {
        [MBProgressHUD showTextHUDwithTitle:@"手机号码不能为空"];
        return;
    }
    
    if (!self.autoLogin) {
        NSString * veriCode = self.veriField.text;
        if (isEmptyString(veriCode)) {
            [MBProgressHUD showTextHUDwithTitle:@"验证码不能为空"];
            return;
        }
    }
    
    NSString * inviCode = self.inviField.text;
    if (isEmptyString(inviCode)) {
        [MBProgressHUD showTextHUDwithTitle:@"邀请码不能为空"];
        return;
    }
    
    [self closeKeyBorad];
    
    LoginRequest * request;
    if (self.autoLogin) {
        request = [[LoginRequest alloc] initWithInviCode:inviCode mobile:telNumber veriCode:@""];
    }else{
        request = [[LoginRequest alloc] initWithInviCode:inviCode mobile:telNumber veriCode:self.veriField.text];
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingWithText:@"正在登录" inView:self.view];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        
        [MBProgressHUD showTextHUDwithTitle:@"登录成功"];
        [Helper saveFileOnPath:UserAccountPath withDictionary:@{@"name":telNumber,@"password":inviCode}];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        NSDictionary * userInfo = [response objectForKey:@"result"];
        if ([userInfo isKindOfClass:userInfo]) {
//            [GlobalData shared]
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"登录失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"登录失败"];
        
    }];
    
//    [MBProgressHUD showTextHUDWithText:@"登录成功" inView:self.navigationController.view];
    
}

- (void)telTextFiledDidChangeValue
{
    if (self.isChangeTime) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeTime) object:nil];
        self.isChangeTime = NO;
        [self.veriButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
    if (self.telField.text.length == 0) {
        [self loginButtonDisable];
        [self sendButtonDisable];
    }else{
        
        [self sendButtonEnable];
        if (self.veriField.text.length != 0 && self.inviField.text.length != 0) {
            [self loginButtonEnable];
        }
        
        if (self.telField.text.length > 20) {
            self.telField.text = [self.telField.text substringToIndex:20];
        }
    }
}

- (void)veriTextFiledDidChangeValue
{
    if (self.veriField.text.length == 0) {
        [self loginButtonDisable];
    }else{
        if (self.telField.text.length != 0 && self.inviField.text.length != 0) {
            [self loginButtonEnable];
        }
        
        if (self.veriField.text.length > 6) {
            self.veriField.text = [self.veriField.text substringToIndex:6];
        }
    }
}

- (void)inviTextFiledDidChangeValue
{
    if (self.inviField.text.length == 0) {
        [self loginButtonDisable];
    }else{
        if (self.telField.text.length != 0 && self.veriField.text.length != 0) {
            [self loginButtonEnable];
        }
    }
}

- (void)createTimeCount
{
    if (!self.isChangeTime) {
        self.timeCount = 60;
        [self sendButtonDisable];
        self.isChangeTime = YES;
        [self changeTime];
    }
}

- (void)changeTime
{
    if (self.timeCount == 0) {
        [self.veriButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        if (self.telField.text.length != 0) {
            [self sendButtonEnable];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeTime) object:nil];
        self.isChangeTime = NO;
        return;
    }
    
    NSString * str = [NSString stringWithFormat:@"%lds", self.timeCount];
    [self.veriButton setTitle:str forState:UIControlStateNormal];
    self.timeCount--;
    [self performSelector:@selector(changeTime) withObject:nil afterDelay:1.f];
}

- (void)sendButtonDisable
{
    if (self.veriButton.isEnabled) {
        self.veriButton.enabled = NO;
        self.veriButton.layer.borderColor = UIColorFromRGB(0xfecab3).CGColor;
        [self.veriButton setTitleColor:UIColorFromRGB(0xfecab3) forState:UIControlStateNormal];
    }
}

- (void)sendButtonEnable
{
    if (!self.veriButton.isEnabled) {
        self.veriButton.enabled = YES;
        self.veriButton.layer.borderColor = UIColorFromRGB(0xfd7a40).CGColor;
        [self.veriButton setTitleColor:UIColorFromRGB(0xfd7a40) forState:UIControlStateNormal];
    }
}

- (void)loginButtonDisable
{
    if (self.loginButton.isEnabled) {
        self.loginButton.enabled = NO;
        [self.loginButton setBackgroundColor:UIColorFromRGB(0xfecab3)];
    }
}

- (void)loginButtonEnable
{
    if (!self.loginButton.isEnabled) {
        self.loginButton.enabled = YES;
        [self.loginButton setBackgroundColor:UIColorFromRGB(0xfd7a40)];
    }
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self closeKeyBorad];
}

- (void)closeKeyBorad
{
    if ([self.telField isFirstResponder]) {
        [self.telField resignFirstResponder];
    }
    
    if (self.veriField && [self.veriField isFirstResponder]) {
        [self.veriField resignFirstResponder];
    }
    
    if ([self.inviField isFirstResponder]) {
        [self.inviField resignFirstResponder];
    }
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
