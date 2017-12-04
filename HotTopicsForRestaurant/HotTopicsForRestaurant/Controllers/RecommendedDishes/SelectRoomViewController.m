//
//  SelectRoomViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SelectRoomViewController.h"
#import "SAVORXAPI.h"

@interface SelectRoomViewController ()

@end

@implementation SelectRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
//    [self creatSubViews];
    
    // Do any additional setup after loading the view.
}

- (void)initInfor{
    
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    UIButton*leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [leftButton setImage:[UIImage imageNamed:@"yixuanzhong.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem= leftItem;
}

//- (void) creatSubViews{
//
//    CGFloat scale = kMainBoundsWidth / 375.f;
//
//    for (int i = 0 ; i < 15; i ++) {
//
//        UIButton *toScreenBtn = [SAVORXAPI buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(15) backgroundColor:[UIColor clearColor] title:@"包间名" cornerRadius:5.f];
//        toScreenBtn.backgroundColor = UIColorFromRGB(0xff783d);
//        [toScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.view addSubview:toScreenBtn];
//        CGFloat distance = 15 *scale;
//
//        int row = i/3;
//        int lie = i % 3;
//        CGFloat rowDistance = (row + 1) * 20 *scale  + row *36 *scale;
//        NSLog(@"---%d---%f",row,rowDistance);
//        [toScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(105 *scale, 36 *scale));
//            make.left.mas_equalTo((lie + 1) *distance  + lie *105 *scale);
//            make.top.mas_equalTo(10 + rowDistance);
//        }];
//        toScreenBtn.layer.borderColor = UIColorFromRGB(0xff783d).CGColor;
//        toScreenBtn.layer.borderWidth = 1.f;
//        [toScreenBtn addTarget:self action:@selector(toScreenBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//}
//
//- (void)toScreenBtnDidClicked:(UIButton *)Btn{
//
//}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
