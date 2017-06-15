//
//  DefalutLaunchPlayView.m
//  RDLaunchTest
//
//  Created by 郭春城 on 2017/3/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "DefalutLaunchPlayView.h"

@interface DefalutLaunchPlayView ()

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) NSURL * URL;

@end

@implementation DefalutLaunchPlayView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setVideoURL:(NSString *)url
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:url]];
    self.player = [AVPlayer playerWithPlayerItem:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEndBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEndPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.player play];
}

- (void)applicationDidEndBackground
{
    [self.player pause];
}

- (void)applicationDidEndPlayground
{
    [self.player play];
}

// 重写这个方法，告诉系统，这个View的Layer不是普通的Layer，而是用于播放视频的Layer
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

// AVPlayerLayer 有一个播放器，对播放器的取值和设值，都传递给AVPlayerLayer
- (void)setPlayer:(AVPlayer *)player
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.player = player;
}

- (AVPlayer *)player
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    return playerLayer.player;
}

@end
