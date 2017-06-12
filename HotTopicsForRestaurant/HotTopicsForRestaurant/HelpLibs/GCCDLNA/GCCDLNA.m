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


static NSString *serviceAVTransport = @"urn:schemas-upnp-org:service:AVTransport:1";
static NSString *serviceRendering = @"urn:schemas-upnp-org:service:RenderingControl:1";

@interface GCCDLNA ()<GCDAsyncUdpSocketDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray * locationSource;
@property (nonatomic, strong) GCDAsyncUdpSocket * socket;
@property (nonatomic, assign) BOOL isSearchPlatform;
@property (nonatomic, assign) BOOL hasUploadLog;

@property (nonatomic, assign) BOOL hasWriteOpen; //是否已经写入OPEN日志
@property (nonatomic, assign) NSInteger hotelId_GetIp; //getIp获取的酒楼ID
@property (nonatomic, assign) NSInteger hotelId_Platform; //小平台获取的酒楼ID
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
        self.hasUploadLog = NO;
        self.hasWriteOpen = NO;
        self.hotelId_GetIp = 0;
        self.hotelId_Platform = 0;
        self.hotelId_Box = 0;
        self.locationSource = [NSMutableArray new];
        self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
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
        self.isSearchPlatform = YES;
    }
    return self;
}

//配置DLNA设备搜索的socket相关端口信息
- (void)setUpSocketForDLNA
{
    NSError *error = nil;
    if (![self.socket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
    }
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

//开始搜索DLNA设备
- (void)startSearchDevice
{
    if ([GlobalData shared].scene == RDSceneHaveRDBox) {
        return;
    }
    self.isSearch = YES;
    if (!self.socket.isClosed) {
        [self socketShouldBeClose]; //先关闭当前的socket连接
    }
    [self setUpSocketForDLNA]; //配置DLNA搜索的socket地址和端口
    self.isSearchPlatform = NO;
    [self.locationSource removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(GCCDLNADidStartSearchDevice:)]) {
        [self.delegate GCCDLNADidStartSearchDevice:self];
    }
    
    //发送搜索信息
    [self performSelector:@selector(stopSearchDevice) withObject:nil afterDelay:6.f];
}

- (void)startSearchPlatform
{
    if ([GlobalData shared].isBindRD) {
        if ([HTTPServerManager checkHttpServerWithBoxIP:[GlobalData shared].RDBoxDevice.BoxIP]) {
            return;
        }
    }
    
    if (self.isSearch) {
        [self resetSearch];
    }
    
    self.isSearch = YES;
    
    if (!self.socket.isClosed) {
        [self socketShouldBeClose]; //先关闭当前的socket连接
    }
    [GlobalData shared].scene = RDSceneNothing;
    self.isSearchPlatform = YES;
    
    [GlobalData shared].callQRCodeURL = @"";
    [GlobalData shared].boxCodeURL = @"";
    [GlobalData shared].secondCallCodeURL = @"";
    [GlobalData shared].thirdCallCodeURL = @"";
    
    [self setUpSocketForPlatform]; //若当前socket处于关闭状态，先配置socket地址和端口
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSearchDevice) object:nil];
    [self performSelector:@selector(stopSearchDevice) withObject:nil afterDelay:10.f];
}

//停止设备搜索
- (void)stopSearchDevice
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSearchDevice) object:nil];
    
    if (!self.socket.isClosed) {
        [self socketShouldBeClose]; //调用socket关闭
    }
    
    self.isSearch = NO;
}

- (void)resetSearch
{
    [HSGetIpRequest cancelRequest];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSearchDevice) object:nil];
}

- (void)socketShouldBeClose
{
    [self.socket close];
    [self.locationSource removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(GCCDLNADidEndSearchDevice:)]) {
        [self.delegate GCCDLNADidEndSearchDevice:self];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    
}

//获取到设备反馈信息
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext{
    
    if (self.isSearchPlatform) {
        [self getPlatformHeadURLWith:data];
    }
}

//解析从小平台获取的SSDP的discover信息，得到小平台呼出二维码地址
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
        }
    }
    
    return nil;
}

@end
