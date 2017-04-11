//
//  CommonTool.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/11.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "CommonTool.h"
#import <UIKit/UIKit.h>

@implementation CommonTool

+ (void)screenShots
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != &UIGraphicsBeginImageContextWithOptions)
    {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    //    else
    //    {
    //        UIGraphicsBeginImageContext(imageSize);
    //    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

@end
