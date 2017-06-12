//
//  HSWebServerManager.m
//  SavorX
//
//  Created by 郭春城 on 16/12/14.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "HSWebServerManager.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerFileResponse.h"
#import "RDAlertView.h"

@implementation HSWebServerManager

@synthesize webServer;

+ (instancetype)manager
{
    static HSWebServerManager *manager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
        
    });
    
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        webServer = [[GCDWebServer alloc] init];
    }
    return self;
}

- (void)start
{

}

- (void)stop
{
    [webServer stop];
}

@end
