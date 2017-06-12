//
//  HTTPServerManager.m
//  SavorX
//
//  Created by 郭春城 on 16/8/10.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "HTTPServerManager.h"
#import "HSWebServerManager.h"

#include <netdb.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <net/if.h>

@implementation HTTPServerManager

+ (NSString *)getCurrentHTTPServerIP
{
    return [HSWebServerManager manager].webServer.serverURL.absoluteString;
}

+ (BOOL)checkHttpServerIsWifi
{
    if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkHttpServerWithBoxIP:(NSString *)boxIP
{
    NSMutableArray * temp = [NSMutableArray arrayWithArray:[boxIP componentsSeparatedByString:@"."]];
    [temp removeLastObject];
    NSMutableString * preCheck = [[NSMutableString alloc] init];
    for (int i = 0; i < temp.count; i++) {
        if (i == 0) {
            [preCheck appendString:temp[i]];
        }else{
            [preCheck appendFormat:@".%@", temp[i]];
        }
    }
    
    NSString * str = [HSWebServerManager manager].webServer.serverURL.absoluteString;
    str = [[str componentsSeparatedByString:@"//"] objectAtIndex:1];
    NSMutableArray * array = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"."]];
    [array removeLastObject];
    NSMutableString * httpIP = [[NSMutableString alloc] init];
    for (int i = 0; i < array.count; i++) {
        if (i == 0) {
            [httpIP appendString:array[i]];
        }else{
            [httpIP appendFormat:@".%@", array[i]];
        }
    }
    
    return [httpIP isEqualToString:preCheck];
}

+ (BOOL)checkHttpServerWithDLNAIP:(NSString *)DLNAIP
{
    DLNAIP = [DLNAIP substringFromIndex:7];
    NSString * host = [[DLNAIP componentsSeparatedByString:@":"] firstObject];
    NSMutableArray * temp = [NSMutableArray arrayWithArray:[host componentsSeparatedByString:@"."]];
    [temp removeLastObject];
    NSMutableString * preCheck = [[NSMutableString alloc] init];
    for (int i = 0; i < temp.count; i++) {
        if (i == 0) {
            [preCheck appendString:temp[i]];
        }else{
            [preCheck appendFormat:@".%@", temp[i]];
        }
    }
    
    NSString * str = [HSWebServerManager manager].webServer.serverURL.absoluteString;
    str = [[str componentsSeparatedByString:@"//"] objectAtIndex:1];
    NSMutableArray * array = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"."]];
    [array removeLastObject];
    NSMutableString * httpIP = [[NSMutableString alloc] init];
    for (int i = 0; i < array.count; i++) {
        if (i == 0) {
            [httpIP appendString:array[i]];
        }else{
            [httpIP appendFormat:@".%@", array[i]];
        }
    }
    
    return [httpIP isEqualToString:preCheck];
}

+ (BOOL)isIpv4{
    struct addrinfo hints, *res, *p;
    NSString * host = [HTTPServerManager deviceIPAdress];
    int status;
    
    BOOL isIpv4 = NO;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC; // AF_INET or AF_INET6 to force version
    hints.ai_socktype = SOCK_STREAM;
    
    if ((status = getaddrinfo([host UTF8String], "http", &hints, &res)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(status));
        return nil;
    }
    p = res;
    void *addr;
    char *ipver;
        
        // get the pointer to the address itself,
        // different fields in IPv4 and IPv6:
    if (p->ai_family == AF_INET) { // IPv4
        struct sockaddr_in *ipv4 = (struct sockaddr_in *)p->ai_addr;
        addr = &(ipv4->sin_addr);
        ipver = "IPv4";
        isIpv4 = YES;
    } else { // IPv6
        struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)p->ai_addr;
        addr = &(ipv6->sin6_addr);
        ipver = "IPv6";
        isIpv4 = NO;
    }
    
    return isIpv4;
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

@end
