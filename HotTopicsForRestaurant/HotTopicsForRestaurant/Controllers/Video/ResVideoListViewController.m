//
//  ResVideoListViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/17.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResVideoListViewController.h"
#import "ResVideoCollectionViewCell.h"
#import "ResAddVideoListViewController.h"
#import "RestaurantPhotoTool.h"
#import "ResSliderSettingView.h"
#import "ResUploadVideoView.h"
#import "RDAlertView.h"
#import "RDAlertAction.h"
#import "SAVORXAPI.h"
#import "ResConnectViewController.h"
#import "RestaurantPhotoTool.h"
#import <AVKit/AVKit.h>

@interface ResVideoListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) ResSliderVideoModel * model;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * assetSource;
@property (nonatomic, strong) UICollectionView * collectionView; //展示图片列表视图
@property (nonatomic, assign) BOOL isChooseStatus; //当前是否在选择状态
@property (nonatomic, strong) UIView * bottomView; //底部控制栏
@property (nonatomic, assign) BOOL isAllChoose; //是否是全选
@property (nonatomic, strong) NSMutableArray * selectArray; //选择的数组
@property (nonatomic, strong) UIButton * sliderButton;
@property (nonatomic, strong) UIButton * removeButton;
@property (nonatomic, strong) UIButton * doneItem;
@property (nonatomic, strong) UIButton * addButton;
@property (nonatomic ,strong) ResUploadVideoView * upLoadmaskingView; //上传图片蒙层
@property (nonatomic ,assign) NSInteger time;
@property (nonatomic ,assign) NSInteger totalTime;
@property (nonatomic, strong) AVPlayerViewController * playerVC;
//@property (nonatomic ,strong) ConnectMaskingView *searchMaskingView;    //搜索环境蒙层
@property (nonatomic, copy) void(^block)(NSDictionary * item);

@end

@implementation ResVideoListViewController

- (instancetype)initWithModel:(ResSliderVideoModel *)model block:(void (^)(NSDictionary *))block
{
    if (self = [super init]) {
        self.dataSource = [NSMutableArray arrayWithArray:model.assetIds];
        self.model = model;
        self.block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.title;
    __weak typeof(self) weakSelf = self;
    [self setUpDataSourceWithComplete:^(BOOL needUpdate) {
        if (needUpdate) {
            weakSelf.block([RestaurantPhotoTool createSliderVideoItemWithArray:weakSelf.dataSource title:weakSelf.model.title]);
        }
        [weakSelf createUI];
    }];
}

- (void)reloadData
{
    __weak typeof(self) weakSelf = self;
    [self setUpDataSourceWithComplete:^(BOOL needUpdate) {
        [weakSelf.collectionView reloadData];
    }];
}

- (void)reloadDataWithUIApplicationDidBecomeActive
{
    __weak typeof(self) weakSelf = self;
    [self setUpDataSourceWithComplete:^(BOOL needUpdate) {
        if (needUpdate) {
            weakSelf.block([RestaurantPhotoTool createSliderVideoItemWithArray:weakSelf.dataSource title:weakSelf.model.title]);
        }
        [weakSelf.collectionView reloadData];
    }];
}

- (void)removeObjectAtIndex:(NSInteger)index
{
    [self.dataSource removeObjectAtIndex:index];
    [self.assetSource removeObjectAtIndex:index];
}

- (void)setUpDataSourceWithComplete:(void (^)(BOOL needUpdate))finished
{
    self.assetSource = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray * reserveArray = [NSMutableArray new];
        BOOL needUpdate = NO;
        for (NSInteger i = self.dataSource.count - 1; i >= 0; i--) {
            NSString * str = [self.dataSource objectAtIndex:i];
            PHAsset * currentAsset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
            if (currentAsset) {
                [reserveArray addObject:currentAsset];
            }else{
                [self.dataSource removeObjectAtIndex:i];
                needUpdate = YES;
            }
        }
        
        if (reserveArray.count > 0) {
            [self.assetSource removeAllObjects];
            [self.assetSource addObjectsFromArray:[[reserveArray reverseObjectEnumerator] allObjects]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (needUpdate) {
                [RestaurantPhotoTool updateSliderVideoItemWithIDArray:self.dataSource andTitle:self.model.title success:^(NSDictionary *item) {
                    
                } failed:^(NSError *error) {
                    
                }];
            }
            
            if (self.dataSource.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showTextHUDwithTitle:@"该视频已经被删除" delay:1.f];
            }else{
                finished(needUpdate);
            }
        });
    });
}

- (void)createUI
{
    self.selectArray = [NSMutableArray new];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonItemDidClicked)];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CollectionViewCellSize;
    flowLayout.minimumInteritemSpacing = 3;
    flowLayout.minimumLineSpacing = 3;
    flowLayout.sectionInset = UIEdgeInsetsMake(3, 5, 50, 5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[ResVideoCollectionViewCell class] forCellWithReuseIdentifier:@"VideoListCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColorFromRGB(0xffffff) colorWithAlphaComponent:.95f];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 50));
    }];
    
    self.sliderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sliderButton.backgroundColor = [UIColorFromRGB(0xffffff) colorWithAlphaComponent:.94f];
    self.sliderButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.sliderButton setTitleColor:FontColor forState:UIControlStateNormal];
    [self.sliderButton setImage:[UIImage imageNamed:@"touping"] forState:UIControlStateNormal];
    [self.sliderButton addTarget:self action:@selector(photoArrayToPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sliderButton];
    [self.sliderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 50));
    }];
    
    self.doneItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.doneItem setTitleColor:FontColor forState:UIControlStateNormal];
    [self.doneItem setTitle:@"全选" forState:UIControlStateNormal];
    [self.doneItem addTarget:self action:@selector(allChoose) forControlEvents:UIControlEventTouchUpInside];
    
    self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.removeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.removeButton setTitleColor:FontColor forState:UIControlStateNormal];
    [self.removeButton setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    [self.removeButton addTarget:self action:@selector(removePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.addButton setTitleColor:FontColor forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    [self.addButton setTitle:@" 添加视频" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:self.doneItem];
    [self.bottomView addSubview:self.addButton];
    [self.bottomView addSubview:self.removeButton];
    
    [self.doneItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    
    [self addNotifiCation];
}

- (void)addPhotos
{
    if (self.dataSource.count >= 50) {
        [Helper showTextHUDwithTitle:@"最多只能添加50个" delay:1.f];
    }else{
        [self rightButtonItemDidClicked];
        ResAddVideoListViewController * view = [[ResAddVideoListViewController alloc] initWithModel:self.model block:^(NSDictionary *item) {
            [self.model.assetIds removeAllObjects];
            [self.model.assetIds addObjectsFromArray:[item objectForKey:@"resSliderVideoIds"]];
            self.dataSource = [NSMutableArray arrayWithArray:self.model.assetIds];
            [self reloadData];
            self.block(item);
        }];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)removePhoto
{
    if (self.selectArray.count == 0) {
        [Helper showTextHUDwithTitle:@"请选择要删除的视频" delay:1.5f];
        return;
    }
    
    UIAlertController * alert;
    BOOL isAllRemove = NO;
    NSString * title = @"提示";
    if (self.selectArray.count >= self.dataSource.count) {
        isAllRemove = YES;
        alert = [UIAlertController alertControllerWithTitle:title message:@"将删除此视频，但不会删除本地视频" preferredStyle:UIAlertControllerStyleAlert];
    }else{
        alert = [UIAlertController alertControllerWithTitle:title message:[NSString stringWithFormat:@"是否删除%ld个视频", (unsigned long)self.selectArray.count] preferredStyle:UIAlertControllerStyleAlert];
    }
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (isAllRemove) {
            [RestaurantPhotoTool removeSliderVideoItemWithTitle:self.model.title success:^(NSDictionary *item) {
                self.block(item);
                [self.navigationController popViewControllerAnimated:YES];
            } failed:^(NSError *error) {
                [Helper showTextHUDwithTitle:[error.userInfo objectForKey:@"msg"] delay:1.5f];
            }];
        }else{
            [self.selectArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSIndexPath * indexPath1 = (NSIndexPath *)obj1;
                NSIndexPath * indexPath2 = (NSIndexPath *)obj2;
                return indexPath1.row < indexPath2.row;
            }];
            
            for (NSInteger i = 0; i < self.selectArray.count; i++) {
                NSIndexPath * indexPath = [self.selectArray objectAtIndex:i];
                [self removeObjectAtIndex:indexPath.row];
            }
            
            [RestaurantPhotoTool updateSliderVideoItemWithIDArray:self.dataSource andTitle:self.model.title success:^(NSDictionary *item) {
                
                NSArray * tempArray = [NSArray arrayWithArray:self.selectArray];
                [self.selectArray removeAllObjects];
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView deleteItemsAtIndexPaths:tempArray];
                } completion:^(BOOL finished) {
                    [self.collectionView reloadData];
                }];
                [Helper showTextHUDwithTitle:@"删除成功" delay:1.5f];
                self.block(item);
            } failed:^(NSError *error) {
                [Helper showTextHUDwithTitle:[error.userInfo objectForKey:@"msg"] delay:1.5f];
            }];
        }
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

//右上方导航栏按钮被点击
- (void)rightButtonItemDidClicked
{
    if (self.isChooseStatus) {
        if (self.isAllChoose) {
            [self.doneItem setTitle:@"全选" forState:UIControlStateNormal];
        }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonItemDidClicked)];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(0);
        }];
        self.sliderButton.hidden = NO;
        self.isChooseStatus = NO;
        self.isAllChoose = NO;
        [self.selectArray removeAllObjects];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonItemDidClicked)];
        [self.doneItem setTitle:@"全选" forState:UIControlStateNormal];
        [self.doneItem addTarget:self action:@selector(allChoose) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-50);
        }];
        self.sliderButton.hidden = YES;
        self.isChooseStatus = YES;
    }
    [self.collectionView reloadData];
}

- (void)allChoose
{
    self.isAllChoose = YES;
    [self.doneItem setTitle:@"取消全选" forState:UIControlStateNormal];
    [self.doneItem addTarget:self action:@selector(cancelAllChoose) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.selectArray removeAllObjects];
    for (NSInteger i = 0; i < self.assetSource.count; i++) {
        [self.selectArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.collectionView reloadData];
}

- (void)cancelAllChoose
{
    if (self.selectArray.count > 0) {
        [self.selectArray removeAllObjects];
    }
    self.isAllChoose = NO;
    [self.doneItem setTitle:@"全选" forState:UIControlStateNormal];
    [self.doneItem addTarget:self action:@selector(allChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionView reloadData];
}

- (void)photoArrayToPlay
{
    if ([GlobalData shared].isBindRD) {
        ResSliderSettingView * settingView = [[ResSliderSettingView alloc] initWithFrame:[UIScreen mainScreen].bounds andType:YES block:^(NSInteger time,NSInteger quality, NSInteger totalTime) {
            
            self.time = time;
            self.totalTime = totalTime;
            
            self.sliderButton.userInteractionEnabled = NO;
            self.upLoadmaskingView = [[ResUploadVideoView alloc] initWithAssetIDS:self.dataSource totalTime:totalTime quality:quality groupName:self.model.title handler:^(NSError *error) {
                self.sliderButton.userInteractionEnabled = YES;
                [self.upLoadmaskingView endUpload];
                if (error) {
                    if (error.code == 202) {
                        NSString *errorStr = [error.userInfo objectForKey:@"info"];
                        if (!isEmptyString(errorStr)) {
                            [SAVORXAPI showAlertWithMessage:errorStr];
                        }else{
                            [Helper showTextHUDwithTitle:@"投屏失败" delay:4.f];
                        }
                        
                    }else if (error.code == 201) {
                        
                    }else{
                        [Helper showTextHUDwithTitle:@"投屏失败" delay:4.f];
                    }
                }else{
                    [Helper showTextHUDwithTitle:@"投屏成功" delay:4.f];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            [self.upLoadmaskingView startUpload];
            
        }];
        [settingView show];
    }else if ([GlobalData shared].scene == RDSceneHaveRDBox) {
        [SAVORXAPI callCodeWithSuccess:^{
            ResConnectViewController * connect = [[ResConnectViewController alloc] init];
            [self.navigationController pushViewController:connect animated:YES];
        } failure:^{
            [Helper showTextHUDwithTitle:@"验证码呼出失败" delay:1.5f];
        }];
    }else{
        [SAVORXAPI showAlertWithMessage:@"请连接需要投屏包间的WIFI"];
    }
    //
    //    if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
    //        ResSliderSettingView * settingView = [[ResSliderSettingView alloc] initWithFrame:[UIScreen mainScreen].bounds block:^(NSInteger time, NSInteger totalTime) {
    //            NSLog(@"图片停留时长为:%ld秒, 播放总时长为:%ld秒", time, totalTime);
    //            self.time = time;
    //            self.totalTime = totalTime;
    //            if ([GlobalData shared].isBindRD) {
    //
    //                [self creatMaskingView:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",time],@"time",[NSString stringWithFormat:@"%ld",totalTime],@"totalTime",self.model.title,@"sliderName" ,nil]];
    //
    //            }else{
    //                [self creatSearchPlatMaskingView];
    //                [[GCCDLNA defaultManager] startSearchPlatform];
    //            }
    //        }];
    //        [settingView show];
    //    }else{
    //        RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"请连接需要投屏包间的WIFI"]];
    //        RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"我知道了" handler:^{
    //
    //        } bold:NO];
    //        [alertView addActions:@[action]];
    //        [alertView show];
    //    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ResVideoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoListCell" forIndexPath:indexPath];
    
    PHAsset * currentAsset = [self.assetSource objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [cell configWithPHAsset:currentAsset completionHandle:^(PHAsset *asset, BOOL isSelect) {
        if (isSelect) {
            if (![weakSelf.selectArray containsObject:indexPath]) {
                [weakSelf.selectArray addObject:indexPath];
            }
        }else{
            if ([weakSelf.selectArray containsObject:indexPath]) {
                [weakSelf.selectArray removeObject:indexPath];
                weakSelf.isAllChoose = NO;
                [weakSelf.doneItem setTitle:@"全选" forState:UIControlStateNormal];
                [weakSelf.doneItem addTarget:weakSelf action:@selector(allChoose) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
    
    if (self.isChooseStatus) {
        if ([self.selectArray containsObject:indexPath]) {
            [cell configSelectStatus:YES];
        }else{
            [cell configSelectStatus:NO];
        }
    }
    [cell changeChooseStatus:self.isChooseStatus];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset * currentAsset = [self.assetSource objectAtIndex:indexPath.row];
    //配置导出参数
    PHVideoRequestOptions *options = [PHVideoRequestOptions new];
    options.networkAccessAllowed = YES;
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:currentAsset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playerVC = [[AVPlayerViewController alloc] init];
            self.playerVC.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            [self presentViewController:self.playerVC animated:YES completion:nil];
        });
    }];
}

//// 如果不是绑定状态，创建蒙层，重新搜索环境
//- (void)creatSearchPlatMaskingView{
//    [self addNotifiCation];
//    if (_searchMaskingView.superview) {
//        [_searchMaskingView removeFromSuperview];
//    }
//
//    _searchMaskingView = [[ConnectMaskingView alloc] initWithFrame:self.view.frame];
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    _searchMaskingView.bottom = keyWindow.top;
//    [keyWindow addSubview:_searchMaskingView];
//    [self showSearchViewWithAnimationDuration:0.3];
//}

//#pragma mark - show SearchView
//-(void)showSearchViewWithAnimationDuration:(float)duration{
//
//    [UIView animateWithDuration:duration animations:^{
//
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        _searchMaskingView.bottom = keyWindow.bottom;
//
//    } completion:^(BOOL finished) {
//
//    }];
//}

//-(void)dismissSearchView{
//
//    [_searchMaskingView removeFromSuperview];
//    _searchMaskingView = nil;
//}

//#pragma mark - BoxSence change
//// 发现了盒子环境
//- (void)foundBoxSence{
//    [self removeNotification];
//    if (_searchMaskingView) {
//        [self dismissSearchView];
//    }
//    [self creatMaskingView:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.time],@"time",[NSString stringWithFormat:@"%ld",self.totalTime],@"totalTime",self.model.title,@"sliderName" ,nil]];
//}

//- (void)stopSearchDevice{
//    [self removeNotification];
//    if (_searchMaskingView) {
//         [self dismissSearchView];
//    }
//    RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"连接失败，请重新连接"]];
//    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
//
//    } bold:NO];
//    RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"重新连接" handler:^{
//        [self creatSearchPlatMaskingView];
//        [[GCCDLNA defaultManager] startSearchPlatform];
//    } bold:NO];
//    [alertView addActions:@[action,actionOne]];
//    [alertView show];
//}

// 没有发现环境
//- (void)notFoundSence{
//    [self removeNotification];
//    if (_searchMaskingView) {
//        [self dismissSearchView];
//    }
//    if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
//        RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"连接失败，请重新连接"]];
//        RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
//
//        } bold:NO];
//        RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"重新连接" handler:^{
//            [self creatSearchPlatMaskingView];
//            [[GCCDLNA defaultManager] startSearchPlatform];
//        } bold:NO];
//        [alertView addActions:@[action,actionOne]];
//        [alertView show];
//    }else{
//        RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"请连接需要投屏包间的WIFI"]];
//        RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"我知道了" handler:^{
//
//        } bold:NO];
//        [alertView addActions:@[action]];
//        [alertView show];
//    }
//}

- (void)addNotifiCation
{
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundBoxSence) name:RDDidBindDeviceNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSearchDevice) name:RDStopSearchDeviceNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notFoundSence) name:RDDidNotFoundSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoArrayToPlay) name:RDDidBindDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWithUIApplicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

//- (void)removeNotification
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidBindDeviceNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDStopSearchDeviceNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidNotFoundSenceNotification object:nil];
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidBindDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
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
