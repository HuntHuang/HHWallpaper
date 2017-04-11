//
//  GaussianBlurViewController.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/10.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "GaussianBlurViewController.h"
#import "GPUImageGaussianBlurFilter.h"
#import "UIImage+QMUI.h"
#import "CommonTool.h"
#import "QMUITips.h"

@interface GaussianBlurViewController ()

@property (nonatomic, strong) UIImage *mainImage;
@property (nonatomic, weak) UIButton *saveBtn;

@end

@implementation GaussianBlurViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        self.mainImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackgroundViewWithImage:self.mainImage];
    [self setMainImageViewWithImage:self.mainImage];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, IPhoneHeight - 50, 40, 40)];
    [saveBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onClickedSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    self.saveBtn = saveBtn;
}

- (void)onClickedSave
{
    [self.saveBtn removeFromSuperview];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UIImage *image = [UIImage qmui_imageWithView:self.view afterScreenUpdates:YES];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    [QMUITips showSucceed:@"保存成功" inView:self.view hideAfterDelay:2];
}

- (void)onClickedImageView
{
    BOOL hidden = self.navigationController.navigationBar.hidden;
    [self.navigationController setNavigationBarHidden:!hidden animated:YES];
}

- (void)setBackgroundViewWithImage:(UIImage *)image
{
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 20;
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
    [bgImgView setImage:blurredImage];
    [bgImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    bgImgView.contentMode =  UIViewContentModeScaleAspectFill;
    bgImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    bgImgView.clipsToBounds  = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedImageView)];
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:bgImgView];
}

- (void)setMainImageViewWithImage:(UIImage *)image
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGSize newSize = [self getNewSizeFromOriginalSize:image.size inMultiple:IPhoneWidth-20];
    UIImageView *mainImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 350, newSize.width, newSize.height)];
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

- (CGSize)getNewSizeFromOriginalSize:(CGSize)originalSize
                          inMultiple:(NSInteger)multiple
{
    CGFloat scale;
    CGSize newsize = originalSize;
    if (newsize.height < newsize.width)
    {
        scale = originalSize.height / originalSize.width;
        newsize.width  = multiple;
        newsize.height = multiple * scale;
    }
    else
    {
        scale = originalSize.width / originalSize.height;
        newsize.height = multiple;
        newsize.width  = multiple *scale;
    }
    return newsize;
}

@end
