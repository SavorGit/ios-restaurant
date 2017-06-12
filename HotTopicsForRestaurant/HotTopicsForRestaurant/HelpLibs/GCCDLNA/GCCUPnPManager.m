//
//  GCCUPnPManager.m
//  DLNATest
//
//  Created by 郭春城 on 16/10/11.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "GCCUPnPManager.h"
#import "GDataXMLNode.h"

static NSString *serviceAVTransport = @"urn:schemas-upnp-org:service:AVTransport:1";
static NSString *serviceRendering = @"urn:schemas-upnp-org:service:RenderingControl:1";

@interface GCCUPnPManager ()

@property (nonatomic, strong) DeviceModel * device;

@end

@implementation GCCUPnPManager

+ (GCCUPnPManager *)defaultManager
{
    static dispatch_once_t once;
    static GCCUPnPManager *manager;
    dispatch_once(&once, ^ {
        manager = [[GCCUPnPManager alloc] init];
    });
    return manager;
}

- (instancetype)initWithDeviceModel:(DeviceModel *)device
{
    if (self = [super init]) {
        self.device = device;
    }
    return self;
}

- (void)setDeviceModel:(DeviceModel *)device
{
    self.device = device;
}

- (NSData *)getXmlWithBody:(GDataXMLElement *)body
{
    GDataXMLElement * base = [GDataXMLElement elementWithName:@"s:Envelope"];
    [base addAttribute:[GDataXMLNode attributeWithName:@"xmlns:s" stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"]];
    [base addAttribute:[GDataXMLNode attributeWithName:@"s:encodingStyle" stringValue:@"http://schemas.xmlsoap.org/soap/encoding/"]];
    GDataXMLElement * bodyElemen = [GDataXMLElement elementWithName:@"s:Body"];
    [bodyElemen addChild:body];
    [base addChild:bodyElemen];
    NSString * baseStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>%@%@", [base XMLString], @"\r\n"];
    NSData * data = [baseStr dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

- (void)postDataWithType:(NSString *)type body:(GDataXMLElement *)body success:(void (^)(NSData *))successBlock failure:(void (^)())failureBlock
{
    NSString * baseUrl = [NSString stringWithFormat:@"%@%@", self.device.headerURL, self.device.AVTransport.controlURL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseUrl]];
    request.HTTPMethod = @"POST";
    [request addValue:@"text/xml;charset=\"utf-8\"" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"\"%@#%@\"", serviceAVTransport, type] forHTTPHeaderField:@"SOAPAction"];
    request.HTTPBody = [self getXmlWithBody:body];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response != nil) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ([httpResponse statusCode] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(data);
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock();
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock();
            });
        }
        if (data) {
            [self parseRequestResponseData:data];
        }
    }];
    [dataTask resume];
}

- (void)postRenderingDataWithType:(NSString *)type body:(GDataXMLElement *)body success:(void (^)(NSData *))successBlock failure:(void (^)())failureBlock
{
    NSString * baseUrl = [NSString stringWithFormat:@"%@%@", self.device.headerURL, self.device.Rendering.controlURL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseUrl]];
    request.HTTPMethod = @"POST";
    [request addValue:@"text/xml;charset=\"utf-8\"" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"\"%@#%@\"", serviceRendering, type] forHTTPHeaderField:@"SOAPAction"];
    request.HTTPBody = [self getXmlWithBody:body];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response != nil) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ([httpResponse statusCode] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(data);
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock();
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock();
            });
        }
        if (data) {
            [self parseRequestResponseData:data];
        }
    }];
    [dataTask resume];
}

- (void)setAVTransportURL:(NSString *)url Success:(void (^)())successBlock failure:(void (^)())failureBlock
{
    GDataXMLElement *body = [GDataXMLElement elementWithName:@"u:SetAVTransportURI"];
    [body addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [body addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [body addChild:[GDataXMLElement elementWithName:@"CurrentURI" stringValue:url]];
    [body addChild:[GDataXMLElement elementWithName:@"CurrentURIMetaData"]];
    __weak typeof(self) weak = self;
    [self postDataWithType:@"SetAVTransportURI" body:body success:^(NSData * data){
        [weak playSuccess:^{
            successBlock();
        } failure:^{
            failureBlock();
        }];
    } failure:^{
        failureBlock();
    }];
}

- (void)playSuccess:(void (^)())successBlock failure:(void (^)())failureBlock
{
    GDataXMLElement *body = [GDataXMLElement elementWithName:@"u:Play"];
    
    [body addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [body addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [body addChild:[GDataXMLElement elementWithName:@"Speed" stringValue:@"1"]];
    [self postDataWithType:@"Play" body:body success:^(NSData * data){
        successBlock();
    } failure:^{
        failureBlock();
    }];
}

- (void)pauseSuccess:(void (^)())successBlock failure:(void (^)())failureBlock
{
    GDataXMLElement *body = [GDataXMLElement elementWithName:@"u:Pause"];
    
    [body addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [body addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [self postDataWithType:@"Pause" body:body success:^(NSData * data){
        successBlock();
    } failure:^{
        failureBlock();
    }];
}

- (void)stopSuccess:(void (^)())successBlock failure:(void (^)())failureBlock
{
    GDataXMLElement *body = [GDataXMLElement elementWithName:@"u:Stop"];
    
    [body addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [body addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [self postDataWithType:@"Stop" body:body success:^(NSData * data){
        successBlock();
    } failure:^{
        failureBlock();
    }];
}

- (void)getVolumeSuccess:(void (^)(NSInteger))successBlock failure:(void (^)())failureBlock
{
    GDataXMLElement *body = [GDataXMLElement elementWithName:@"u:GetVolume"];
    
    [body addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:serviceRendering]];
    [body addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [body addChild:[GDataXMLElement elementWithName:@"Channel" stringValue:@"Master"]];
    [self postRenderingDataWithType:@"GetVolume" body:body success:^(NSData * data){
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        GDataXMLElement *bodyElement = [[[document rootElement] elementsForLocalName:@"Body" URI:[[document rootElement] URI]] objectAtIndex:0];
        GDataXMLElement *getVolumeResponseElement = [[bodyElement elementsForLocalName:@"GetVolumeResponse" URI:serviceRendering] objectAtIndex:0];
        NSInteger currentVolume = [[[[getVolumeResponseElement elementsForName:@"CurrentVolume"] objectAtIndex:0] stringValue] integerValue];
        successBlock(currentVolume);
    } failure:^{
        failureBlock();
    }];
}

- (void)setVolume:(NSInteger)volume Success:(void (^)())successBlock failure:(void (^)())failureBlock
{
    GDataXMLElement *body = [GDataXMLElement elementWithName:@"u:SetVolume"];
    
    [body addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:serviceRendering]];
    [body addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [body addChild:[GDataXMLElement elementWithName:@"Channel" stringValue:@"Master"]];
    [body addChild:[GDataXMLElement elementWithName:@"DesiredVolume" stringValue:[[NSNumber numberWithInteger:volume] stringValue]]];
    [self postRenderingDataWithType:@"SetVolume" body:body success:^(NSData * data){
        successBlock();
    } failure:^{
        failureBlock();
    }];
}

- (void)getPlayProgressSuccess:(void (^)(NSString *, NSString *, float))successBlock failure:(void (^)())failureBlock
{
    GDataXMLElement *body = [GDataXMLElement elementWithName:@"u:GetPositionInfo"];
    
    [body addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [body addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [self postDataWithType:@"GetPositionInfo" body:body success:^(NSData * data){
        
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        GDataXMLElement * body = [[[document rootElement] elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *getPositionInfoResponseElement = [[body elementsForName:@"u:GetPositionInfoResponse"] firstObject];
        
        NSString *totalDuration = [[[getPositionInfoResponseElement elementsForName:@"TrackDuration"] firstObject] stringValue];
        NSString *currentDuration = [[[getPositionInfoResponseElement elementsForName:@"RelTime"] firstObject] stringValue];
        
        NSInteger total = [self timeIntegerFromString:totalDuration];
        NSInteger current = [self timeIntegerFromString:currentDuration];
        
        float progress = total > current ? current/(float)total : 0.0;
        
        successBlock(totalDuration, currentDuration, progress);
    } failure:^{
        failureBlock();
    }];
}

- (void)seekProgressTo:(NSInteger)progress success:(void (^)())successBlock failure:(void (^)())failureBlock
{
    if (progress == 0) {
        progress = 1;
    }
    GDataXMLElement *body = [GDataXMLElement elementWithName:@"u:Seek"];
    
    [body addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [body addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [body addChild:[GDataXMLElement elementWithName:@"Unit" stringValue:@"REL_TIME"]];
    [body addChild:[GDataXMLElement elementWithName:@"Target" stringValue:[self timeStringFromInteger:progress]]];
    [self postDataWithType:@"Seek" body:body success:^(NSData * data){
        successBlock();
    } failure:^{
        failureBlock();
    }];
}

#pragma mark -- 动作响应解析
- (void)parseRequestResponseData:(NSData *)data{
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *bigArray = [xmlEle children];
    for (int i = 0; i < [bigArray count]; i++) {
        GDataXMLElement *element = [bigArray objectAtIndex:i];
        NSArray *needArr = [element children];
        if ([[element name] hasSuffix:@"Body"]) {
            [self resultsWith:needArr];
        }else{
            NSLog(@"*gcc*未定义响应/Body错误");
        }
    }
}

- (void)resultsWith:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        GDataXMLElement *ele = [array objectAtIndex:i];
        if ([[ele name] hasSuffix:@"SetAVTransportURIResponse"]) {
            NSLog(@"*gcc*设置URI成功");
        }else if ([[ele name] hasSuffix:@"GetPositionInfoResponse"]){
            NSLog(@"*gcc*已获取进度, 协议回调可再进行解析使用");
        }else if ([[ele name] hasSuffix:@"GetTransportInfoResponse"]){
            NSLog(@"*gcc*已获取状态, 协议回调可再进行解析使用");
        }else if ([[ele name] hasSuffix:@"PauseResponse"]){
            NSLog(@"*gcc*暂停");
        }else if ([[ele name] hasSuffix:@"PlayResponse"]){
            NSLog(@"*gcc*播放");
        }else if ([[ele name] hasSuffix:@"StopResponse"]){
            NSLog(@"*gcc*停止");
        }else if ([[ele name] hasSuffix:@"SeekResponse"]){
            NSLog(@"*gcc*跳转成功");
        }else if ([[ele name] hasSuffix:@"SetVolumeResponse"]){
            NSLog(@"*gcc*声音设置成功");
        }else if ([[ele name] hasSuffix:@"GetVolumeResponse"]){
            NSLog(@"*gcc*已获取音量信息, 协议回调可再进行解析使用");
        }else{
            NSLog(@"*gcc*未定义响应/UPnP错误");
        }
    }
}

- (NSString *)timeStringFromInteger:(NSInteger)seconds
{
    NSInteger hours, remainder, minutesm, secs;
    
    hours = seconds / 3600;
    
    remainder = seconds % 3600;
    
    minutesm = remainder / 60;
    
    secs = remainder % 60;
    
    return [NSString stringWithFormat:@"%@:%@:%@",
            (hours < 10 ? [NSString stringWithFormat:@"0%@", [[NSNumber numberWithInteger:hours] stringValue]] : [[NSNumber numberWithInteger:hours] stringValue]),
            (minutesm < 10 ? [NSString stringWithFormat:@"0%@", [[NSNumber numberWithInteger:minutesm] stringValue]] : [[NSNumber numberWithInteger:minutesm] stringValue]),
            (secs < 10 ? [NSString stringWithFormat:@"0%@", [[NSNumber numberWithInteger:secs] stringValue]] : [[NSNumber numberWithInteger:secs] stringValue])];
}

- (NSInteger)timeIntegerFromString:(NSString *)string
{
    NSArray<NSString *> *split = [string componentsSeparatedByString:@":"];
    
    return ([[split objectAtIndex:0] integerValue] * 3600) + ([[split objectAtIndex:1] integerValue] * 60) + ([[split objectAtIndex:2] integerValue]);
}

@end
