//
//  ResBaseViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"

@interface ResBaseViewController ()

@end

@implementation ResBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavBackArrow];
    // Do any additional setup after loading the view.
    [self setNavBackArrowWithWidth:40];
}

- (void)setNavBackArrowWithWidth:(CGFloat)width {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, width, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [button addTarget:self action:@selector(navBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)navBackButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navBarHairlineImageView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
}

- (void)setNavBackArrow {
    [self setNavBackArrowWithWidth:40];
    
    UIImageView *navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navBarHairlineImageView = navigationImageView;
}

-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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
