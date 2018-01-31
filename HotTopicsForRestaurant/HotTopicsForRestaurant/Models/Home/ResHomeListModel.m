//
//  ResHomeListModel.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResHomeListModel.h"

@implementation ResHomeListModel

- (instancetype)initWithType:(ResHomeListType)type
{
    if (self = [super init]) {
        self.type = type;
        switch (type) {
            case ResHomeListType_Dishes:
            {
                self.title = @"推荐菜";
                self.imageName = @"tjc";
            }
                break;
                
            case ResHomeListType_Trailer:
            {
                self.title = @"宣传片";
                self.imageName = @"xcp";
            }
                break;
                
            case ResHomeListType_Words:
            {
                self.title = @"欢迎词";
                self.imageName = @"hyc";
            }
                break;
                
            case ResHomeListType_Photo:
            {
                self.title = @"照片";
                self.imageName = @"zp_home";
            }
                break;
                
            case ResHomeListType_Video:
            {
                self.title = @"视频";
                self.imageName = @"sp_home";
            }
                break;
                
            case ResHomeListType_Restaurant:
            {
                self.title = @"餐厅服务";
                self.imageName = @"tjc";
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

@end
