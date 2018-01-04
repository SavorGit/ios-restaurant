//
//  RDAddressManager.m
//  通讯录
//
//  Created by 郭春城 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDAddressManager.h"
#import <AddressBook/AddressBook.h>
#import "AddAddressCustomerRequest.h"
#ifdef __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif

#define IS_IOS9_LATER  ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)

NSString * const CustomerBookDidUpdateNotification = @"CustomerBookDidUpdateNotification";

@interface RDAddressManager ()

#ifdef __IPHONE_9_0
/** iOS9之后的通讯录对象*/
@property (nonatomic, strong) CNContactStore *contactStore;
#endif

@end

@implementation RDAddressManager

+ (instancetype)manager
{
    static RDAddressManager * manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


- (void)getOrderAddressBook:(RDAddressBookDictBlock)addressBookInfo authorizationFailure:(RDAddressBookFailure)failure
{
    [self requestAddressBookAuthorizationSuccess:^{
        
        // 将耗时操作放到子线程
        dispatch_queue_t queue = dispatch_queue_create("addressBook.infoDict", DISPATCH_QUEUE_SERIAL);
        
        dispatch_async(queue, ^{
            
            NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
            [self getAddressBookDataSource:^(RDAddressModel *model) {
                //获取到姓名拼音
                NSString *strPinYin = model.pinYin;
                model.searchKey = [NSString stringWithFormat:@"%@%@", model.searchKey, [strPinYin stringByReplacingOccurrencesOfString:@" " withString:@""]];
                
                // 获取并返回首字母
                NSString * firstLetterString =model.firstLetter;
                
                //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
                if (addressBookDict[firstLetterString])
                {
                    [addressBookDict[firstLetterString] addObject:model];
                }
                //没有出现过该首字母，则在字典中新增一组key-value
                else
                {
                    //创建新发可变数组存储该首字母对应的联系人模型
                    NSMutableArray *arrGroupNames = [[NSMutableArray alloc] init];
                    
                    [arrGroupNames addObject:model];
                    //将首字母-姓名数组作为key-value加入到字典中
                    [addressBookDict setObject:arrGroupNames forKey:firstLetterString];
                }
            } authorizationFailure:failure];
            
            // 将addressBookDict字典中的所有Key值进行排序: A~Z
            NSArray *nameKeys = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
            
//            // 将 "#" 排列在 A~Z 的后面
//            if ([nameKeys.firstObject isEqualToString:@"#"])
//            {
//                NSMutableArray *mutableNamekeys = [NSMutableArray arrayWithArray:nameKeys];
//                [mutableNamekeys insertObject:nameKeys.firstObject atIndex:nameKeys.count];
//                [mutableNamekeys removeObjectAtIndex:0];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    addressBookInfo ? addressBookInfo(addressBookDict,mutableNamekeys) : nil;
//                });
//                return;
//            }
//            
            // 将排序好的通讯录数据回调到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                addressBookInfo ? addressBookInfo(addressBookDict,nameKeys) : nil;
            });
            
        });
        
    } failure:^{
        if (failure) {
            failure([NSError errorWithDomain:@"com.RDAddress" code:101 userInfo:nil]);
        }
    }];
}

- (void)getOrderAddressBook:(RDAddressBookDictNoCustomerBlock)addressBookInfo customerList:(NSArray *)customerList authorizationFailure:(RDAddressBookFailure)failure
{
    [self requestAddressBookAuthorizationSuccess:^{
        
        // 将耗时操作放到子线程
        dispatch_queue_t queue = dispatch_queue_create("addressBook.infoDict", DISPATCH_QUEUE_SERIAL);
        
        dispatch_async(queue, ^{
            
            NSMutableArray * noCustomerListArray = [[NSMutableArray alloc] init];
            NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
            [self getAddressBookDataSource:^(RDAddressModel *model) {
                //获取到姓名拼音
                NSString *strPinYin = model.pinYin;
                model.searchKey = [NSString stringWithFormat:@"%@%@", model.searchKey, [strPinYin stringByReplacingOccurrencesOfString:@" " withString:@""]];
                
                // 获取并返回首字母
                NSString * firstLetterString =model.firstLetter;
                
                //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
                if (addressBookDict[firstLetterString])
                {
                    [addressBookDict[firstLetterString] addObject:model];
                }
                //没有出现过该首字母，则在字典中新增一组key-value
                else
                {
                    //创建新发可变数组存储该首字母对应的联系人模型
                    NSMutableArray *arrGroupNames = [[NSMutableArray alloc] init];
                    
                    [arrGroupNames addObject:model];
                    //将首字母-姓名数组作为key-value加入到字典中
                    [addressBookDict setObject:arrGroupNames forKey:firstLetterString];
                }
                
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", model.searchKey];
                NSArray * resultArray = [customerList filteredArrayUsingPredicate:predicate];
                if (!resultArray || resultArray.count == 0) {
                    [noCustomerListArray addObject:model];
                }
                
            } authorizationFailure:failure];
            
            // 将addressBookDict字典中的所有Key值进行排序: A~Z
            NSArray *nameKeys = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
            
            // 将排序好的通讯录数据回调到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                addressBookInfo ? addressBookInfo(addressBookDict,nameKeys,noCustomerListArray) : nil;
            });
            
        });
        
    } failure:^{
        if (failure) {
            failure([NSError errorWithDomain:@"com.RDAddress" code:101 userInfo:nil]);
        }
    }];
}

- (void)getAddressBookDataSource:(RDAddressModelBlock)personModel authorizationFailure:(RDAddressBookFailure)failure
{
    
    if(IS_IOS9_LATER)
    {
        [self getDataSourceFrom_IOS9_Later:personModel authorizationFailure:failure];
    }
    else
    {
        [self getDataSourceFrom_IOS9_Ago:personModel authorizationFailure:failure];
    }
    
}

#pragma mark - IOS9之后获取通讯录的方法
- (void)getDataSourceFrom_IOS9_Later:(RDAddressModelBlock)personModel authorizationFailure:(RDAddressBookFailure)failure
{
#ifdef __IPHONE_9_0
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
//     2.如果没有授权,先执行授权失败的block后return
    if (status != CNAuthorizationStatusAuthorized)
    {
        if (failure) {
            failure([NSError errorWithDomain:@"com.RDAddress" code:101 userInfo:nil]);
        }
        return;
    }
    // 3.获取联系人
    // 3.1.创建联系人仓库
    //CNContactStore *store = [[CNContactStore alloc] init];
    
    // 3.2.创建联系人的请求对象
    // keys决定能获取联系人哪些信息,例:姓名,电话,头像等
    NSArray *fetchKeys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],CNContactPhoneNumbersKey,CNContactBirthdayKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    
    // 3.3.请求联系人
    [self.contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact,BOOL * _Nonnull stop) {
        
        // 获取联系人全名
        NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        
        // 创建联系人模型
        RDAddressModel *model = [RDAddressModel new];
        model.name = name.length > 0 ? name : @"无名氏" ;
        
        //生日
        NSDateComponents * birthdayCompoents = contact.birthday;
        if (birthdayCompoents.month > 0 && birthdayCompoents.day > 0) {
            model.birthday = [NSString stringWithFormat:@"%ld年%ld日", birthdayCompoents.month, birthdayCompoents.day];
        }
        
        // 获取一个人的所有电话号码
        NSArray *phones = contact.phoneNumbers;
        
        NSString * searchKey = model.name;
        for (CNLabeledValue *labelValue in phones)
        {
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *mobile = [self removeSpecialSubString:phoneNumber.stringValue];
            mobile = mobile ? mobile : @"空号";
            [model.mobileArray addObject: mobile];
            searchKey = [NSString stringWithFormat:@"%@%@", searchKey, mobile];
            
        }
        model.searchKey = searchKey;
        
        //将联系人模型回调出去
        personModel ? personModel(model) : nil;
    }];
#endif
    
}

#pragma mark - IOS9之前获取通讯录的方法
- (void)getDataSourceFrom_IOS9_Ago:(RDAddressModelBlock)personModel authorizationFailure:(RDAddressBookFailure)failure
{
//     1.获取授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();

    // 2.如果没有授权,先执行授权失败的block后return
    if (status != kABAuthorizationStatusAuthorized/** 已经授权*/)
    {
        if (failure) {
            failure([NSError errorWithDomain:@"com.RDAddress" code:101 userInfo:nil]);
        }
        return;
    }
    
    // 3.创建通信录对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //4.按照排序规则从通信录对象中请求所有的联系人,并按姓名属性中的姓(LastName)来排序
    ABRecordRef recordRef = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeopleArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, recordRef, kABPersonSortByLastName);
    
    // 5.遍历每个联系人的信息,并装入模型
    for(id personInfo in (__bridge NSArray *)allPeopleArray)
    {
        RDAddressModel *model = [RDAddressModel new];
        
        // 5.1获取到联系人
        ABRecordRef person = (__bridge ABRecordRef)(personInfo);
        
        // 5.2获取全名
        NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
        model.name = name.length > 0 ? name : @"无名氏" ;
        
        //生日
        NSDate *birthday = (__bridge_transfer NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"mm月dd日"];
        model.birthday = [formatter stringFromDate:birthday];
        
        // 5.4获取每个人所有的电话号码
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        NSString * searchKey = model.name;
        for (CFIndex i = 0; i < phoneCount; i++)
        {
            // 号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSString *mobile = [self removeSpecialSubString:phoneValue];
            mobile = mobile ? mobile : @"空号";
            [model.mobileArray addObject: mobile];
            
            searchKey = [NSString stringWithFormat:@"%@%@", searchKey, mobile];
        }
        model.searchKey = searchKey;
        // 5.5将联系人模型回调出去
        personModel ? personModel(model) : nil;
        
        CFRelease(phones);
    }
    
    // 释放不再使用的对象
    CFRelease(allPeopleArray);
    CFRelease(recordRef);
    CFRelease(addressBook);
    
}

#pragma mark - 获取客户列表
- (void)getOrderCustomerBook:(RDAddressBookDictBlock)addressBookInfo authorizationFailure:(RDAddressBookFailure)failure
{
    if ([self checkUserDocmentPath]) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString * customerPath = [self getCustomerListPath];
        
        if ([fileManager fileExistsAtPath:customerPath]) {
            
            NSDictionary * addressBookDict = [NSKeyedUnarchiver unarchiveObjectWithFile:customerPath];
            
            if ([addressBookDict isKindOfClass:[NSDictionary class]] && addressBookDict.count > 0) {
                NSArray *nameKeys = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
                addressBookInfo(addressBookDict, nameKeys);
            }else{
                failure([NSError errorWithDomain:@"com.RDAddress" code:102 userInfo:nil]);
            }
            
        }else{
            addressBookInfo([NSDictionary new], [NSArray new]);
        }
    }else{
        failure([NSError errorWithDomain:@"com.RDAddress" code:102 userInfo:nil]);
    }
}

#pragma mark - 添加客户列表
- (void)firstAddCustomerBook:(NSArray<RDAddressModel *> *)models success:(void (^)())successBlock authorizationFailure:(RDAddressBookFailure)failure
{
    if ([self checkUserDocmentPath]) {
        NSString * customerPath = [self getCustomerListPath];
        
        [self getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
            
            NSMutableDictionary * customerDict = [NSMutableDictionary dictionaryWithDictionary:addressBookDict];
            // 将耗时操作放到子线程
            dispatch_queue_t queue = dispatch_queue_create("addressBook.infoDict", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                
                NSMutableArray * dataArray = [[NSMutableArray alloc] init];
                
                for (RDAddressModel * model in models) {
                    //获取到姓名拼音
                    NSString *strPinYin = model.pinYin;
                    model.searchKey = [NSString stringWithFormat:@"%@%@", model.searchKey, [strPinYin stringByReplacingOccurrencesOfString:@" " withString:@""]];
                    
                    // 获取并返回首字母
                    NSString * firstLetterString =model.firstLetter;
                    
                    //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
                    if (customerDict[firstLetterString])
                    {
                        [customerDict[firstLetterString] addObject:model];
                    }
                    //没有出现过该首字母，则在字典中新增一组key-value
                    else
                    {
                        //创建新发可变数组存储该首字母对应的联系人模型
                        NSMutableArray *arrGroupNames = [[NSMutableArray alloc] init];
                        
                        [arrGroupNames addObject:model];
                        //将首字母-姓名数组作为key-value加入到字典中
                        [customerDict setObject:arrGroupNames forKey:firstLetterString];
                    }
                    [dataArray addObject:[self getCustomerInfoWithModel:model]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([NSKeyedArchiver archiveRootObject:customerDict toFile:customerPath]) {
                        //保存成功
                        successBlock();
                        [[NSNotificationCenter defaultCenter] postNotificationName:CustomerBookDidUpdateNotification object:nil];
                        
                    }else{
                        
                        //保存失败
                        failure([NSError errorWithDomain:@"com.RDAddress" code:103 userInfo:nil]);
                        
                    }
                    
                });
                
            });
            
        } authorizationFailure:failure];
        
    }else{
        failure([NSError errorWithDomain:@"com.RDAddress" code:102 userInfo:nil]);
    }
}

- (void)addCustomerBook:(NSArray<RDAddressModel *> *)models success:(void (^)())successBlock authorizationFailure:(RDAddressBookFailure)failure
{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSMutableArray * modelSource = [[NSMutableArray alloc] init];
    for (RDAddressModel * model in models) {
        [dataArray addObject:[self getCustomerInfoWithModel:model]];
    }
    
    AddAddressCustomerRequest * request = [[AddAddressCustomerRequest alloc] initWithCustomers:dataArray];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray * list = [result objectForKey:@"customer_list"];
            
            for (NSDictionary * dict in list) {
                RDAddressModel * model = [[RDAddressModel alloc] initWithNetDict:dict];
                [modelSource addObject:model];
            }
        }
        
        [self addNewCustomerBook:modelSource success:successBlock authorizationFailure:failure];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self uploadFailWithModels:models];
        [modelSource addObjectsFromArray:models];
        [self addNewCustomerBook:modelSource success:successBlock authorizationFailure:failure];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self uploadFailWithModels:models];
        [modelSource addObjectsFromArray:models];
        [self addNewCustomerBook:modelSource success:successBlock authorizationFailure:failure];
        
    }];
}

- (void)uploadFailWithModels:(NSArray *)models
{
    dispatch_queue_t queue = dispatch_queue_create("addressBook.infoDict", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSString * path = [self getCustomerUploadFailPath];
        NSMutableArray * dataArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
        if (!dataArray) {
            dataArray = [[NSMutableArray alloc] init];
        }
        for (RDAddressModel * model in models) {
            NSDictionary * dict = [self getCustomerInfoWithModel:model];
            [dataArray addObject:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dataArray writeToFile:path atomically:YES]) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    NSLog(@"成功");
                }else{
                    NSLog(@"失败");
                }
            }else{
                NSLog(@"失败");
            }
        });
    });
}

- (void)checkCustomerFailHandle
{
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * uploadPath = [self getCustomerUploadFailPath];
    if ([manager fileExistsAtPath:uploadPath]) {
        
        NSArray * dataArray = [[NSArray alloc] initWithContentsOfFile:uploadPath];
        AddAddressCustomerRequest * request = [[AddAddressCustomerRequest alloc] initWithCustomers:dataArray];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [manager removeItemAtPath:uploadPath error:nil];
            NSDictionary * result = [response objectForKey:@"result"];
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSArray * list = [result objectForKey:@"customer_list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    [self uploadCustomerWithArray:list success:^{
                        
                    } authorizationFailure:^(NSError *error) {
                        
                    }];
                }
            }
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
        }];
        
    }
}

- (void)updateCustomerWithModel:(RDAddressModel *)model success:(RDAddressModelBlock)successBlock authorizationFailure:(RDAddressBookFailure)failure
{
    // 获取并返回首字母
    NSString * firstLetterString =model.firstLetter;
    [self getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        if (addressBookDict[firstLetterString]) {
            
            NSMutableDictionary * customerDict = [NSMutableDictionary dictionaryWithDictionary:addressBookDict];
            NSArray * customerList = [customerDict objectForKey:firstLetterString];
            NSMutableArray * customerData = [NSMutableArray arrayWithArray:customerList];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", model.searchKey];
            NSArray * resultArray = [customerData filteredArrayUsingPredicate:predicate];
            if (resultArray && resultArray.count > 0) {
                RDAddressModel * resultModel = [resultArray firstObject];
                
                if ([customerData containsObject:resultModel]) {
                    NSInteger index = [customerData indexOfObject:resultModel];
                    [customerData replaceObjectAtIndex:index withObject:model];
                }else{
                    [customerData addObject:model];
                }
                
                [customerDict setValue:customerData forKey:firstLetterString];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * customerPath = [self getCustomerListPath];
                    
                    if ([NSKeyedArchiver archiveRootObject:customerDict toFile:customerPath]) {
                        successBlock(model);
                        [[NSNotificationCenter defaultCenter] postNotificationName:CustomerBookDidUpdateNotification object:nil];
                    }else{
                        failure([NSError errorWithDomain:@"com.RDAddress" code:103 userInfo:nil]);
                    }
                });
                
            }else{
                failure([NSError errorWithDomain:@"com.RDAddress" code:404 userInfo:nil]);
            }
            
        }else{
            failure([NSError errorWithDomain:@"com.RDAddress" code:404 userInfo:nil]);
        }
        
    } authorizationFailure:failure];
}

- (void)uploadCustomerWithArray:(NSArray *)dataSource success:(void (^)())successBlock authorizationFailure:(RDAddressBookFailure)failure
{
    
    [self getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        NSMutableDictionary * customerDict = [NSMutableDictionary dictionaryWithDictionary:addressBookDict];
        
        for (NSDictionary * info in dataSource) {
            
            RDAddressModel * model = [[RDAddressModel alloc] initWithNetDict:info];
            
            // 获取并返回首字母
            NSString * firstLetterString = model.firstLetter;
            
            if (customerDict[firstLetterString]) {
                
                NSArray * customerList = [customerDict objectForKey:firstLetterString];
                NSMutableArray * customerData = [NSMutableArray arrayWithArray:customerList];
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", model.searchKey];
                NSArray * resultArray = [customerData filteredArrayUsingPredicate:predicate];
                if (resultArray && resultArray.count > 0) {
                    RDAddressModel * resultModel = [resultArray firstObject];
                    
                    if ([customerData containsObject:resultModel]) {
                        NSInteger index = [customerData indexOfObject:resultModel];
                        [customerData replaceObjectAtIndex:index withObject:model];
                    }else{
                        [customerData addObject:model];
                    }
                }else{
                    [customerData addObject:model];
                }
                [customerDict setValue:customerData forKey:firstLetterString];
                
            }else{
                //创建新发可变数组存储该首字母对应的联系人模型
                NSMutableArray *arrGroupNames = [[NSMutableArray alloc] init];
                
                [arrGroupNames addObject:model];
                //将首字母-姓名数组作为key-value加入到字典中
                [customerDict setObject:arrGroupNames forKey:firstLetterString];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * customerPath = [self getCustomerListPath];
            
            if ([NSKeyedArchiver archiveRootObject:customerDict toFile:customerPath]) {
                successBlock();
                [[NSNotificationCenter defaultCenter] postNotificationName:CustomerBookDidUpdateNotification object:nil];
            }else{
                failure([NSError errorWithDomain:@"com.RDAddress" code:103 userInfo:nil]);
            }
        });
        
    } authorizationFailure:failure];
}

- (void)updateCustomerWithArray:(NSArray *)dataSource success:(void (^)())successBlock authorizationFailure:(RDAddressBookFailure)failure
{
    
    [self getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        NSMutableDictionary * customerDict = [NSMutableDictionary dictionaryWithDictionary:addressBookDict];
        
        for (NSDictionary * info in dataSource) {
            
            RDAddressModel * model = [[RDAddressModel alloc] initWithNetDict:info];
            
            // 获取并返回首字母
            NSString * firstLetterString = model.firstLetter;
            
            if (customerDict[firstLetterString]) {
                
                NSArray * customerList = [customerDict objectForKey:firstLetterString];
                NSMutableArray * customerData = [NSMutableArray arrayWithArray:customerList];
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", model.searchKey];
                NSArray * resultArray = [customerData filteredArrayUsingPredicate:predicate];
                if (resultArray && resultArray.count > 0) {
                    RDAddressModel * resultModel = [resultArray firstObject];
                    
                    if ([customerData containsObject:resultModel]) {
                        NSInteger index = [customerData indexOfObject:resultModel];
                        [customerData replaceObjectAtIndex:index withObject:model];
                    }else{
                        [customerData addObject:model];
                    }
                }else{
                    [customerData addObject:model];
                }
                [customerDict setValue:customerData forKey:firstLetterString];
                
            }else{
                //创建新发可变数组存储该首字母对应的联系人模型
                NSMutableArray *arrGroupNames = [[NSMutableArray alloc] init];
                
                [arrGroupNames addObject:model];
                //将首字母-姓名数组作为key-value加入到字典中
                [customerDict setObject:arrGroupNames forKey:firstLetterString];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * customerPath = [self getCustomerListPath];
            
            if ([NSKeyedArchiver archiveRootObject:customerDict toFile:customerPath]) {
                successBlock();
                [[NSNotificationCenter defaultCenter] postNotificationName:CustomerBookDidUpdateNotification object:nil];
            }else{
                failure([NSError errorWithDomain:@"com.RDAddress" code:103 userInfo:nil]);
            }
        });
        
    } authorizationFailure:failure];
}

- (NSDictionary *)getCustomerInfoWithModel:(RDAddressModel *)model
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    if (!isEmptyString(model.name)) {
        [params setObject:model.name forKey:@"name"];
    }
    
    if (model.mobileArray) {
        for (NSInteger i = 0; i < model.mobileArray.count; i++) {
            if (i == 0) {
                [params setValue:[model.mobileArray objectAtIndex:0] forKey:@"mobile"];
            }else if (i == 1) {
                [params setValue:[model.mobileArray objectAtIndex:1] forKey:@"mobile1"];
            }
        }
    }
    
    if (!isEmptyString(model.gender)) {
        [params setValue:model.gender forKey:@"sex"];
    }
    if (!isEmptyString(model.birthday)) {
        [params setValue:model.birthday forKey:@"birthday"];
    }
    if (!isEmptyString(model.birthplace)) {
        [params setValue:model.birthplace forKey:@"birthplace"];
    }
    if (!isEmptyString(model.invoiceTitle)) {
        [params setValue:model.invoiceTitle forKey:@"bill_info"];
    }
    if (!isEmptyString(model.consumptionLevel)) {
        [params setValue:model.consumptionLevel forKey:@"consume_ability"];
    }
    
    return [NSDictionary dictionaryWithDictionary:params];
}

- (void)addNewCustomerBook:(NSArray<RDAddressModel *> *)models success:(void (^)())successBlock authorizationFailure:(RDAddressBookFailure)failure
{
    if ([self checkUserDocmentPath]) {
        NSString * customerPath = [self getCustomerListPath];;
        
        [self getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
            
            NSMutableDictionary * customerDict = [NSMutableDictionary dictionaryWithDictionary:addressBookDict];
            // 将耗时操作放到子线程
            dispatch_queue_t queue = dispatch_queue_create("addressBook.infoDict", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                
                for (RDAddressModel * model in models) {
                    //获取到姓名拼音
                    NSString *strPinYin = model.pinYin;
                    model.searchKey = [NSString stringWithFormat:@"%@%@", model.searchKey, [strPinYin stringByReplacingOccurrencesOfString:@" " withString:@""]];
                    
                    NSString * firstLetterString =model.firstLetter;
                    
                    //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
                    if (customerDict[firstLetterString])
                    {
                        [customerDict[firstLetterString] addObject:model];
                    }
                    //没有出现过该首字母，则在字典中新增一组key-value
                    else
                    {
                        //创建新发可变数组存储该首字母对应的联系人模型
                        NSMutableArray *arrGroupNames = [[NSMutableArray alloc] init];
                        
                        [arrGroupNames addObject:model];
                        //将首字母-姓名数组作为key-value加入到字典中
                        [customerDict setObject:arrGroupNames forKey:firstLetterString];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([NSKeyedArchiver archiveRootObject:customerDict toFile:customerPath]) {
                        successBlock();
                        [[NSNotificationCenter defaultCenter] postNotificationName:CustomerBookDidUpdateNotification object:nil];
                    }else{
                        failure([NSError errorWithDomain:@"com.RDAddress" code:103 userInfo:nil]);
                    }
                });
                
            });
            
        } authorizationFailure:failure];
        
    }else{
        failure([NSError errorWithDomain:@"com.RDAddress" code:102 userInfo:nil]);
    }
}

- (void)addCustomerBookWithNetList:(NSArray *)customerList success:(void (^)())successBlock authorizationFailure:(RDAddressBookFailure)failure
{
    [self getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        if (nil == nameKeys || nameKeys.count == 0) {
            
            NSMutableArray * customerListArray = [[NSMutableArray alloc] init];
            for (NSDictionary * dict in customerList) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    RDAddressModel * model = [[RDAddressModel alloc] initWithNetDict:dict];
                    [customerListArray addObject:model];
                }
            }
            [self firstAddCustomerBook:customerListArray success:successBlock authorizationFailure:failure];
            
        }else{
            failure([NSError errorWithDomain:@"com.RDAddress" code:666 userInfo:nil]);
        }
        
    } authorizationFailure:^(NSError *error) {
        
        NSMutableArray * customerListArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in customerList) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RDAddressModel * model = [[RDAddressModel alloc] initWithNetDict:dict];
                [customerListArray addObject:model];
            }
        }
        [self firstAddCustomerBook:customerListArray success:successBlock authorizationFailure:failure];
        
    }];
}

#pragma mark - 判断本地用户配置文件夹是否存在
- (BOOL)checkUserDocmentPath
{
    BOOL isSuccess = NO;
    
    NSString * telNumber = [GlobalData shared].userModel.telNumber;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * userPath = [RestaurantDocument stringByAppendingPathComponent:telNumber];
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:userPath isDirectory:&isDirectory]) {
        
        if (isDirectory) {
            isSuccess = YES;
        }else{
            isSuccess = [fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
    }else{
        isSuccess = [fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return isSuccess;
}

//#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
//- (NSString *)getFirstLetterFromString:(NSString *)aString
//{
//    /**
//     * **************************************** START ***************************************
//     * 之前PPGetAddressBook对联系人排序时在中文转拼音这一部分非常耗时
//     * 参考博主-庞海礁先生的一文:iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131
//     * 使PPGetAddressBook对联系人排序的性能提升 3~6倍, 非常感谢!
//     */
//    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
//    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
//    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
//    /**
//     *  *************************************** END ******************************************
//     */
//
//    // 将拼音首字母装换成大写
//    NSString *strPinYin = [[self polyphoneStringHandle:aString pinyinString:pinyinString] uppercaseString];
//    return strPinYin;
//
//}
//
///**
// 多音字处理
// */
//- (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
//{
//    if ([aString hasPrefix:@"长"]) { return @"chang";}
//    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
//    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
//    if ([aString hasPrefix:@"地"]) { return @"di";   }
//    if ([aString hasPrefix:@"重"]) { return @"chong";}
//    return pinyinString;
//}

//过滤指定字符串(可自定义添加自己过滤的字符串)
- (NSString *)removeSpecialSubString: (NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

- (void)requestAddressBookAuthorizationSuccess:(void(^)(void))successBlock failure:(void(^)(void))failureBlock
{
    if (IS_IOS9_LATER) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined) {
            [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (granted) {
                        NSLog(@"允许访问");
                        successBlock();
                    }else{
                        NSLog(@"不允许访问");
                        failureBlock();
                    }
                    
                });
                
            }];
        }else if (status == CNAuthorizationStatusAuthorized) {
            NSLog(@"允许访问");
            successBlock();
        }else{
            NSLog(@"不允许访问");
            failureBlock();
        }
    }else{
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRef bookRef = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (granted) {
                        NSLog(@"允许访问");
                        successBlock();
                    }else{
                        NSLog(@"不允许访问");
                        failureBlock();
                    }
                });
            });
        }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            NSLog(@"允许访问");
            successBlock();
        }else{
            NSLog(@"不允许访问");
            failureBlock();
        }
    }
}

- (NSString *)getCustomerListPath
{
    NSString * telNumber = [GlobalData shared].userModel.telNumber;
    NSString * userPath = [RestaurantDocument stringByAppendingPathComponent:telNumber];
    NSString * customerPath = [userPath stringByAppendingPathComponent:ResCustomerPathComponent];
    return customerPath;
}

- (NSString *)getCustomerUploadFailPath
{
    NSString * telNumber = [GlobalData shared].userModel.telNumber;
    NSString * userPath = [RestaurantDocument stringByAppendingPathComponent:telNumber];
    NSString * customerPath = [userPath stringByAppendingPathComponent:ResCustomerUploadFailPath];
    return customerPath;
}

- (CNContactStore *)contactStore
{
    if(!_contactStore)
    {
        _contactStore = [[CNContactStore alloc] init];
    }
    return _contactStore;
}

@end
