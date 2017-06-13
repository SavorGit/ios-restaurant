//
//  UIImage+Additional.m
//  newProjcet
//
//  Created by shanWu on 16/6/6.
//  Copyright © 2016年 SanShiChuangXiang. All rights reserved.
//

#import "UIImage+Additional.h"

@implementation UIImage (Additional)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}

+ (UIImage*)imageWithContentsOfURL:(NSURL*)url {
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if(error || !data) {
        return nil;
    } else {
        return [UIImage imageWithData:data];
    }
}

- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)originImageScaleToSize:(CGSize)size
{
    UIImage *image = self;
    CGSize newSize;
    
    if (image.size.height / image.size.width > 1){
        newSize.height = size.height;
        newSize.width = size.height / image.size.height * image.size.width;
        
    } else if (image.size.height / image.size.width < 1){
        
        newSize.height = size.width / image.size.width * image.size.height;
        newSize.width = size.width;
        
    } else {
        
        newSize = size;
        
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
@end
