//
//  RDTextAlertView.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDAlertAction.h"

@interface RDTextAlertView : UIView

@property (nonatomic, strong) UITextView * textView;

- (instancetype)initWithMaxNumber:(NSInteger)maxNumber message:(NSString *)message;

- (void)show;

- (void)addActions:(NSArray<RDAlertAction *> *)actions;

@end
