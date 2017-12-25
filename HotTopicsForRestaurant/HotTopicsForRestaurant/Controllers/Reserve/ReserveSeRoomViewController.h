//
//  ReserveSeRoomViewController.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "ReserveModel.h"

typedef void (^backData)(ReserveModel *tmpModel);

@interface ReserveSeRoomViewController : ResBaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) backData backDatas;

@end
