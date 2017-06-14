//
//  ReUploadingImagesView.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/6/14.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReUploadingImagesView : UIView

@property (nonatomic, copy) void (^block)(BOOL isSuccess);

- (instancetype)initWithImagesArray:(NSArray *)imageArr otherDic:(NSDictionary *)parmDic handler:(void (^)(BOOL isSuccess))handler;

@end
