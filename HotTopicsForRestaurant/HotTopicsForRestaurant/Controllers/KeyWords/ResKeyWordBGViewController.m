//
//  ResKeyWordBGViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResKeyWordBGViewController.h"
#import "ResKeyWordBGCell.h"
#import "SelectRoomViewController.h"
#import "GCCKeyChain.h"
#import "GCCGetInfo.h"
#import <AFNetworking/AFNetworking.h>
#import "SAVORXAPI.h"
#import "GCCDLNA.h"

@interface ResKeyWordBGViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * imageData;
@property (nonatomic, copy) NSString * keyWord;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) NSInteger resultCount;

@end

@implementation ResKeyWordBGViewController

- (instancetype)initWithkeyWord:(NSString *)keyWord
{
    if (self = [super init]) {
        self.keyWord = keyWord;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"请选择背景";
    [self createDataSource];
    [self createSubViews];
}

- (void)createDataSource
{
    self.imageData = [NSArray arrayWithObjects:
                      @"1",
                      @"2",
                      @"3",
                      @"4",
                      @"6",
                      @"7",
                      @"8",nil];
}

- (void)createSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = VCBackgroundColor;
    [self.tableView registerClass:[ResKeyWordBGCell class] forCellReuseIdentifier:@"ResKeyWordBGCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 194 * scale;
    self.tableView.sectionFooterHeight = 1;
    self.tableView.sectionHeaderHeight = 10 * scale;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.bottom.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 10 * scale)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.imageData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResKeyWordBGCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ResKeyWordBGCell" forIndexPath:indexPath];
    
    NSString * imageName =  [NSString stringWithFormat:@"keyWord0%@.jpg", [self.imageData objectAtIndex:indexPath.section]];
    [cell configWithImageName:imageName title:self.keyWord];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([GlobalData shared].boxSource.count == 0) {
        [MBProgressHUD showTextHUDwithTitle:@"未获取到包间信息"];
        [[GCCDLNA defaultManager] getBoxInfoList];
        return;
    }
    
    SelectRoomViewController * select = [[SelectRoomViewController alloc] init];
    select.dataSource = [GlobalData shared].boxSource;
    select.backDatas = ^(RDBoxModel *tmpModel) {
        
        self.resultCount = 0;
        self.requestCount = 0;
        [MBProgressHUD showLoadingWithText:@"正在投屏" inView:self.view];
        if (!isEmptyString([GlobalData shared].callQRCodeURL)) {
            self.requestCount++;
            [self keyWordShouldUploadWithBaseURL:[GlobalData shared].callQRCodeURL Index:indexPath.section model:tmpModel];
        }
        if (!isEmptyString([GlobalData shared].secondCallCodeURL)) {
            self.requestCount++;
            [self keyWordShouldUploadWithBaseURL:[GlobalData shared].secondCallCodeURL Index:indexPath.section model:tmpModel];
        }
        if (!isEmptyString([GlobalData shared].thirdCallCodeURL)) {
            self.requestCount++;
            [self keyWordShouldUploadWithBaseURL:[GlobalData shared].thirdCallCodeURL Index:indexPath.section model:tmpModel];
        }
        
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:select animated:YES completion:^{
            
        }];
    });
}

- (void)keyWordShouldUploadWithBaseURL:(NSString *)baseURL Index:(NSInteger)index model:(RDBoxModel *)model
{
    NSString *platformUrl = [NSString stringWithFormat:@"%@/command/screend/word", baseURL];
    NSDictionary * parameters = @{@"boxMac" : model.BoxID,
                                  @"deviceId":[GCCKeyChain load:keychainID],
                                  @"deviceName":[GCCGetInfo getIphoneName],
                                  @"templateId":[self.imageData objectAtIndex:index],
                                  @"word":self.keyWord
                                  };
    
    [[AFHTTPSessionManager manager] GET:platformUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 10000) {
            [MBProgressHUD showTextHUDwithTitle:@"欢迎词投屏成功"];
            [self upLogsRequest:@"1"  withModel:model Index:index];
        }else{
            NSString * msg = [responseObject objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDwithTitle:msg];
            }else{
                [MBProgressHUD showTextHUDwithTitle:@"欢迎词投屏失败"];
            }
            [self upLogsRequest:@"0"  withModel:model Index:index];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.resultCount ++;
        if (self.resultCount == self.requestCount) {
            if ([GlobalData shared].networkStatus == RDNetworkStatusNotReachable) {
                [MBProgressHUD showTextHUDwithTitle:@"网络已断开，请检查网络"];
            }else {
                [MBProgressHUD showTextHUDwithTitle:@"网络连接超时，请重试"];
            }
            [self upLogsRequest:@"0"  withModel:model Index:index];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)upLogsRequest:(NSString *)reState withModel:(RDBoxModel *)tmpModel Index:(NSInteger)index{

    NSDictionary *parmDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",tmpModel.roomID],@"room_id",reState,@"screen_result",@"120",@"screen_time",@"5",@"screen_type",self.keyWord,@"welcome_word",[NSString stringWithFormat:@"%ld", index],@"welcome_template",@"1",@"screen_num", nil];
    [SAVORXAPI upLoadLogRequest:parmDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
