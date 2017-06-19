//
//  ResWebViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResWebViewController.h"

@interface ResWebViewController ()<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, copy) NSString * url;

@end

@implementation ResWebViewController

- (instancetype)initWithURL:(NSString *)url
{
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customHelpView];
}

- (void)customHelpView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
    
    [MBProgressHUD showWebLoadingHUDInView:self.webView];
}

- (void)navBackButtonClicked:(UIButton *)sender {
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.webView animated:NO];
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
