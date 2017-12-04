//
//  SelectRoomViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SelectRoomViewController.h"
#import "RecoDishesCollectionViewCell.h"
#import "RecoDishesModel.h"
#import "SAVORXAPI.h"

@interface SelectRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SelectRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self creatSubViews];
    
    // Do any additional setup after loading the view.
}

- (void)initInfor{
    
    self.dataSource = [NSMutableArray new];
    for (int i = 0 ; i < 18; i ++) {
        RecoDishesModel * tmpModel = [[RecoDishesModel alloc] init];
        tmpModel.title = @"特色菜";
        [self.dataSource addObject:tmpModel];
    }
    
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

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 15.f;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(15.f *scale, 15 *scale, 15.f *scale, 15 *scale);
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled =  YES;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[RecoDishesCollectionViewCell class] forCellWithReuseIdentifier:@"imgCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
}

-(void)toScreenBtnDidClicked:(UIButton *)Btn{
    
}

#pragma mark - UICollectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecoDishesCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    RecoDishesModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell configModelData:tmpModel andIsPortrait:YES];
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGFloat width = (kMainBoundsWidth - 60) / 3;
    return CGSizeMake(width , 36 *scale);
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
