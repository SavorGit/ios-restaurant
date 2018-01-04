//
//  ResUserModel.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResUserModel : NSObject

@property (nonatomic, assign) NSInteger hotelID;
@property (nonatomic, copy) NSString * invite_id;
@property (nonatomic, copy) NSString * hotelName;
@property (nonatomic, copy) NSString * telNumber;
@property (nonatomic, copy) NSString * inviCode;
@property (nonatomic, copy) NSString * is_import_customer;
@property (nonatomic, copy) NSString * is_open_customer;

- (instancetype)initWithHotelID:(NSString *)hotelID hotelName:(NSString *)hotelName telNumber:(NSString *)telNumber inviCode:(NSString *)inviCode inviteId:(NSString *)invite_id isImport:(NSString *)isImport isOpen:(NSString *)isOpen;

@end
