//
//  CustomerTagView.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerTagView : UIView

@property (nonatomic, assign) BOOL lightEnbale;

@property (nonatomic, strong) NSMutableArray * lightIDArray;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) NSMutableArray * titleArray;

- (void)reloadTagSource:(NSArray *)dataSource;

- (NSArray *)getLightTagSource;

@end
