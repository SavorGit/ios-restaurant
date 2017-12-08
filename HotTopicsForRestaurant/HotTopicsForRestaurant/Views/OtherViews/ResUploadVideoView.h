//
//  ResUploadVideoView.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResUploadVideoView : UIView

@property (nonatomic, assign) NSInteger videoDuration;

- (instancetype)initWithAssetIDS:(NSArray *)assetIDS totalTime:(NSInteger)totalTime quality:(NSInteger)quality groupName:(NSString *)groupName handler:(void(^)(NSError *error))handler;

- (void)startUpload;

- (void)endUpload;

@end
