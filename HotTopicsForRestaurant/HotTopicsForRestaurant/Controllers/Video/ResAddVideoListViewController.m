//
//  ResAddVideoListViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/17.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResAddVideoListViewController.h"
#import "ResVideoCollectionViewCell.h"
#import "RestaurantPhotoTool.h"
#import "RDTextAlertView.h"

@interface ResAddVideoListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray * selectArray;
@property (nonatomic, strong) PHFetchResult * dataSource;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) ResSliderVideoModel * sliderModel;
@property (nonatomic, strong) UIView * bottomView; //底部控制栏
@property (nonatomic, strong) UIButton * chooseButton;
@property (nonatomic, assign) NSInteger currentNum;
@property (nonatomic, assign) BOOL isAllChoose; //记录当前的全选状态
@property (nonatomic, copy) void(^block)(NSDictionary * item);

@end

@implementation ResAddVideoListViewController

- (instancetype)initWithModel:(ResSliderVideoModel *)sliderModel block:(void (^)(NSDictionary *))block
{
    if (self = [super init]) {
        self.dataSource = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
        self.sliderModel = sliderModel;
        if (self.sliderModel) {
            self.currentNum = self.sliderModel.assetIds.count;
        }else{
            self.currentNum = 0;
        }
        self.isAllChoose = NO;
        self.block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    [self createUI];
}

- (void)createDataSource
{
    self.selectArray = [NSMutableArray new];
}

- (void)createUI
{
    self.title = @"所有视频";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(allChoose)];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CollectionViewCellSize;
    flowLayout.minimumInteritemSpacing = 3;
    flowLayout.minimumLineSpacing = 3;
    flowLayout.sectionInset = UIEdgeInsetsMake(3, 5, 50, 5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[ResVideoCollectionViewCell class] forCellWithReuseIdentifier:@"VideoCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColorFromRGB(0xffffff) colorWithAlphaComponent:.95f];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 50));
    }];
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseButton setFrame:CGRectMake(15, 0, kMainBoundsWidth - 30, 50)];
    [self.chooseButton setBackgroundColor:[UIColor clearColor]];
    [self.chooseButton setTitle:@"添加至视频" forState:UIControlStateNormal];
    [self.chooseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.chooseButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.chooseButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.chooseButton addTarget:self action:@selector(addPhotoToLibrary) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.chooseButton];
    self.chooseButton.userInteractionEnabled = NO;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [self.bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(.5);
        make.right.mas_equalTo(0);
    }];
    
    if (self.dataSource.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.dataSource.count - 1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        });
    }
}

- (void)allChoose
{
    NSInteger maxNumber = self.dataSource.count > kMAXVideoNum - self.currentNum ? kMAXVideoNum - self.currentNum : self.dataSource.count;
    
    NSInteger i = 0;
    while (i < maxNumber) {
        i++;
        if (i > self.dataSource.count) {
            break;
        }
        PHAsset * asset = [self.dataSource objectAtIndex:self.dataSource.count - i];
        if ([self.selectArray containsObject:asset]) {
            continue;
        }else{
            [self.selectArray addObject:asset];
        }
        if (self.selectArray.count >= 50) {
            break;
        }
    }
    self.isAllChoose = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消全选" style:UIBarButtonItemStyleDone target:self action:@selector(cancleAllChoose)];
    [self.collectionView reloadData];
    [self updateChooseStatus];
}

//取消全选
- (void)cancleAllChoose
{
    [self.selectArray removeAllObjects];
    self.isAllChoose = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(allChoose)];
    [self.collectionView reloadData];
    [self updateChooseStatus];
}

- (void)addPhotoToLibrary
{
    //开始添加
    
    NSMutableArray * assetIds = [NSMutableArray new];
    for (NSInteger i = 0; i < self.selectArray.count; i++) {
        PHAsset * asset = [self.selectArray objectAtIndex:i];
        [assetIds addObject:asset.localIdentifier];
    }
    
    if (assetIds.count > 0) {
        if (self.sliderModel) {
            
            NSMutableArray * array = [NSMutableArray arrayWithArray:self.sliderModel.assetIds];
            [array addObjectsFromArray:assetIds];
            [RestaurantPhotoTool updateSliderVideoItemWithIDArray:array andTitle:self.sliderModel.title success:^(NSDictionary *item) {
                
                self.block(item);
                
                [Helper showTextHUDwithTitle:@"添加成功" delay:1.5f];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } failed:^(NSError *error) {
                [Helper showTextHUDwithTitle:[error.userInfo objectForKey:@"msg"] delay:1.5f];
            }];
            
        }else{
            
            RDTextAlertView * alert = [[RDTextAlertView alloc] initWithMaxNumber:20 message:@"输入视频名称，最多20个字"];
            RDAlertAction * action1 = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
                
            } bold:NO];
            
            __weak typeof(alert) weakAlert = alert;
            RDAlertAction * action2 = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
                
                if (weakAlert.textView.text.length == 0) {
                    [Helper showTextHUDwithTitle:@"视频名称不能为空" delay:1.f];
                    return;
                }
                
                NSString * title = alert.textView.text;
                
                [RestaurantPhotoTool addSliderVideoItemWithIDArray:assetIds andTitle:title success:^(NSDictionary *item) {
                    [Helper showTextHUDwithTitle:@"创建成功" delay:1.5f];
                    self.block(item);
                    [self.navigationController popViewControllerAnimated:YES];
                } failed:^(NSError *error) {
                    [Helper showTextHUDwithTitle:[error.userInfo objectForKey:@"msg"] delay:1.5f];
                }];
                
            } bold:YES];
            [alert addActions:@[action1, action2]];
            [alert show];
            
        }
    }else{
        [Helper showTextHUDwithTitle:@"没有可以添加的视频" delay:1.5f];
    }
    
    //添加完成
}

//只有字数大于0时才能进行幻灯片创建
- (void)alertTextFieldDidChange
{
    UIAlertController * alert = (UIAlertController *)self.presentedViewController;
    UITextField * textFiled = [alert.textFields firstObject];
    UIAlertAction * action = [alert.actions lastObject];
    if (textFiled.text.length > 0) {
        action.enabled = YES;
        if (textFiled.text.length > 20) {
            textFiled.text = [textFiled.text substringToIndex:20];
            [Helper showTextHUDwithTitle:@"最多输入20个字符" delay:1.5f];
        }
    }else{
        action.enabled = NO;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ResVideoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    PHAsset * currentAsset = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithPHAsset:currentAsset completionHandle:^(PHAsset *asset, BOOL isSelect) {
        
        if (isSelect) {
            if (![weakSelf.selectArray containsObject:asset]) {
                if (weakSelf.selectArray.count + weakSelf.currentNum >= kMAXVideoNum) {
                    [cell configSelectStatus:NO];
                    [Helper showTextHUDwithTitle:@"最多只能选择50个" delay:1.5f];
                    return;
                }
                [weakSelf.selectArray addObject:asset];
            }
        }else{
            if ([weakSelf.selectArray containsObject:asset]) {
                [weakSelf.selectArray removeObject:asset];
                weakSelf.isAllChoose = NO;
                weakSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:weakSelf action:@selector(allChoose)];
            }
        }
        [weakSelf updateChooseStatus];
    }];
    
    
    if ([self.selectArray containsObject:currentAsset]) {
        [cell configSelectStatus:YES];
    }else{
        [cell configSelectStatus:NO];
    }
    
    return cell;
}

- (void)updateChooseStatus
{
    if (self.selectArray.count == 0) {
        self.title = @"所有视频";
        [self.chooseButton setTitle:@"添加至视频" forState:UIControlStateNormal];
        [self.chooseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.chooseButton.userInteractionEnabled = NO;
    }else{
        self.title = [NSString stringWithFormat:@"所有视频(%ld/%d)", self.selectArray.count + self.currentNum, kMAXVideoNum];
        if (self.sliderModel) {
            [self.chooseButton setTitle:[NSString stringWithFormat:@"添加至视频 '%@'", self.sliderModel.title] forState:UIControlStateNormal];
        }else{
            [self.chooseButton setTitle:@"创建视频" forState:UIControlStateNormal];
        }
        [self.chooseButton setTitleColor:FontColor forState:UIControlStateNormal];
        self.chooseButton.userInteractionEnabled = YES;
    }
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
