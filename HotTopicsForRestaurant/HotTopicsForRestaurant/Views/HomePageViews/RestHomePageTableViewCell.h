//
//  RestHomePageTableViewCell.h
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/6/9.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestHomePageTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *classImageView;
@property(nonatomic, strong) UILabel *classTitleLabel;
@property(nonatomic, strong) UILabel *unavaiTitleLabel;

- (void)configDatas:(NSArray *)dataArr withIndex:(NSIndexPath *)index;

@end
