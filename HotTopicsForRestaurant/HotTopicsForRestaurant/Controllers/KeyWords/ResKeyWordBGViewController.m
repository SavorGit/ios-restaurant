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

@interface ResKeyWordBGViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * imageData;
@property (nonatomic, copy) NSString * keyWord;

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
                      @"keyWord01.jpg",
                      @"keyWord02.jpg",
                      @"keyWord03.jpg",
                      @"keyWord04.jpg",
                      @"keyWord05.jpg",
                      @"keyWord06.jpg",
                      @"keyWord07.jpg",
                      @"keyWord08.jpg",nil];
}

- (void)createSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
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
    
    NSString * imageName =  [self.imageData objectAtIndex:indexPath.section];
    [cell configWithImageName:imageName title:self.keyWord];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectRoomViewController * select = [[SelectRoomViewController alloc] init];
    select.dataSource = [GlobalData shared].boxSource;
    select.backDatas = ^(RDBoxModel *tmpModel) {
        
        if (!isEmptyString([GlobalData shared].callQRCodeURL)) {
            [self keyWordShouldUploadWithBaseURL:[GlobalData shared].callQRCodeURL Index:indexPath.row + 1 model:tmpModel];
        }
        if (!isEmptyString([GlobalData shared].secondCallCodeURL)) {
            [self keyWordShouldUploadWithBaseURL:[GlobalData shared].secondCallCodeURL Index:indexPath.row + 1 model:tmpModel];
        }
        if (!isEmptyString([GlobalData shared].thirdCallCodeURL)) {
            [self keyWordShouldUploadWithBaseURL:[GlobalData shared].thirdCallCodeURL Index:indexPath.row + 1 model:tmpModel];
        }
        
    };
    [self presentViewController:select animated:YES completion:^{
        
    }];
}

- (void)keyWordShouldUploadWithBaseURL:(NSString *)baseURL Index:(NSInteger)index model:(RDBoxModel *)model
{
    NSString *platformUrl = [NSString stringWithFormat:@"%@/screend/word", baseURL];
    NSDictionary * parameters = @{@"boxMac" : model.BoxID,
                                  @"deviceId":[GCCKeyChain load:keychainID],
                                  @"deviceName":[GCCGetInfo getIphoneName],
                                  @"templateId":[NSString stringWithFormat:@"%ld", index],
                                  @"word":self.keyWord
                                  };
    
    [[AFHTTPSessionManager manager] GET:platformUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 10000) {
            [MBProgressHUD showTextHUDwithTitle:@"欢迎词投屏成功"];
        }else{
            NSString * msg = [responseObject objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDwithTitle:msg];
            }else{
                [MBProgressHUD showTextHUDwithTitle:@"欢迎词投屏失败"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
