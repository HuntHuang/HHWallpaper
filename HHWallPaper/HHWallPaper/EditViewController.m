//
//  EditViewController.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/5.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "EditViewController.h"
#import "GPUImageGaussianBlurFilter.h"
#import "GPUImageHazeFilter.h"
#define IPhoneWidth    [[UIScreen mainScreen] bounds].size.width    
#define IPhoneHeight   [[UIScreen mainScreen] bounds].size.height

@interface EditViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(12, 300, 100, 50)];
    [button setTitle:@"Choose" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(presentImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)presentImagePicker
{
    UIImagePickerController *pickCtl = [[UIImagePickerController alloc] init];
    pickCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickCtl.delegate = self;
    [self presentViewController:pickCtl animated:YES completion:nil];
}

- (void)setBackgroundViewWithImage:(UIImage *)image
{
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 20;
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
    [bgImgView setImage:blurredImage];
    [self.view addSubview:bgImgView];
}

- (void)setMainImageViewWithImage:(UIImage *)image
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIImageView *mainImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 350, IPhoneWidth-20, 200)];
    [mainImgView setImage:image];
    
    mainImgView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    mainImgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    mainImgView.layer.shadowOpacity = 1;//阴影透明度，默认0
    mainImgView.layer.shadowRadius = 3;//阴影半径，默认3
    
    float width = mainImgView.bounds.size.width;
    float height = mainImgView.bounds.size.height;
    float x = mainImgView.bounds.origin.x;
    float y = mainImgView.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = mainImgView.bounds.origin;
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    CGPoint lddRight = CGPointMake(x+width , y+ height );
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    //    [path addQuadCurveToPoint:topRight
    //                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:topRight
                 controlPoint:lddRight];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    
    //设置阴影路径
    mainImgView.layer.shadowPath = path.CGPath;
    
    [self.view addSubview:mainImgView];
}

- (void)screenShots
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
    NSLog(@"Suceeded!");
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    [self setBackgroundViewWithImage:[UIImage imageWithData:data]];
    [self setMainImageViewWithImage:[UIImage imageWithData:data]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self screenShots];
    });
}

@end
