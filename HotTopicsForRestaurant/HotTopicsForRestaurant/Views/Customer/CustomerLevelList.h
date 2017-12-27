//
//  CustomerLevelList.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/26.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerLevelListDelegate<NSObject>

- (void)customerLevelDidSelect:(NSDictionary *)level;

@end

@interface CustomerLevelList : UIView

@property (nonatomic, assign) id<CustomerLevelListDelegate> delegate;

@end
