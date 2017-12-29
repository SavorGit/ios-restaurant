//
//  CustomerPayHistory.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerPayHistory : UIView

@property (nonatomic, strong) NSMutableArray <UIImage *>* imageArray;

- (void)addImageWithImage:(UIImage *)image;

@end
