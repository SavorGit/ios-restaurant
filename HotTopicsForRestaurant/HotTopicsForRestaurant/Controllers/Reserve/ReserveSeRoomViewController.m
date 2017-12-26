//
//  ReserveSeRoomViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReserveSeRoomViewController.h"

#import "RDBoxModel.h"
#import "AddNewRoomRequest.h"

#import "SelectRoomCollectionCell.h"

@interface ReserveSeRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *inPutTextField;

@end

@implementation ReserveSeRoomViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initInfo];
    [self creatSubViews];
}

- (void)initInfo{
    
    self.title = @"选择包间";
    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
//        self.dataSource = [NSMutableArray new];
//        for (int i = 0 ; i < 18; i ++) {
//            RDBoxModel * tmpModel = [[RDBoxModel alloc] init];
//            tmpModel.sid = @"房间号";
//            [self.dataSource addObject:tmpModel];
//        }
}

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth/375.f;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
    
    UIView *inPutBgView = [[UIView alloc] init];
    inPutBgView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:inPutBgView];
    [inPutBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth , 50 *scale));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    UIView *textFieldBgView = [[UIView alloc] init];
    textFieldBgView.backgroundColor = [UIColor clearColor];
    textFieldBgView.layer.borderWidth = 1.f;
    textFieldBgView.layer.cornerRadius = 5;
    textFieldBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [inPutBgView addSubview:textFieldBgView];
    [textFieldBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 70) *scale , 40 *scale));
        make.left.mas_equalTo(15 *scale);
        make.top.mas_equalTo(5 *scale);
    }];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25 *scale)];
    self.inPutTextField = [[UITextField alloc] init];
    self.inPutTextField.placeholder = @"请输入文字";
    self.inPutTextField.delegate = self;
    self.inPutTextField.returnKeyType = UIReturnKeyDone;
    self.inPutTextField.enablesReturnKeyAutomatically = YES;
    self.inPutTextField.leftView = leftView;
    self.inPutTextField.leftViewMode = UITextFieldViewModeAlways;
    [textFieldBgView addSubview:self.inPutTextField];
    [self.inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 85 - 50 - 9) *scale , 40 *scale));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
    }];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = [UIColor orangeColor];
    addBtn.titleLabel.textColor = [UIColor whiteColor];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    addBtn.layer.borderWidth = 0.f;
    addBtn.layer.cornerRadius = 5.f;
    addBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    addBtn.layer.masksToBounds = YES;
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [textFieldBgView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.inPutTextField.mas_right).offset(10);
        make.width.mas_equalTo(50 *scale);
        make.height.mas_equalTo(40 *scale);
    }];
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 15.f;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(15.f *scale, 15 *scale, 15.f *scale, 15 *scale);
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled =  YES;
    [self.bgView addSubview:_collectionView];
    [_collectionView registerClass:[SelectRoomCollectionCell class] forCellWithReuseIdentifier:@"selectRoomCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64 - 50 *scale));
        make.top.mas_equalTo(self.inPutTextField.mas_bottom).offset(10 *scale);
        make.left.mas_equalTo(0);
    }];
}

#pragma mark - 添加新包间
- (void)addBtnClicked{
    
    if (!isEmptyString(self.inPutTextField.text)) {
        [self addNewRoomRequest];
    }else{
        [MBProgressHUD showTextHUDwithTitle:@"包间名称不能为空"];
    }
}

# pragma mark - 添加包间
- (void)addNewRoomRequest{
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"room_name": self.inPutTextField.text,
                              };
    [MBProgressHUD showLoadingWithText:@"提交数据" inView:self.view];
    AddNewRoomRequest * request = [[AddNewRoomRequest alloc] initWithPubData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[response objectForKey:@"code"] integerValue] == 10000) {
            
            NSDictionary *result = [response objectForKey:@"result"];
            ReserveModel *tmpModel = [[ReserveModel alloc] init];
            tmpModel.room_id = [result objectForKey:@"room_id"];
            tmpModel.room_type = [result objectForKey:@"room_type"];
            tmpModel.room_name = self.inPutTextField.text;
            if (self.backDatas) {
                self.backDatas(tmpModel);
                [self back];
            }
            
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}

#pragma mark - UICollectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectRoomCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"selectRoomCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    ReserveModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell configModelData:tmpModel];
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGFloat width = (kMainBoundsWidth - 60) / 2;
    return CGSizeMake(width , 36 *scale);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectRoomCollectionCell *tmpCell = (SelectRoomCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    tmpCell.titleLabel.backgroundColor = UIColorFromRGB(0xff783e);
    tmpCell.titleLabel.textColor = UIColorFromRGB(0xffffff);
    ReserveModel *tmpModel = self.dataSource[indexPath.row];
    if (self.backDatas) {
        self.backDatas(tmpModel);
    }
    [self back];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回当前屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
