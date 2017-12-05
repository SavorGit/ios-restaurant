//
//  ResKeyWordBGViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResKeyWordBGViewController.h"
#import "ResKeyWordBGCell.h"

@interface ResKeyWordBGViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * imageData;

@end

@implementation ResKeyWordBGViewController

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
    [cell configWithImageName:imageName title:@"一二三四五六七八九十一二三四"];
    
    return cell;
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
