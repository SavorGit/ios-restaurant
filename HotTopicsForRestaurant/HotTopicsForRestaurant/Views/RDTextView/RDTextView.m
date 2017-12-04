//
//  RDTextView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDTextView.h"

@interface RDTextView ()

@end

@implementation RDTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)clearInputText
{
    self.text = @"";
    self.placeholderLabel.hidden = NO;
}

- (void)textDidChange
{
    if (self.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.numberOfLines = 0;
        [self addSubview:_placeholderLabel];
    }
    
    return _placeholderLabel;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.placeholderLabel.frame = CGRectMake(5, 10, frame.size.width - 10, 0);
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

@end
