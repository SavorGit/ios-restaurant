//
//  RDTextView.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDTextView : UITextView

@property (nonatomic, strong) UILabel * placeholderLabel;
@property (nonatomic, copy) NSString * placeholder;

- (void)clearInputText;

@end
