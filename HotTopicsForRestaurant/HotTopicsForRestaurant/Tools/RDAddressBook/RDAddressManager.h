//
//  RDAddressManager.h
//  通讯录
//
//  Created by 郭春城 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDAddressModel.h"

extern NSString * const CustomerBookDidUpdateNotification; //客户列表更新

/**
 *  获取按A~Z顺序排列的所有联系人的Block
 *
 *  @param addressBookDict 装有所有联系人的字典->每个字典key对应装有多个联系人模型的数组->每个模型里面包含着用户的相关信息.
 *  @param nameKeys   联系人姓名的大写首字母的数组
 */
typedef void(^RDAddressBookDictBlock)(NSDictionary<NSString *,NSArray *> *addressBookDict,NSArray *nameKeys);

/** 一个联系人的相关信息*/
typedef void(^RDAddressModelBlock)(RDAddressModel *model);

//error 101没有权限 102配置文件出错 103归档文件时出错
typedef void(^RDAddressBookFailure)(NSError * error);

@interface RDAddressManager : NSObject

+ (instancetype)manager;

/**
 *  获取按A~Z顺序排列的所有联系人
 *
 *  @param addressBookInfo 装着A~Z排序的联系人字典Block回调
 *  @param failure         授权失败的Block
 */
- (void)getOrderAddressBook:(RDAddressBookDictBlock)addressBookInfo authorizationFailure:(RDAddressBookFailure)failure;

/**
 *  获取按A~Z顺序排列的所有客户
 *
 *  @param addressBookInfo 装着A~Z排序的客户字典Block回调
 *  @param failure         授权失败的Block
 */
- (void)getOrderCustomerBook:(RDAddressBookDictBlock)addressBookInfo authorizationFailure:(RDAddressBookFailure)failure;

- (void)addCustomerBook:(NSArray<RDAddressModel *> *)models success:(void(^)())successBlock authorizationFailure:(RDAddressBookFailure)failure;

- (void)addCustomerBookWithNetList:(NSArray *)customerList success:(void(^)())successBlock authorizationFailure:(RDAddressBookFailure)failure;

@end
