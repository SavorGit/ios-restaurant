//
//  SelectRoomViewController.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "ReGetRoomModel.h"

typedef void (^backData)(ReGetRoomModel *tmpModel);

@interface SelectRoomViewController : ResBaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) backData backDatas;

@end
