//
//  SelectRoomViewController.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "RDBoxModel.h"

typedef void (^backData)(RDBoxModel *tmpModel);

@interface SelectRoomViewController : ResBaseViewController

- (instancetype)initWithNeedUpdateList;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) backData backDatas;

@end
