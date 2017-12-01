//
//  ResUserModel.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResUserModel : NSObject

@property (nonatomic, copy) NSString * hotelID;
@property (nonatomic, copy) NSString * hotelName;

- (instancetype)initWithHotelID:(NSString *)hotelID hotelName:(NSString *)hotelName;

@end
