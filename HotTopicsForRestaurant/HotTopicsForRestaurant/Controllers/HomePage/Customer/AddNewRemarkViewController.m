//
//  AddNewRemarkViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "AddNewRemarkViewController.h"
#import "ModifyCuRemarkRequest.h"

@interface AddNewRemarkViewController ()<UITextViewDelegate>

@property(nonatomic, strong) NSString *customerId;
@property(nonatomic, strong) UITextView *remarkTextView;
@property(nonatomic, strong) NSString *remarkContentStr;

@end

@implementation AddNewRemarkViewController

- (instancetype)initWithCustomerId:(NSString *)customerId{
    if (self = [super init]) {
        self.customerId = customerId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"备注";
    self.view.backgroundColor = UIColorFromRGB(0xece6de);
    self.remarkContentStr = [[NSString alloc] init];
    [self creatSubViews];
    // Do any additional setup after loading the view.
}

- (void)creatSubViews{
    
    self.remarkTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.remarkTextView.text = @"请记录客户其他信息";
    self.remarkTextView.textColor = UIColorFromRGB(0x999999);
    self.remarkTextView.font = kPingFangRegular(15);
    self.remarkTextView.backgroundColor = UIColorFromRGB(0xe4e0dc);
    self.remarkTextView.textAlignment = NSTextAlignmentLeft;
    self.remarkTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.remarkTextView.layer.borderColor = UIColorFromRGB(0xb4b1ad).CGColor;
    self.remarkTextView.layer.borderWidth = .5f;
    self.remarkTextView.keyboardType = UIKeyboardTypeDefault;
    self.remarkTextView.returnKeyType = UIReturnKeyDone;
    self.remarkTextView.scrollEnabled = YES;
    self.remarkTextView.delegate = self;
    self.remarkTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.remarkTextView];
    [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(kMainBoundsWidth - 60);
        make.height.mas_equalTo(150);
    }];
    
    UIButton * saveButton = [Helper buttonWithTitleColor:[UIColor whiteColor] font:kPingFangRegular(18) backgroundColor:UIColorFromRGB(0x922c3e) title:@"保存"];
    saveButton.layer.borderColor = [UIColor clearColor].CGColor;
    saveButton.layer.borderWidth = 1;
    saveButton.layer.cornerRadius = 20;
    [self.view addSubview:saveButton];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkTextView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(kMainBoundsWidth - 100);
        make.height.mas_equalTo(40);
    }];
    
}

#pragma mark - 维修弹窗提交数据
-(void)saveClick{
    if (!isEmptyString(self.remarkContentStr)) {
        [self addNewRemarkDataRequest];
    }else{
        [MBProgressHUD showTextHUDwithTitle:@"请输入备注信息"];
    }
    
}

#pragma mark - textView代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请记录客户其他信息"]) {
        self.remarkTextView.textColor = UIColorFromRGB(0x999999);
        textView.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else if (range.location < 100){
        return  YES;
    } else if (textView.text.length == 100) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
    self.remarkContentStr = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    self.remarkContentStr = textView.text;
    [textView resignFirstResponder];
    
}

- (void)addNewRemarkDataRequest{
    
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"customer_id":self.customerId == nil ? @"":self.customerId,
                              @"remark":self.remarkContentStr,
                              };
    ModifyCuRemarkRequest * request = [[ModifyCuRemarkRequest alloc] initWithParamData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSDictionary *resultDic = [response objectForKey:@"result"];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"请连接网络"];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
