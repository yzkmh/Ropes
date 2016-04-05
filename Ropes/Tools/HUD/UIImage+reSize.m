//
//  UIImage+reSize.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "UIImage+reSize.h"

@implementation UIImage (reSize)


+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return reSizeImage;
    
    
    
}
@end
