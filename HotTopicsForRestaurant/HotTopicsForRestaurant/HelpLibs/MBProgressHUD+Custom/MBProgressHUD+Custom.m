//
//  MBProgressHUD+Custom.m
//  SavorX
//
//  Created by 郭春城 on 16/8/8.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "MBProgressHUD+Custom.h"
#import "AnimationImageView.h"

@implementation MBProgressHUD (Custom)

+ (MBProgressHUD *)showLoadingHUDInView:(UIView *)view
{
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = [UIColor whiteColor];
    hud.minSize = CGSizeMake(120, 120);
    hud.label.numberOfLines = 0;
    hud.label.text = @"\n正在加载";
    
    return hud;
}

+ (MBProgressHUD *)showCustomLoadingHUDInView:(UIView *)view
{
    UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    
    AnimationImageView * imageView = [[AnimationImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    NSMutableArray * array = [NSMutableArray new];
    for (NSInteger i = 0; i < 2; i++) {
        NSString * str = [NSString stringWithFormat:@"loading%ld", i];
        UIImage * image = [UIImage imageNamed:str];
        [array addObject:image];
    }
    imageView.animationImages = array;
    imageView.animationDuration = 0.3f;
    imageView.animationRepeatCount = MAXFLOAT;
    [imageView startAnimating];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.minSize = CGSizeMake(130, 130);
    hud.bezelView.color = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.numberOfLines = 0;
    hud.label.text = @"正在加载";
    hud.label.textColor = FontColor;
    
    return hud;
}

+ (MBProgressHUD *)showCustomLoadingHUDInView:(UIView *)view withTitle:(NSString *)title
{
    UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    
    [MBProgressHUD hideHUDForView:view animated:NO];
    
    AnimationImageView * imageView = [[AnimationImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    NSMutableArray * array = [NSMutableArray new];
    for (NSInteger i = 0; i < 2; i++) {
        NSString * str = [NSString stringWithFormat:@"loading%ld", (long)i];
        UIImage * image = [UIImage imageNamed:str];
        [array addObject:image];
    }
    imageView.animationImages = array;
    imageView.animationDuration = 0.3f;
    imageView.animationRepeatCount = MAXFLOAT;
    [imageView startAnimating];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.minSize = CGSizeMake(130, 130);
    hud.bezelView.color = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.numberOfLines = 0;
    hud.label.text = title;
    hud.label.textColor = FontColor;
    
    return hud;
}

+ (MBProgressHUD *)showProgressLoadingHUDInView:(UIView *)view
{
    UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    for (UIView * view in hud.bezelView.subviews) {
        if ([view isKindOfClass:[MBRoundProgressView class]]) {
            MBRoundProgressView * progress = (MBRoundProgressView *)view;
            progress.progressTintColor = FontColor;
            progress.backgroundTintColor = [UIColor whiteColor];
        }
    }
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = FontColor;
    hud.progress = 0.f;
    hud.minSize = CGSizeMake(130, 130);
    
    hud.label.text = @"视频转换中";
    hud.detailsLabel.textColor = FontColor;
    hud.detailsLabel.text = [NSString stringWithFormat:@"%.1lf%%", hud.progress * 100];
    
    return hud;
}

+ (MBProgressHUD *)showDeleteCacheHUDInView:(UIView *)view
{
    UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = FontColor;
    hud.minSize = CGSizeMake(120, 120);
    hud.label.numberOfLines = 0;
    hud.label.text = @"\n正在清除缓存";
    
    return hud;
}

+ (MBProgressHUD *)showSuccessHUDInView:(UIView *)view title:(NSString *)title
{
    UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [imageView setImage:[UIImage imageNamed:@"pd"]];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.minSize = CGSizeMake(120, 120);
    hud.label.textColor = FontColor;
    hud.label.text = title;
    
    [hud hideAnimated:YES afterDelay:.8f];
    
    return hud;
}

+ (void)showTextHUDwithTitle:(NSString *)title
{
    if (title && title.length > 0) {
        UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
        if (tempView) {
            [tempView removeFromSuperview];
        }
        
        CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreen_Width - 60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 30, rect.size.height + 20)];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.75f];
        view.center = CGPointMake(kScreen_Width / 2, kScreen_Height / 2);
        view.layer.cornerRadius = 5.f;
        view.clipsToBounds = YES;
        view.tag = 888;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10)];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.text = title;
        label.backgroundColor = [UIColor clearColor];
        label.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        [view addSubview:label];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(rect.size.width + 30);
            make.height.mas_equalTo(rect.size.height + 20);
            make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        [UIView animateWithDuration:0.5f delay:2.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.alpha = 0.f;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

+ (void)showTextHUDwithTitle:(NSString *)title delay:(CGFloat)delay
{
    if (title && title.length > 0) {
        UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
        if (tempView) {
            [tempView removeFromSuperview];
        }
        
        CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreen_Width - 60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 30, rect.size.height + 20)];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.75f];
        view.center = CGPointMake(kScreen_Width / 2, kScreen_Height / 2);
        view.layer.cornerRadius = 5.f;
        view.clipsToBounds = YES;
        view.tag = 888;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10)];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.text = title;
        label.backgroundColor = [UIColor clearColor];
        label.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        [view addSubview:label];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(rect.size.width + 30);
            make.height.mas_equalTo(rect.size.height + 20);
            make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        [UIView animateWithDuration:0.5f delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.alpha = 0.f;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

+ (void)showNetworkStatusTextHUDWithTitle:(NSString *)title delay:(CGFloat)delay
{
    if (title && title.length > 0) {
        UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
        if (tempView) {
            [tempView removeFromSuperview];
        }
        
        CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreen_Width - 60, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 30, rect.size.height + 20)];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.75f];
        view.center = CGPointMake(kScreen_Width / 2, kScreen_Height / 2);
        view.layer.cornerRadius = 5.f;
        view.clipsToBounds = YES;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 10, rect.size.height + 10)];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.text = title;
        label.backgroundColor = [UIColor clearColor];
        label.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        [view addSubview:label];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(rect.size.width + 30);
            make.height.mas_equalTo(rect.size.height + 20);
            make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        [UIView animateWithDuration:0.5f delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.alpha = 0.f;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

+ (void)removeTextHUD
{
    UIView * tempView = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
    if (tempView) {
        [tempView removeFromSuperview];
    }
}

+ (void)showLongTimeTextHUDInView:(UIView *)view title:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0;
    hud.label.text = title;
    hud.label.textColor = FontColor;
    [hud hideAnimated:YES afterDelay:2.5f];
}

+ (MBProgressHUD *)showWebLoadingHUDInView:(UIView *)view
{
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor blackColor];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.color = [UIColor clearColor];
    return hud;
}

+ (MBProgressHUD *)showBackDemandInView:(UIView *)view
{
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.bezelView.layer.cornerRadius = 10;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    hud.label.text = @"正在退出";
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = [UIColor whiteColor];
    hud.minSize = CGSizeMake(120, 120);
    return hud;
}

+ (MBProgressHUD *)showLoadingWithText:(NSString *)text inView:(UIView *)view
{
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = [UIColor whiteColor];
    hud.minSize = CGSizeMake(120, 120);
    hud.label.numberOfLines = 0;
    hud.label.text = text;
    
    return hud;
}

@end
