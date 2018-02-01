//
//  ResKeyWordViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResKeyWordViewController.h"
#import "RDTextView.h"
#import "ResKeyWordBGViewController.h"

@interface ResKeyWordViewController ()

@property (nonatomic, strong) RDTextView * keyWordTextView;
@property (nonatomic, strong) NSArray * keyWordSource;

@end

@implementation ResKeyWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欢迎词";
    [self createDataSource];
    [self createSubViews];
}

- (void)createDataSource
{
    self.keyWordSource = [[NSArray alloc] initWithObjects:
                          @"欢迎李总莅临本店，祝您用餐愉快！",
                          @"祝彤彤小宝贝百天快乐！",
                          @"祝韩梅梅女士生日快乐！",
                          @"祝李雷先生与韩梅梅女生新婚快乐！",
                          @"中秋阳澄湖大闸蟹特惠礼包，限时优惠！",
                          nil];
}

- (void)createSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.keyWordTextView = [[RDTextView alloc] initWithFrame:CGRectMake(15 * scale, 10 * scale, (kMainBoundsWidth - 15- 16.5) * scale, 80 * scale)];
    self.keyWordTextView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    self.keyWordTextView.layer.borderWidth = .5f;
    self.keyWordTextView.placeholder = @"请输入欢迎词（1-18个字）";
    self.keyWordTextView.placeholderLabel.font = kPingFangRegular(15 * scale);
    self.keyWordTextView.placeholderLabel.textColor = UIColorFromRGB(0x999999);    self.keyWordTextView.backgroundColor = UIColorFromRGB(0xffffff);
    self.keyWordTextView.textColor = UIColorFromRGB(0x333333);
    self.keyWordTextView.font = kPingFangRegular(15 * scale);
    [self.view addSubview:self.keyWordTextView];
    [self.keyWordTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.top.mas_equalTo(10 * scale);
        make.right.mas_equalTo(-16.5 * scale);
        make.height.mas_equalTo(80 * scale);
    }];
    
    if ([self.keyWordTextView canBecomeFirstResponder]) {
        [self.keyWordTextView becomeFirstResponder];
    }
    
    UILabel * alertLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentCenter];
    alertLabel.text = @"快捷输入";
    [self.view addSubview:alertLabel];
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.keyWordTextView.mas_bottom).offset(15 * scale);
        make.height.mas_equalTo(14 * scale + 1.f);
    }];
    
    UIView * leftLine = [[UIView alloc] initWithFrame:CGRectZero];
    leftLine.backgroundColor = UIColorFromRGB(0x999999);
    [self.view addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(alertLabel.mas_centerY);
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(alertLabel.mas_left).mas_equalTo(-10 * scale);
        make.height.mas_equalTo(1.f);
    }];
    
    UIView * rightLine = [[UIView alloc] initWithFrame:CGRectZero];
    rightLine.backgroundColor = UIColorFromRGB(0x999999);
    [self.view addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(alertLabel.mas_centerY);
        make.right.mas_equalTo(-15 * scale);
        make.left.mas_equalTo(alertLabel.mas_right).mas_equalTo(10 * scale);
        make.height.mas_equalTo(1.f);
    }];
    
    UIView * tempView;
    for (NSInteger i = 0; i < self.keyWordSource.count; i++) {
        UIButton * view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = UIColorFromRGB(0xffffff);
        view.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
        view.layer.borderWidth = .5f;
        view.tag = 100 + i;
        [self.view addSubview:view];
        if (i == 0) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(alertLabel.mas_bottom).offset(15 * scale);
                make.left.mas_equalTo(15 * scale);
                make.right.mas_equalTo(-15 * scale);
                make.height.mas_equalTo(32 * scale);
            }];
        }else{
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(tempView.mas_bottom).offset(6 * scale);
                make.left.mas_equalTo(15 * scale);
                make.right.mas_equalTo(-15 * scale);
                make.height.mas_equalTo(32 * scale);
            }];
        }
        tempView = view;
        
        NSString * title = [self.keyWordSource objectAtIndex:i];
        UILabel * label = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
        label.text = title;
        label.backgroundColor = UIColorFromRGB(0xffffff);
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.left.mas_equalTo(15 * scale);
        }];
        
        [view addTarget:self action:@selector(keyWordDidTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton * rightButton = [Helper buttonWithTitleColor:[UIColor whiteColor] font:kPingFangRegular(16) backgroundColor:[UIColor clearColor] title:@"下一步"];
    [rightButton addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 57, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)rightItemDidClicked
{
    if (isEmptyString(self.keyWordTextView.text)) {
        [MBProgressHUD showTextHUDwithTitle:@"请输入关键词"];
    }else{
        if ([self.keyWordTextView isFirstResponder]) {
            [self.keyWordTextView resignFirstResponder];
        }
        NSString * keyWord = self.keyWordTextView.text;
        ResKeyWordBGViewController * bgVC = [[ResKeyWordBGViewController alloc] initWithkeyWord:keyWord];
        [self.navigationController pushViewController:bgVC animated:YES];
    }
}

- (void)keyWordDidTap:(UIButton *)button
{
    NSInteger index = button.tag - 100;
    self.keyWordTextView.text = [self.keyWordSource objectAtIndex:index];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.keyWordTextView isFirstResponder]) {
        [self.keyWordTextView resignFirstResponder];
    }
}

- (void)navBackButtonClicked:(UIButton *)sender
{
    [super navBackButtonClicked:sender];
    if ([self.keyWordTextView isFirstResponder]) {
        [self.keyWordTextView resignFirstResponder];
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
