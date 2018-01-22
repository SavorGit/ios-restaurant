//
//  LookImageViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/9.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "LookImageViewController.h"
#import "MBProgressHUD+Custom.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LookImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView * loadingView;
@property (nonatomic, strong) UIScrollView * bigScrollView;
@property (nonatomic, strong) UIImageView * bigImageView;
@property (nonatomic, copy) NSString * imageURL;

@end

@implementation LookImageViewController

- (instancetype)initWithImageURL:(NSString *)imageURL
{
    if (self = [super init]) {
        self.imageURL = imageURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setUpViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appOrientationDidChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)appOrientationDidChange
{
    CGFloat scale = self.bigScrollView.zoomScale;
    
    if (self.loadingView.superview) {
        [self.loadingView removeFromSuperview];
    }
    [self.bigScrollView removeFromSuperview];
    [self.bigImageView removeFromSuperview];
    
    [self setUpViews];
    
    self.bigScrollView.zoomScale = scale;
}

- (void)setUpViews
{
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bigScrollView.maximumZoomScale = 3.f;
    self.bigScrollView.minimumZoomScale = 1.f;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.delegate = self;
    
    self.bigImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDidClicked)];
    tap2.numberOfTapsRequired = 1;
    [self.bigScrollView addGestureRecognizer:tap2];
    
    [self.view addSubview:self.bigScrollView];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.bigImageView addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40.f);
        make.center.mas_equalTo(0);
    }];
    [self.loadingView startAnimating];
    
    [self.bigScrollView addSubview:self.bigImageView];
    
    self.bigScrollView.zoomScale = 1.f;
    
    if (isEmptyString(self.imageURL)) {
        [MBProgressHUD  showTextHUDwithTitle:@"图片地址错误"];
        return;
    }
    
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image) {
            CGFloat scale = self.bigScrollView.frame.size.width / self.bigScrollView.frame.size.height;
            CGFloat imageScale = image.size.width / image.size.height;
            
            CGRect frame;
            if (imageScale > scale) {
                CGFloat width = self.bigScrollView.frame.size.width;
                CGFloat height = self.bigScrollView.frame.size.width / image.size.width * image.size.height;
                frame = CGRectMake(0, 0, width, height);
            }else{
                CGFloat height = self.bigScrollView.frame.size.height;
                CGFloat width = self.bigScrollView.frame.size.height / image.size.height * image.size.width;
                frame = CGRectMake(0, 0, width, height);
            }
            self.bigImageView.frame = frame;
            self.bigImageView.center = self.bigScrollView.center;
            [self.bigImageView setImage:image];
            
            [self hiddenLoading];
        }else{
            [MBProgressHUD  showTextHUDwithTitle:@"图片地址错误"];
            [self hiddenLoading];
        }
        
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == self.bigScrollView) {
        CGSize superSize = self.bigScrollView.frame.size;
        CGPoint center = CGPointMake(superSize.width / 2, superSize.height / 2);
        CGSize size = self.bigImageView.frame.size;
        if (size.width > superSize.width) {
            center.x = size.width / 2;
        }
        if (size.height > superSize.height) {
            center.y = size.height / 2;
        }
        self.bigImageView.center = center;
    }
}

- (void)photoDidClicked
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)hiddenLoading
{
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回当前屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
