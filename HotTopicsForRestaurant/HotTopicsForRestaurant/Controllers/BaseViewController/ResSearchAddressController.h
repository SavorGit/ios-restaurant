//
//  ResSearchAddressController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDAddressModel.h"

typedef enum : NSUInteger {
    SearchAddressTypeSignle,
    SearchAddressTypeMulti
} SearchAddressType;

@protocol ResSearchAddressDelegate<NSObject>

@optional

- (void)multiAddressDidSelect:(RDAddressModel *)model;
- (void)multiAddressDidUpdate;

@end

@interface ResSearchAddressController : UIViewController

@property (nonatomic, assign) id<ResSearchAddressDelegate> delegate;

- (instancetype)initWithDataSoucre:(NSDictionary *)dataDict keys:(NSArray *)keys customList:(NSMutableArray *)customerList type:(SearchAddressType)type;

@end
