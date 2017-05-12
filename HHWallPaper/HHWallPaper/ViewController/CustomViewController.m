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
#import "GPUImage.h"
#import "UIImage+QMUI.h"
#import "UIImage+ColorSelect.h"
#import "FlatUIKit.h"
#import "CommonTool.h"
#import "QMUITips.h"
#import "LDImagePicker.h"

@interface CustomViewController ()<LDImagePickerDelegate>

@property (nonatomic, weak) UIView *toolBarView;
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
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, IPhoneHeight - 50, IPhoneWidth, 50)];
    [self.view addSubview:toolView];
    _toolBarView = toolView;
    
    HHButton *backgroundBtn = [[HHButton alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    [backgroundBtn setTitle:@"设置背景" forState:UIControlStateNormal];
    [backgroundBtn addTarget:self action:@selector(onClickBackground) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:backgroundBtn];
    
    HHButton *mainImageBtn = [[HHButton alloc] initWithFrame:CGRectMake(100, 0, 80, 40)];
    [mainImageBtn setTitle:@"设置小图" forState:UIControlStateNormal];
    [mainImageBtn addTarget:self action:@selector(onClickMainImage) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:mainImageBtn];
    
    HHButton *iconBtn = [[HHButton alloc] initWithFrame:CGRectMake(190, 0, 80, 40)];
    [iconBtn setTitle:@"特效icon" forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(onClickIcon) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:iconBtn];
    
    HHButton *saveBtn = [[HHButton alloc] initWithFrame:CGRectMake(280, 0, 80, 40)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onClickedSave) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:saveBtn];
}

#pragma mark - target action
- (void)onClickIcon
{
    HHAlertView *alertView = [[HHAlertView alloc] initWithTitle:@"请输入icon行数" cancelButtonTitle:@"确定" textFieldCallback:^(NSString *textString) {
        [self setupAppIconWithRow:[textString integerValue]];
        [self showPaletteView];
    }];
    [alertView show];
}

- (void)onClickBackground
{
    LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
    imagePicker.delegate = self;
    [imagePicker showImagePickerWithType:ImagePickerPhoto inViewController:self cropSize:CGSizeMake(IPhoneWidth, IPhoneHeight)];
}

- (void)onClickMainImage
{
    LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
    imagePicker.delegate = self;
    [imagePicker showImagePickerWithType:ImagePickerPhoto inViewController:self cropSize:CGSizeMake(IPhoneWidth, 280)];
}

- (void)onClickedSave
{
    [self.toolBarView setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UIImage *image = [UIImage qmui_imageWithView:self.view afterScreenUpdates:YES];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    [QMUITips showSucceed:@"保存成功" inView:self.view hideAfterDelay:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.toolBarView setHidden:NO];
    });
}

- (void)onClickedImageView
{
    BOOL hidden = self.navigationController.navigationBar.hidden;
    [self.navigationController setNavigationBarHidden:!hidden animated:YES];
}

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
    if (self.iconArray.count > 0)
    {
        for (HHIconView *iconView in self.iconArray)
        {
            [iconView removeFromSuperview];
        }
        self.iconArray = nil;
    }
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
    paletteView.panGesturesCallBack = ^(UIColor *mainColor)
    {
        for (UIImageView *appIcon in self.iconArray)
        {
            appIcon.layer.shadowColor = mainColor.CGColor;
        }
    };
    [self.view addSubview:paletteView];
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
