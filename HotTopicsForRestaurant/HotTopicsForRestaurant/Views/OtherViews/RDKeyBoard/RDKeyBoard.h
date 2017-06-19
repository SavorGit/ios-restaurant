//
//  RDKeyBoard.h
//  GCCAVplayer
//
//  Created by 郭春城 on 17/3/24.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RDKeyBoradDelegate <NSObject>

- (void)RDKeyBoradViewDidClickedWith:(NSString *)str isDelete:(BOOL)isDelete;

@end

@interface RDKeyBoard : UIView

@property (nonatomic, assign) id<RDKeyBoradDelegate> delegate;

- (instancetype)initWithHeight:(CGFloat)height inView:(UIView *)view;

@end
