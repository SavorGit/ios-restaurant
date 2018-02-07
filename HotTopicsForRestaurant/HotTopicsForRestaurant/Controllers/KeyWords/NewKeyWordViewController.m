//
//  NewKeyWordViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "NewKeyWordViewController.h"
#import "RDTextView.h"
#import "NewKeyWordBGViewController.h"
#import "SAVORXAPI.h"

@interface NewKeyWordViewController ()

@property (nonatomic, strong) RestaurantServiceModel * model;

@property (nonatomic, strong) RDTextView * keyWordTextView;
@property (nonatomic, strong) UIButton * defaultButton;

@property (nonatomic, weak) UILabel * defaultWordLabel;
@property (nonatomic, strong) NSArray * keyWordSource;

@property (nonatomic, assign) BOOL isDefault;

@end

@implementation NewKeyWordViewController

- (instancetype)initWithModel:(RestaurantServiceModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欢迎词";
    [self createDataSource];
    [self createSubViews];
}

- (void)createDataSource
{
    self.keyWordSource = [[NSArray alloc] initWithObjects:
                          self.model.DefaultWord,
                          @"祝生日快乐，天天开心！",
                          @"祝阖家欢乐，幸福美满！",
                          @"祝一帆风顺，心想事成！",
                          @"现推出特色伴手礼，限时优惠！",
                          nil];
}

- (void)createSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.keyWordTextView = [[RDTextView alloc] initWithFrame:CGRectMake(15 * scale, 10 * scale, (kMainBoundsWidth - 15- 16.5) * scale, 80 * scale)];
    self.keyWordTextView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    self.keyWordTextView.layer.borderWidth = .5f;
    self.keyWordTextView.placeholder = @" 请输入欢迎词（1-18个字）";
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
    
    self.defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.defaultButton setImage:[UIImage imageNamed:@"dx_weix"] forState:UIControlStateNormal];
    [self.defaultButton setTitle:@" 设为默认欢迎词" forState:UIControlStateNormal];
    [self.defaultButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    self.defaultButton.titleLabel.font = kPingFangRegular(14 * scale);
    [self.view addSubview:self.defaultButton];
    [self.defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.keyWordTextView.mas_bottom).offset(5 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    [self.defaultButton addTarget:self action:@selector(defaultButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * alertLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentCenter];
    alertLabel.text = @"快捷输入";
    [self.view addSubview:alertLabel];
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.defaultButton.mas_bottom).offset(15 * scale);
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
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(15 * scale);
        }];
        if (i == 0) {
            self.defaultWordLabel = label;
            UILabel * defaultLabel = [Helper labelWithFrame:CGRectZero TextColor:kAPPMainColor font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
            defaultLabel.text = @"(默认)";
            [view addSubview:defaultLabel];
            [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label.mas_right).offset(5 * scale);
                make.top.bottom.mas_equalTo(0);
            }];
        }
        
        [view addTarget:self action:@selector(keyWordDidTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton * rightButton = [Helper buttonWithTitleColor:[UIColor whiteColor] font:kPingFangRegular(16) backgroundColor:[UIColor clearColor] title:@"下一步"];
    [rightButton addTarget:self action:@selector(rightItemDidClicked) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 57, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)defaultButtonDidClicked
{
    if ([self.keyWordTextView isFirstResponder]) {
        [self.keyWordTextView resignFirstResponder];
    }
    self.isDefault = !self.isDefault;
    if (self.isDefault) {
        [self.defaultButton setImage:[UIImage imageNamed:@"dx_xzh"] forState:UIControlStateNormal];
    }else{
        [self.defaultButton setImage:[UIImage imageNamed:@"dx_weix"] forState:UIControlStateNormal];
    }
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
        NewKeyWordBGViewController * bgVC = [[NewKeyWordBGViewController alloc] initWithkeyWord:keyWord model:self.model isDefault:self.isDefault];
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
