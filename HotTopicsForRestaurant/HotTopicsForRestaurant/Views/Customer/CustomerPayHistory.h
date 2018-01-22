//
//  CustomerPayHistory.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerPayHistoryDelegate<NSObject>

- (void)clickBackData:(NSString *)imgUrl;

@end

@interface CustomerPayHistory : UIView

@property (nonatomic, strong) NSMutableArray <UIImage *>* imageArray;

@property (nonatomic, assign) id<CustomerPayHistoryDelegate> delegate;

- (void)addImageWithImage:(UIImage *)image;

- (void)addImageWithImgUrl:(NSString *)imgUrl;

@end
