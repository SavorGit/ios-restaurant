//
//  ResSearchAddressController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDAddressModel.h"

@protocol MultiSelectAddressDelegate<NSObject>

@optional

- (void)multiAddressDidSelect:(RDAddressModel *)model;
- (void)multiAddressDidUpdate;

@end

@interface ResSearchAddressController : UIViewController

@property (nonatomic, assign) id<MultiSelectAddressDelegate> delegate;

- (instancetype)initWithDataSoucre:(NSDictionary *)dataDict keys:(NSArray *)keys customList:(NSMutableArray *)customerList isNeedAddButton:(BOOL)isNeedAddButton;

@end
