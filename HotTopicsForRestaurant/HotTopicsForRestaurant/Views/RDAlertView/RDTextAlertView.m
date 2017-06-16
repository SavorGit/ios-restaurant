//
//  RDTextAlertView.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDTextAlertView.h"

@interface RDTextAlertView ()

@property (nonatomic, strong) UIView * showView;
@property (nonatomic, assign) NSInteger maxNumber;
@property (nonatomic, strong) UILabel * numLabel;
@property (nonatomic, strong) UILabel * pLable;

@end

@implementation RDTextAlertView

- (instancetype)initWithMaxNumber:(NSInteger)maxNumber message:(NSString *)message
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.maxNumber = maxNumber;
        [self createAlertWithMessage:message];
        self.tag = 333;
    }
    return self;
}

- (void)createAlertWithMessage:(NSString *)message
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 60, 182)];
    self.showView.backgroundColor = [UIColor whiteColor];
    self.showView.center = CGPointMake(kMainBoundsWidth / 2, kMainBoundsHeight / 2);
    [self addSubview:self.showView];
    self.showView.layer.cornerRadius = 8.f;
    self.showView.layer.masksToBounds = YES;
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, self.showView.frame.size.width - 20, 110)];
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.showView addSubview:self.textView];
    
    self.pLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 21, self.showView.frame.size.width - 20, 30)];
    self.pLable.numberOfLines = 0;
    self.pLable.textColor = [UIColor grayColor];
    self.pLable.text = message;
    self.pLable.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    [self.showView addSubview:self.pLable];
    
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.showView.frame.size.width - 60, 110, 40, 20)];
    self.numLabel.textColor = [UIColor grayColor];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.text = [NSString stringWithFormat:@"0/%ld", self.maxNumber];
    self.numLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    [self.showView addSubview:self.numLabel];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 132, self.showView.frame.size.width, .5f)];
    lineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [self.showView addSubview:lineView];
}

- (void)show
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidBeChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter
      defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter
      defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];//在这里注册通知
    
    UIView * view = [[UIApplication sharedApplication].keyWindow viewWithTag:333];
    if (view) {
        [view removeFromSuperview];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 60, 182));
        make.center.mas_equalTo(0);
    }];
}

- (void)textViewValueDidBeChange:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    
    NSString *toBeString = textView.text;
    if (toBeString.length == 0) {
        self.pLable.hidden = NO;
        self.numLabel.text = [NSString stringWithFormat:@"0/%ld", self.maxNumber];
        return;
    }else{
        self.pLable.hidden = YES;
    }
    
    NSString *lang = [textView.textInputMode primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > self.maxNumber) {
                textView.text = [toBeString substringToIndex:self.maxNumber];
                [Helper showTextHUDwithTitle:[NSString stringWithFormat:@"最多输入%ld个字符", self.maxNumber] delay:1.5f];
            }
            self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.textView.text.length ,self.maxNumber];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > self.maxNumber) {
            textView.text = [toBeString substringToIndex:self.maxNumber];
            [Helper showTextHUDwithTitle:[NSString stringWithFormat:@"最多输入%ld个字符", self.maxNumber] delay:1.5f];
        }
        self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.textView.text.length ,self.maxNumber];
    }
}

/**
 * 键盘出现时调用
 */
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGPoint center = self.showView.center;
    center.y = self.bounds.size.height - keyboardF.size.height - self.showView.frame.size.height / 2 - 10;
    
    if (self.showView.center.y > center.y) {
        [UIView animateWithDuration:duration animations:^{
            self.showView.center = center;
        }];
    }
}

/**
 * 键盘消失时调用
 */
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect toolViewFrame = self.showView.frame;
    toolViewFrame.origin.y = toolViewFrame.origin.y + keyboardF.size.height;
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        self.showView.center = CGPointMake(kMainBoundsWidth / 2, kMainBoundsHeight / 2);
    }];
}

- (void)addActions:(NSArray<RDAlertAction *> *)actions
{
    CGFloat width = self.showView.frame.size.width;
    if (actions.count == 1) {
        RDAlertAction * action = [actions firstObject];
        [action setFrame:CGRectMake(0, 132, width, 50)];
        [action addTarget:self action:@selector(actionDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:action];
    }else if (actions.count == 2) {
        RDAlertAction * leftAction = [actions firstObject];
        [leftAction setFrame:CGRectMake(0, 132, width / 2, 50)];
        [leftAction addTarget:self action:@selector(actionDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:leftAction];
        
        RDAlertAction * rightAction = [actions lastObject];
        [rightAction setFrame:CGRectMake(width / 2, 132, width / 2, 50)];
        [rightAction addTarget:self action:@selector(actionDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:rightAction];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(width / 2, 137, .5f, 40)];
        lineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [self.showView addSubview:lineView];
    }
}

- (void)actionDidBeClicked:(RDAlertAction *)action
{
    if (self.textView.text.length == 0) {
        [Helper showTextHUDwithTitle:@"幻灯片名称不能为空" delay:1.f];
    }else{
        if (action.block) {
            action.block();
        }
        [self removeFromSuperview];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
