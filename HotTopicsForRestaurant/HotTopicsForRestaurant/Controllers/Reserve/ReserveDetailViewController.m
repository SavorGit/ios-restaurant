//
//  ReserveDetailViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReserveDetailViewController.h"

@interface ReserveDetailViewController ()

@property(nonatomic, strong) NSString *dealIdStr;

@property(nonatomic, strong) UILabel *roomTitleLab;
@property(nonatomic, strong) UILabel *reserTimeLab;
@property(nonatomic, strong) UILabel *peopleNumLab;
@property(nonatomic, strong) UILabel *remarkLab;
@property(nonatomic, strong) UILabel *remarkConetentLab;
//
@property(nonatomic, strong) UIImageView *heardImgView;
@property(nonatomic, strong) UILabel *nameLab;
@property(nonatomic, strong) UILabel *phoneLab;


@end

@implementation ReserveDetailViewController

- (instancetype)initWithDealId:(NSString *)dealId
{
    if (self = [super init]) {
        self.dealIdStr = dealId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self creatSubViews];

}

- (void)initInfor{
    
    self.title = @"预定信息";
    
}
- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth/375.f;
    
    UIView *topBgView = [[UIView alloc] init];
    topBgView.backgroundColor = UIColorFromRGB(0xeee8e0);
    [self.view addSubview:topBgView];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 20) , 370));
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
    }];
    
    self.roomTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.roomTitleLab.backgroundColor = [UIColor clearColor];
    self.roomTitleLab.font = [UIFont systemFontOfSize:15];
    self.roomTitleLab.textColor = [UIColor grayColor];
    self.roomTitleLab.text = @"雁鸣厅";
    self.roomTitleLab.textAlignment = NSTextAlignmentCenter;
    [topBgView addSubview:self.roomTitleLab];
    [self.roomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30), 25 *scale));
        make.centerX.mas_equalTo(topBgView);
        make.top.mas_equalTo(15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [topBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 20), 1));
        make.centerX.mas_equalTo(topBgView);
        make.top.mas_equalTo(self.roomTitleLab.mas_bottom).offset(14);
    }];
    
    self.reserTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.reserTimeLab.backgroundColor = [UIColor clearColor];
    self.reserTimeLab.font = [UIFont systemFontOfSize:15];
    self.reserTimeLab.textColor = [UIColor grayColor];
    self.reserTimeLab.text = @"预定时间:";
    self.reserTimeLab.textAlignment = NSTextAlignmentLeft;
    [topBgView addSubview:self.reserTimeLab];
    [self.reserTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30), 25 *scale));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(lineView.mas_bottom).offset(15);
    }];
    
    self.peopleNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.peopleNumLab.backgroundColor = [UIColor clearColor];
    self.peopleNumLab.font = [UIFont systemFontOfSize:15];
    self.peopleNumLab.textColor = [UIColor grayColor];
    self.peopleNumLab.text = @"就餐人数:";
    self.peopleNumLab.textAlignment = NSTextAlignmentLeft;
    [topBgView addSubview:self.peopleNumLab];
    [self.peopleNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30), 25 *scale));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.reserTimeLab.mas_bottom).offset(10);
    }];
    
    self.remarkLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.remarkLab.backgroundColor = [UIColor clearColor];
    self.remarkLab.font = [UIFont systemFontOfSize:15];
    self.remarkLab.textColor = [UIColor grayColor];
    self.remarkLab.text = @"备注:";
    self.remarkLab.textAlignment = NSTextAlignmentLeft;
    [topBgView addSubview:self.remarkLab];
    [self.remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 25 *scale));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.peopleNumLab.mas_bottom).offset(10);
    }];
    
    self.remarkConetentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.remarkConetentLab.backgroundColor = [UIColor clearColor];
    self.remarkConetentLab.font = [UIFont systemFontOfSize:15];
    self.remarkConetentLab.textColor = [UIColor grayColor];
    self.remarkConetentLab.text = @"这是备注内容";
    self.remarkConetentLab.textAlignment = NSTextAlignmentLeft;
    [topBgView addSubview:self.remarkConetentLab];
    [self.remarkConetentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30 - 40, 25 *scale));
        make.left.mas_equalTo(self.remarkLab.mas_right);
        make.top.mas_equalTo(self.peopleNumLab.mas_bottom).offset(10);
    }];
    
    UIView *cuBgView = [[UIView alloc] init];
    cuBgView.backgroundColor = [UIColor whiteColor];
    cuBgView.layer.borderWidth = .5f;
    cuBgView.layer.cornerRadius = 4.f;
    cuBgView.layer.masksToBounds = YES;
    cuBgView.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [topBgView addSubview:cuBgView];
    [cuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30 - 20) , 80 *scale));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.remarkLab.mas_bottom).offset(20);
    }];
    
    self.heardImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.heardImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.heardImgView.layer.masksToBounds = YES;
    self.heardImgView.backgroundColor = [UIColor cyanColor];
    [cuBgView addSubview:self.heardImgView];
    [self.heardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60 *scale);
        make.height.mas_equalTo(60 *scale);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
    }];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLab.backgroundColor = [UIColor clearColor];
    self.nameLab.font = [UIFont systemFontOfSize:15];
    self.nameLab.textColor = [UIColor grayColor];
    self.nameLab.text = @"王先生";
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    [cuBgView addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 25));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.heardImgView.mas_top).offset(5);
    }];
    
    self.phoneLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.phoneLab.backgroundColor = [UIColor clearColor];
    self.phoneLab.font = [UIFont systemFontOfSize:15];
    self.phoneLab.textColor = [UIColor grayColor];
    self.phoneLab.text = @"18510378890";
    self.phoneLab.textAlignment = NSTextAlignmentLeft;
    [cuBgView addSubview:self.phoneLab];
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(5);
    }];
    
    UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    rightImgView.contentMode = UIViewContentModeScaleAspectFill;
    rightImgView.layer.masksToBounds = YES;
    rightImgView.backgroundColor = [UIColor cyanColor];
    [cuBgView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20 *scale);
        make.height.mas_equalTo(20 *scale);
        make.centerY.mas_equalTo(cuBgView);
        make.right.mas_equalTo(- 30);
    }];
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor clearColor];
    deleteBtn.titleLabel.textColor = [UIColor whiteColor];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    deleteBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    deleteBtn.layer.borderWidth = 1.f;
    deleteBtn.layer.cornerRadius = 5.f;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cuBgView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(topBgView.mas_centerX).offset(- 80);
        make.width.mas_equalTo(80 *scale);
        make.height.mas_equalTo(35 *scale);
    }];
    
    UIButton * modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.backgroundColor = [UIColor clearColor];
    modifyBtn.titleLabel.textColor = [UIColor whiteColor];
    [modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [modifyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    modifyBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    modifyBtn.layer.borderWidth = 1.f;
    modifyBtn.layer.cornerRadius = 5.f;
    modifyBtn.layer.masksToBounds = YES;
    [modifyBtn addTarget:self action:@selector(modifyClicked) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:modifyBtn];
    [modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cuBgView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(topBgView.mas_centerX).offset(80);
        make.width.mas_equalTo(80 *scale);
        make.height.mas_equalTo(35 *scale);
    }];
    
    [self creatBottomView];
    
}

- (void) creatBottomView{
    
    CGFloat scale = kMainBoundsWidth/375.f;
    
    UIView *bottomBgView = [[UIView alloc] init];
    bottomBgView.backgroundColor = UIColorFromRGB(0xeee8e0);
    [self.view addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 20) ,kMainBoundsHeight - 64 -  (370 + 70)));
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo( - 40);
    }];
    
    self.roomTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.roomTitleLab.backgroundColor = [UIColor clearColor];
    self.roomTitleLab.font = [UIFont systemFontOfSize:15];
    self.roomTitleLab.textColor = [UIColor grayColor];
    self.roomTitleLab.text = @"功能/服务";
    self.roomTitleLab.textAlignment = NSTextAlignmentCenter;
    [bottomBgView addSubview:self.roomTitleLab];
    [self.roomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30), 25 *scale));
        make.centerX.mas_equalTo(bottomBgView);
        make.top.mas_equalTo(15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [bottomBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 20), 1));
        make.centerX.mas_equalTo(bottomBgView);
        make.top.mas_equalTo(self.roomTitleLab.mas_bottom).offset(14);
    }];
    
    NSArray *subTitleArray = [NSArray arrayWithObjects:@"致欢迎词",@"推荐特色菜",@"上传小票照片", nil];
    CGFloat distance = (kMainBoundsWidth - 20 - 60 *3)/6;
    CGFloat titleDistance = (kMainBoundsWidth - 20 - 80 *3)/6;
    CGFloat idenDistance = (kMainBoundsWidth - 20 - 45 *3)/6;
    for (int i = 0; i < subTitleArray.count; i ++) {
        
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFill;
        tmpImgView.layer.masksToBounds = YES;
        tmpImgView.backgroundColor = [UIColor cyanColor];
        tmpImgView.tag = 10000 + i;
        [bottomBgView addSubview:tmpImgView];
        [tmpImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60 *scale);
            make.height.mas_equalTo(60 *scale);
            make.top.mas_equalTo(lineView.mas_bottom).offset(20);
            make.left.mas_equalTo(distance + i *(60 + distance *2));
        }];
        
        UILabel *subTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        subTitleLab.backgroundColor = [UIColor clearColor];
        subTitleLab.font = [UIFont systemFontOfSize:14];
        subTitleLab.textColor = [UIColor grayColor];
        subTitleLab.text = subTitleArray[i];
        subTitleLab.textAlignment = NSTextAlignmentCenter;
        [bottomBgView addSubview:subTitleLab];
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80 *scale);
            make.height.mas_equalTo(25 *scale);
            make.top.mas_equalTo(tmpImgView.mas_bottom).offset(5);
            make.left.mas_equalTo(titleDistance + i *(80 + titleDistance *2));
        }];
        
        UILabel *idenLab = [[UILabel alloc] initWithFrame:CGRectZero];
        idenLab.backgroundColor = [UIColor clearColor];
        idenLab.font = [UIFont systemFontOfSize:14];
        idenLab.textColor = [UIColor blueColor];
        idenLab.layer.borderWidth = .5f;
        idenLab.layer.cornerRadius = 4.f;
        idenLab.layer.masksToBounds = YES;
        idenLab.layer.borderColor = [UIColor blueColor].CGColor;
        idenLab.text = @"已完成";
        idenLab.textAlignment = NSTextAlignmentCenter;
        [bottomBgView addSubview:idenLab];
        [idenLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45 *scale);
            make.height.mas_equalTo(20 *scale);
            make.top.mas_equalTo(subTitleLab.mas_bottom).offset(5);
            make.left.mas_equalTo(idenDistance + i *(45 + idenDistance *2));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funClick:)];
        tap.numberOfTapsRequired = 1;
        [tmpImgView addGestureRecognizer:tap];
        
    }
}

- (void)deleteClicked{
    
}

- (void)modifyClicked{
    
}

- (void)funClick:(UITapGestureRecognizer *)tapGesture{
    
    NSInteger tmpTag =  tapGesture.view.tag;
    if (tmpTag == 10001) {
        
    }else if (tmpTag == 10002){
        
    }else if (tmpTag == 10003){
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
