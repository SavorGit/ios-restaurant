//
//  GlobalData.m
//  SavorX
//
//  Created by 郭春城 on 16/7/19.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "GlobalData.h"
#import "SAVORXAPI.h"

NSString * const RDDidBindDeviceNotification = @"RDDidBindDeviceNotification";
NSString * const RDDidDisconnectDeviceNotification = @"RDDidDisconnectDeviceNotification";
NSString * const RDDidFoundHotelIdNotification = @"RDDidFoundHotelIdNotification";
NSString * const RDDidNotFoundSenceNotification = @"RDDidNotFoundSenceNotification";
NSString * const RDDidFoundBoxSenceNotification = @"RDDidFoundBoxSenceNotification";
NSString * const RDDidFoundDLNASenceNotification = @"RDDidFoundDLNASenceNotification";

NSString * const RDStopSearchDeviceNotification = @"RDStopSearchDeviceNotification";
NSString * const RDQiutScreenNotification = @"RDQiutScreenNotification";
NSString * const RDBoxQuitScreenNotification = @"RDBoxQuitScreenNotification";
NSString * const RDNetWorkStatusDidBecomeReachableViaWiFi = @"RDNetWorkStatusDidBecomeReachableViaWiFi";
NSString * const RDUserLoginStatusChangeNotification = @"RDUserLoginStatusChangeNotification";

#define hasAlertDemandHelp @"hasAlertDemandHelp"

static GlobalData* single = nil;

@implementation GlobalData

+ (GlobalData *)shared
{
    @synchronized(self)
    {
        if (!single) {
            single = [[self alloc] init];
        }
    }
    return single;
}

- (id)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.serverDic = [[NSMutableDictionary alloc] init];
    self.RDBoxDevice = [[RDBoxModel alloc] init];
    self.boxUrlStr = @"";
    self.scene = RDSceneNothing;
    self.hotelId = 0;
    self.projectId = @"projectId";
    self.deviceToken = @"";
    self.latitude = 0.f;
    self.longitude = 0.f;
    self.boxSource = [NSArray new];
    
    [self getAreaId];
}

- (void)getAreaId
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:RDAreaID]) {
        NSString * areaId = [userDefaults objectForKey:RDAreaID];
        if (!isEmptyString(areaId)) {
            _areaId = areaId;
        }
    }
}

- (void)bindToRDBoxDevice:(RDBoxModel *)model
{
    if ([self.RDBoxDevice.sid isEqualToString:model.sid]) {
        return;
    }
    
    self.isBindRD = YES;
    self.RDBoxDevice = model;
    self.hotelId = model.hotelID;
    if (self.scene != RDSceneHaveRDBox) {
        self.scene = RDSceneHaveRDBox;
    }
//    [SAVORXAPI upLoadLogs:@"1"];
    [[NSNotificationCenter defaultCenter] postNotificationName:RDDidBindDeviceNotification object:nil];
    
//    NSString * message = [NSString stringWithFormat:@"\"%@\"连接成功, 可以投屏", [Helper getWifiName]];
//    [Helper showTextHUDwithTitle:message delay:1.5f];
}

- (void)disconnectWithRDBoxDevice
{
    self.isBindRD = NO;
    self.RDBoxDevice = [[RDBoxModel alloc] init];
}

- (void)disconnect
{
    [self disconnectWithRDBoxDevice];
    [[NSNotificationCenter defaultCenter] postNotificationName:RDDidDisconnectDeviceNotification object:nil];
}

- (void)setHotelId:(NSInteger)hotelId
{
    if (_hotelId != hotelId) {
        _hotelId = hotelId;
        if (hotelId != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RDDidFoundHotelIdNotification object:nil];
        }
    }
}

- (void)setIsBindRD:(BOOL)isBindRD
{
    if (_isBindRD != isBindRD) {
        _isBindRD = isBindRD;
    }
}

- (void)setScene:(RDScene)scene
{
    if (_scene != scene) {
        _scene = scene;
        if (scene == RDSceneNothing) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RDDidNotFoundSenceNotification object:nil];
            [self disconnect];
            self.hotelId = 0;
            self.callQRCodeURL = @"";
        }else{
            if (scene == RDSceneHaveRDBox) {
                [[NSNotificationCenter defaultCenter] postNotificationName:RDDidFoundBoxSenceNotification object:nil];
            }
        }
    }
}

- (void)setNetworkStatus:(NSInteger)networkStatus
{
    if (_networkStatus != networkStatus) {
        _networkStatus = networkStatus;
        if (_networkStatus != RDNetworkStatusReachableViaWiFi) {
            self.scene = RDSceneNothing;
            [MBProgressHUD removeTextHUD];
        }
    }
}

- (void)setCacheModel:(RDBoxModel *)cacheModel
{
    if (_cacheModel != cacheModel) {
        _cacheModel = cacheModel;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearCacheModel) object:nil];
        [self performSelector:@selector(clearCacheModel) withObject:nil afterDelay:3 * 60.f];
    }
}

- (void)clearCacheModel
{
    self.cacheModel = [[RDBoxModel alloc] init];
}

- (void)setAreaId:(NSString *)areaId
{
    if (![_areaId isEqualToString:areaId]) {
        _areaId = areaId;
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:areaId forKey:RDAreaID];
        [userDefaults synchronize];
    }
}

- (void)loginWith:(ResUserModel *)model
{
    self.userModel = model;
}

@end
