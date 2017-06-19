//
//  GCCDLNA.m
//  DLNATest
//
//  Created by 郭春城 on 16/10/10.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "GCCDLNA.h"
#import "GCDAsyncUdpSocket.h"
#import "HSGetIpRequest.h"

static NSString *ssdpForPlatform = @"238.255.255.250"; //监听小平台ssdp地址

static UInt16 platformPort = 11900; //监听小平台ssdp端口

@interface GCCDLNA ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket * socket;
@property (nonatomic, assign) BOOL isSearchPlatform;

@property (nonatomic, assign) NSInteger hotelId_Box; //盒子获取的酒楼ID

@end

@implementation GCCDLNA

+ (GCCDLNA *)defaultManager
{
    static dispatch_once_t once;
    static GCCDLNA *manager;
    dispatch_once(&once, ^ {
        manager = [[GCCDLNA alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.hotelId_Box = 0;
        self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.isSearchPlatform = NO;
    }
    return self;
}

//配置小平台设备搜索的socket相关端口信息
- (void)setUpSocketForPlatform
{
    NSError *error = nil;
    if (![self.socket bindToPort:platformPort error:&error])
    {
        NSLog(@"Error binding: %@", error);
    }
    if (![self.socket joinMulticastGroup:ssdpForPlatform error:&error])
    {
        NSLog(@"Error join: %@", error);
    }
    if (![self.socket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
    }
}

- (void)startSearchPlatform
{
    if (self.isSearch) {
        [self resetSearch];
    }
    
    self.isSearch = YES;
    
    if (!self.socket.isClosed) {
        [self.socket close]; //先关闭当前的socket连接
    }
    [GlobalData shared].scene = RDSceneNothing;
    [GlobalData shared].callQRCodeURL = @"";
    [GlobalData shared].boxCodeURL = @"";
    [GlobalData shared].secondCallCodeURL = @"";
    [GlobalData shared].thirdCallCodeURL = @"";
    [self setUpSocketForPlatform]; //若当前socket处于关闭状态，先配置socket地址和端口
    [self getIP];
    self.isSearchPlatform = YES;
    [self performSelector:@selector(stopSearchDevice) withObject:nil afterDelay:10.f];
}

- (void)getIP
{
    HSGetIpRequest * request = [[HSGetIpRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        NSInteger code = [response[@"code"] integerValue];
        if(code == 10000){
            
            NSString *localIp = response[@"result"][@"localIp"];
            NSString *hotelId = response[@"result"][@"hotelId"];
            NSString *type = response[@"result"][@"type"];
            NSString *command_port = response[@"result"][@"command_port"];
            NSInteger areaIdInt = [response[@"result"][@"area_id"] integerValue];
            [GlobalData shared].areaId = [NSString stringWithFormat:@"%ld", areaIdInt];
            
            if (isEmptyString(type)) {
                type = @"";
            }
            if (isEmptyString(command_port)) {
                command_port = @"";
            }
            
            if (!isEmptyString(localIp) && !isEmptyString(hotelId)) {
                if ([GlobalData shared].secondCallCodeURL.length > 0) {
                    NSString * codeURL = [NSString stringWithFormat:@"http://%@:%@/%@",localIp,command_port,[type lowercaseString]];
                    
                    if (![[GlobalData shared].secondCallCodeURL isEqualToString:codeURL]) {
                        [GlobalData shared].thirdCallCodeURL = codeURL;
                    }
                }else{
                    
                    if (isEmptyString(localIp)) {
                        localIp = @"";
                    }
                    
                    [GlobalData shared].secondCallCodeURL = [NSString stringWithFormat:@"http://%@:%@/%@",localIp,command_port,[type lowercaseString]];
                }
                
                if (isEmptyString(hotelId)) {
                    [GlobalData shared].hotelId = 0;
                }else{
                    [GlobalData shared].hotelId = [hotelId integerValue];
                }
                
                [GlobalData shared].scene = RDSceneHaveRDBox;
            }
        }
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

//停止设备搜索
- (void)stopSearchDevice
{
    if (![GlobalData shared].isBindRD && [GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
        // 搜索设备结束发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:RDStopSearchDeviceNotification object:nil];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSearchDevice) object:nil];
    
    if (!self.socket.isClosed) {
        [self.socket close]; //调用socket关闭
    }
    
    self.isSearch = NO;
}

- (void)stopSearchDeviceWithNetWorkChange
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RDDidNotFoundSenceNotification object:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSearchDevice) object:nil];
    
    if (!self.socket.isClosed) {
        [self.socket close]; //调用socket关闭
    }
    
    self.isSearch = NO;
}

- (void)resetSearch
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSearchDevice) object:nil];
}

//获取到设备反馈信息
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext{
    
    if (self.isSearchPlatform) {
        [self getPlatformHeadURLWith:data];
    }
}

//解析从小平台获取的SSDP的discover信息
- (NSString *)getPlatformHeadURLWith:(NSData *)data
{
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray * array = [str componentsSeparatedByString:@"\n"];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    for (NSString * infoStr in array) {
        NSArray * dictArray = [infoStr componentsSeparatedByString:@":"];
        if (dictArray.count == 2) {
            [dict setObject:[dictArray objectAtIndex:1] forKey:[dictArray objectAtIndex:0]];
        }
    }
    
    NSString * host = [dict objectForKey:@"Savor-HOST"];
    NSString * boxHost = [dict objectForKey:@"Savor-Box-HOST"];
    if (host.length || boxHost.length) {
        
        if ([[dict objectForKey:@"Savor-Type"] isEqualToString:@"box"]) {
            [GlobalData shared].boxCodeURL = [NSString stringWithFormat:@"http://%@:8080", [dict objectForKey:@"Savor-Box-HOST"]];
            if ([GlobalData shared].secondCallCodeURL.length > 0) {
                
                NSString * codeURL = [NSString stringWithFormat:@"http://%@:%@/small", [dict objectForKey:@"Savor-HOST"], [dict objectForKey:@"Savor-Port-Command"]];
                if (![[GlobalData shared].secondCallCodeURL isEqualToString:codeURL]) {
                    [GlobalData shared].thirdCallCodeURL = codeURL;
                }
                
            }else{
                [GlobalData shared].secondCallCodeURL = [NSString stringWithFormat:@"http://%@:%@/small", [dict objectForKey:@"Savor-HOST"], [dict objectForKey:@"Savor-Port-Command"]];
            }
            [GlobalData shared].hotelId = [[dict objectForKey:@"Savor-Hotel-ID"] integerValue];
            self.hotelId_Box = [[dict objectForKey:@"Savor-Hotel-ID"] integerValue];
            [GlobalData shared].scene = RDSceneHaveRDBox;
            self.isSearch = NO;
        }else{
            [GlobalData shared].callQRCodeURL = [NSString stringWithFormat:@"http://%@:%@/%@", [dict objectForKey:@"Savor-HOST"], [dict objectForKey:@"Savor-Port-Command"], [[dict objectForKey:@"Savor-Type"] lowercaseString]];
            [GlobalData shared].hotelId = [[dict objectForKey:@"Savor-Hotel-ID"] integerValue];
            [GlobalData shared].scene = RDSceneHaveRDBox;
            self.isSearch = NO;
        }
    }
    
    return nil;
}

@end
