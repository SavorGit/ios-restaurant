//
//  RDAddressModel.h
//  通讯录
//
//  Created by 郭春城 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDAddressModel : NSObject

/** 所有号码拼接*/
@property (nonatomic, copy) NSString * searchKey;

/** 联系人姓名*/
@property (nonatomic, copy) NSString *name;
/** 联系人姓名拼音*/
@property (nonatomic, copy) NSString *pinYin;
/** 联系人电话数组,因为一个联系人可能存储多个号码*/
@property (nonatomic, strong) NSMutableArray *mobileArray;
/** 联系人生日*/
@property (nonatomic, copy) NSString *birthday;
/** 联系人头像地址*/
@property (nonatomic, copy) NSString * logoImageURL;

@property (nonatomic, copy) NSString * birthplace; //籍贯
@property (nonatomic, copy) NSString * consumptionLevel; //消费能力
@property (nonatomic, copy) NSString * invoiceTitle; //发票信息

- (instancetype)initWithNetDict:(NSDictionary *)dict;

@end
