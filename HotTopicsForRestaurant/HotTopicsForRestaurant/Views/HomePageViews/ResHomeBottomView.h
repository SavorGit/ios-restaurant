//
//  ResHomeBottomView.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

typedef enum : NSUInteger {
    ResHomeStatus_NoWiFi,
    ResHomeStatus_WiFiNoSence,
    ResHomeStatus_WiFiHaveSence,
    ResHomeStatus_Connect,
} ResHomeStatus;

@protocol ResHomeBottomViewDelegate <NSObject>

- (void)ResHomeBottomViewDidClickedWithStatus:(ResHomeStatus)status;
- (void)ResHomeBottomViewStopScreenWithTap;

@end

#import <UIKit/UIKit.h>

@interface ResHomeBottomView : UIView

@property (nonatomic, assign) ResHomeStatus status;
@property (nonatomic, assign) id<ResHomeBottomViewDelegate> delegate;

@end
