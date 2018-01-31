//
//  RestaurantServiceController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RestaurantServiceController.h"
#import "RestaurantServiceStatusView.h"

@interface RestaurantServiceController ()

@property (nonatomic, strong) RestaurantServiceStatusView * statusView;

@end

@implementation RestaurantServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
}

- (void)createSubViews
{
    self.navigationItem.title = @"餐厅服务";
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.statusView = [[RestaurantServiceStatusView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
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
