//
//  CustomViewController.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/27.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "CustomViewController.h"
#import "HHMainImageView.h"
#import "HHIconView.h"
#import "HHButton.h"
#import "HHPaletteView.h"
#import "HHAlertView.h"
#import "HHSliderView.h"
#import "HHToolView.h"
#import "GPUImage.h"
#import "UIImage+QMUI.h"
#import "UIImage+ColorSelect.h"
#import "FlatUIKit.h"
#import "CommonTool.h"
#import "QMUITips.h"
#import "LDImagePicker.h"

@interface CustomViewController ()<LDImagePickerDelegate>

@property (nonatomic, weak) GPUImageView *backgroundView;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) GPUImageGaussianBlurFilter *blurFilter;
@property (nonatomic, strong) GPUImagePicture *staticPicture;

@end

@implementation CustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cloudsColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self setupToolBar];
}

- (void)dealloc
{
    _blurFilter = nil;
    _staticPicture = nil;
    _iconArray = nil;
}

- (void)setupToolBar
{
    __weak __typeof(self)weakSelf = self;
    HHToolView *toolView = [[HHToolView alloc] initWithFrame:CGRectMake(0, self.view.height - 70, self.view.width, 70)];
    toolView.contentSize = CGSizeMake(self.view.bounds.size.width*2, 0);
    toolView.buttonCallback = ^(NSInteger tag, UIView *toolBarView)
    {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        switch (tag)
        {
            case 0://背景图片
            {
                LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
                imagePicker.delegate = strongSelf;
                [imagePicker showImagePickerWithType:ImagePickerPhoto inViewController:strongSelf cropSize:CGSizeMake(IPhoneWidth, IPhoneHeight)];
            }
                break;
                
            case 1://背景颜色
            {
                HHPaletteView *paletteView = [[HHPaletteView alloc] initWithFrame:CGRectMake(0, IPhoneHeight, IPhoneWidth, 300)];
                paletteView.panGesturesCallBack = ^(UIColor *mainColor, BOOL isClose)
                {
                    strongSelf.view.backgroundColor = mainColor;
                };
                [strongSelf.view addSubview:paletteView];
            }
                break;
            
            case 2://相框图片
            {
                LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
                imagePicker.delegate = strongSelf;
                [imagePicker showImagePickerWithType:ImagePickerPhoto inViewController:strongSelf cropSize:CGSizeMake(IPhoneWidth, 280)];
            }
                break;
                
            case 3://特效icon
            {
                HHAlertView *alertView = [[HHAlertView alloc] initWithTitle:@"请输入icon行数" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" textFieldCallback:^(NSString *textString) {
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [QMUITips showLoading:@"渲染中" inView:window];
                    [strongSelf setupAppIconWithRow:[textString integerValue]];
                    [strongSelf showPaletteView];
                    [QMUITips hideAllToastInView:window animated:YES];
                }];
                [alertView show];
            }
                break;
                
            case 4://预览
            {
                
            }
                break;
                
            case 5://重置
            {
                for(UIView *view in self.view.subviews)
                {
                    if (![view isMemberOfClass:[HHToolView class]])
                    {
                        [view removeFromSuperview];
                    }
                }
            }
                break;
                
            case 6://保存
            {
                [toolBarView setHidden:YES];
                [strongSelf.navigationController setNavigationBarHidden:YES animated:YES];
                UIImage *image = [UIImage qmui_imageWithView:strongSelf.view afterScreenUpdates:YES];
                UIImageWriteToSavedPhotosAlbum(image, strongSelf, nil, nil);
                [QMUITips showSucceed:@"保存成功" inView:strongSelf.view hideAfterDelay:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [toolBarView setHidden:NO];
                });
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:toolView];
}

#pragma mark - private
- (void)setBackgroundViewWithImage:(UIImage *)image
{
    if (_backgroundView)
    {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
    _staticPicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    GPUImageView *backgroundView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
    _blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [_blurFilter forceProcessingAtSize:backgroundView.sizeInPixels];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    [_blurFilter addTarget:backgroundView];
    [_staticPicture addTarget:_blurFilter];
    [_staticPicture processImage];
    _backgroundView = backgroundView;
    
    HHSliderView *slider = [[HHSliderView alloc] initWithFrame:CGRectMake(0, IPhoneHeight, IPhoneWidth, 150)];
    slider.sliderCallback = ^(float value)
    {
        [_blurFilter setBlurRadiusInPixels:value];
        [_staticPicture processImage];
    };
    [self.view addSubview:slider];
}

- (void)setMainImageViewWithImage:(UIImage *)image
{
    CGSize newSize = [image getNewSizeInMultiple:IPhoneWidth-20];
    HHMainImageView *mainImgView = [[HHMainImageView alloc] initWithFrame:CGRectMake(10, 350, newSize.width, newSize.height)];
    [mainImgView setImage:image];
    [self.view addSubview:mainImgView];
}

- (void)setupAppIconWithRow:(NSInteger)row
{
    [self removeIconView];
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < row; j++)
        {
            CGFloat iconLength = [CommonTool isIPhone6Screen] ? 57 : 60;
            CGFloat xMargin    = [CommonTool isIPhone6Screen] ? 29 : 35;
            CGFloat yMargin    = [CommonTool isIPhone6Screen] ? 30 : 38;
            CGFloat xPosition  = xMargin*(i+1) + iconLength*i + ([CommonTool isIPhone6Screen] ? i : (- i/2));
            CGFloat yPosition  = yMargin*(j+1) + iconLength*j + ([CommonTool isIPhone6Screen] ? j : j*2);
            CGRect rect = CGRectMake(xPosition, yPosition, iconLength, iconLength);
            HHIconView *shadow = [[HHIconView alloc] init];
            [shadow setupAppIconWithView:self.view rect:rect];
            [self.view addSubview:shadow];
            [mArray addObject:shadow];
        }
    }
    self.iconArray = [mArray copy];
}

- (void)showPaletteView
{
    HHPaletteView *paletteView = [[HHPaletteView alloc] initWithFrame:CGRectMake(0, IPhoneHeight, IPhoneWidth, 300)];
    paletteView.panGesturesCallBack = ^(UIColor *mainColor, BOOL isClose)
    {
        if (isClose)
        {
            [self removeIconView];
        }
        else
        {
            for (UIImageView *appIcon in self.iconArray)
            {
                appIcon.layer.shadowColor = mainColor.CGColor;
            }
        }
    };
    [self.view addSubview:paletteView];
}

- (void)removeIconView
{
    if (self.iconArray.count > 0)
    {
        for (HHIconView *iconView in self.iconArray)
        {
            [iconView removeFromSuperview];
        }
        self.iconArray = nil;
    }
}

#pragma mark - LDImagePickerDelegate
- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage
{
    if (editedImage.size.height > editedImage.size.width)
    {
        [self setBackgroundViewWithImage:editedImage];
    }
    else
    {
        [self setMainImageViewWithImage:editedImage];
    }
}

- (NSArray *)iconArray
{
    if (!_iconArray)
    {
        _iconArray = [NSArray array];
    }
    return _iconArray;
}
@end
