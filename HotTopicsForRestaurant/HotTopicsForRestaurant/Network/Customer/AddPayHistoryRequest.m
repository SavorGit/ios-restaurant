//
//  AddPayHistoryRequest.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddPayHistoryRequest.h"

@implementation AddPayHistoryRequest

- (instancetype)initWithCustomerID:(NSString *)customerID name:(NSString *)name telNumber:(NSString *)telNumber imagePaths:(NSString *)imagePaths tagIDs:(NSString *)tagIDs model:(RDAddressModel *)model
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Customer/addSignleConsumeRecord?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        if (isEmptyString(customerID)) {
            
            if (model) {
                if (!isEmptyString(model.invoiceTitle)) {
                    [self setValue:model.invoiceTitle forParamKey:@"bill_info"];
                }
                if (!isEmptyString(model.birthday)) {
                    [self setValue:model.birthday forParamKey:@"birthday"];
                }
                if (!isEmptyString(model.birthplace)) {
                    [self setValue:model.birthplace forParamKey:@"birthplace"];
                }
                if (!isEmptyString(model.consumptionLevel)) {
                    [self setValue:model.consumptionLevel forParamKey:@"consume_ability"];
                }
                if (!isEmptyString(model.logoImageURL)) {
                    [self setValue:model.logoImageURL forParamKey:@"face_url"];
                }
                if (!isEmptyString(model.gender)) {
                    [self setValue:model.gender forParamKey:@"sex"];
                }
            }
            
        }else{
            [self setValue:customerID forParamKey:@"customer_id"];
        }
        
        if (!isEmptyString(tagIDs)) {
            [self setValue:tagIDs forParamKey:@"lable_id_str"];
        }
        
        [self setValue:imagePaths forParamKey:@"recipt"];
        [self setValue:name forParamKey:@"name"];
        [self setValue:telNumber forParamKey:@"usermobile"];
        [self setValue:[GlobalData shared].userModel.invite_id forParamKey:@"invite_id"];
        [self setValue:[GlobalData shared].userModel.telNumber forParamKey:@"mobile"];
    }
    return self;
}

@end
