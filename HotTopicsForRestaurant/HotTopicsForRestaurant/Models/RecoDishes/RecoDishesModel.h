//
//  RecoDishesModel.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/11/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecoDishesModel : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) NSInteger duration;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *imageURL;

@end
