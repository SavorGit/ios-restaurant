//
//  GetRoomListRequest.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetRoomListRequest : BGNetworkRequest

- (instancetype)initWithInviteId:(NSString *)inviteId andMobile:(NSString *)mobile;

@end
