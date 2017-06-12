//
//  RDBoxModel.h
//  SavorX
//
//  Created by 郭春城 on 16/12/13.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDBoxModel : NSObject

// 机顶盒地址
@property (nonatomic, copy) NSString *BoxIP;

// 机顶盒ID(MAC)
@property (nonatomic, copy) NSString *BoxID;

//酒楼ID
@property (nonatomic, assign) NSInteger hotelID;

//包间ID
@property (nonatomic, assign) NSInteger roomID;

//连接的wifi
@property (nonatomic, copy) NSString *sid;

@end
