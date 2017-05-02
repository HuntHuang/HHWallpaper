//
//  CustomViewController.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/27.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "CustomViewController.h"
#import "QMUIModalPresentationViewController.h"
#import "QMUIDialogViewController.h"
#import "QMUITextField.h"
#import "HHMainImageView.h"
#import "HHIconView.h"
#import "GPUImage.h"
#import "UIImage+QMUI.h"
#import "UIImage+ColorSelect.h"
#import "CommonTool.h"
#import "QMUITips.h"
#import "LDImagePicker.h"

@interface CustomViewController ()<LDImagePickerDelegate>

@property (nonatomic, weak) UIView *toolBarView;
@property (nonatomic, weak) UIView *dock;
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIImageView *paletteView;
@property (nonatomic, weak) UISlider *blurSlider;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, strong) GPUImageGaussianBlurFilter *blurFilter;
@property (nonatomic, strong) GPUImagePicture *staticPicture;
@property (nonatomic, copy) NSString *row;

@end

@implementation CustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self setupToolBar];
}

- (void)dealloc
{
    _blurFilter = nil;
    _staticPicture = nil;
    _mainColor = nil;
    _iconArray = nil;
}

- (void)setupToolBar
{
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, IPhoneHeight - 50, IPhoneWidth, 50)];
    [self.view addSubview:toolView];
    _toolBarView = toolView;
    
    UIButton *backgroundBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    [backgroundBtn setTitle:@"设置背景" forState:UIControlStateNormal];
    [backgroundBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backgroundBtn addTarget:self action:@selector(onClickBackground) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:backgroundBtn];
    
    UIButton *mainImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 80, 40)];
    [mainImageBtn setTitle:@"设置小图" forState:UIControlStateNormal];
    [mainImageBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [mainImageBtn addTarget:self action:@selector(onClickMainImage) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:mainImageBtn];
    
    UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(190, 0, 80, 40)];
    [iconBtn setTitle:@"特效icon" forState:UIControlStateNormal];
    [iconBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(onClickIcon) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:iconBtn];
    
    UIButton *paletteBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 0, 40, 40)];
    [paletteBtn setImage:[UIImage imageNamed:@"palette"] forState:UIControlStateNormal];
    [paletteBtn addTarget:self action:@selector(onClickedPaletteView) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:paletteBtn];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(330, 0, 40, 40)];
    [saveBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onClickedSave) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:saveBtn];
}

- (void)setBackgroundViewWithImage:(UIImage *)image
{
    _staticPicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    GPUImageView *backgroundView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
    _blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [_blurFilter forceProcessingAtSize:backgroundView.sizeInPixels];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    [_blurFilter addTarget:backgroundView];
    [_staticPicture addTarget:_blurFilter];
    [_staticPicture processImage];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 50, IPhoneWidth-20, 50)];
    slider.maximumValue = 20;
    slider.minimumValue = 0;
    slider.value = 0;
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    _blurSlider = slider;
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
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < row; j++)
        {
            CGFloat iconLength = 57;
            CGFloat xMargin    = 37;
            CGFloat yMargin    = j > 0 ? 42 : 40;
            CGFloat xPosition  = xMargin*(i+1) + iconLength*i;
            CGFloat yPosition  = yMargin*(j+1) + iconLength*j;
            CGRect rect = CGRectMake(xPosition, yPosition, iconLength, iconLength);
            UIImage *shotImage = [UIImage qmui_imageWithView:self.view afterScreenUpdates:YES];
            UIImage *afterImage = [shotImage qmui_imageWithClippedRect:rect];
            UIImageView *appIcon = [[UIImageView alloc] initWithFrame:rect];
            [appIcon setImage:afterImage];
            appIcon.layer.masksToBounds = YES;
            appIcon.layer.cornerRadius = 10;
            
            UIView *shadow = [[UIView alloc] initWithFrame:rect];
            appIcon.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            shadow.layer.cornerRadius = 10;
            shadow.layer.shadowColor = self.mainColor.CGColor;//shadowColor阴影颜色
            shadow.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
            shadow.layer.shadowOpacity = 1;//阴影透明度，默认0
            shadow.layer.shadowRadius = 3;//阴影半径，默认3
            
            float width = appIcon.bounds.size.width;
            float height = appIcon.bounds.size.height;
            float x = appIcon.bounds.origin.x;
            float y = appIcon.bounds.origin.y;
            float addWH = 10;
            
            CGPoint topLeft      = appIcon.bounds.origin;
            CGPoint topRight     = CGPointMake(x+width,y);
            CGPoint topMiddle    = CGPointMake(x+(width/2),y-addWH);
            
            CGPoint rightMiddle  = CGPointMake(x+width+addWH,y+(height/2));
            
            CGPoint bottomRight  = CGPointMake(x+width,y+height);
            CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
            CGPoint bottomLeft   = CGPointMake(x,y+height);
            
            CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
            CGPoint lddRight = CGPointMake(x+width, y+height);
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:topLeft];
            //添加四个二元曲线
            [path addQuadCurveToPoint:topRight
                         controlPoint:topMiddle];
            
            [path addQuadCurveToPoint:topRight
                         controlPoint:lddRight];
            
            [path addQuadCurveToPoint:bottomRight
                         controlPoint:rightMiddle];
            
            [path addQuadCurveToPoint:bottomLeft
                         controlPoint:bottomMiddle];
            
            [path addQuadCurveToPoint:topLeft
                         controlPoint:leftMiddle];
            
            //设置阴影路径
            shadow.layer.shadowPath = path.CGPath;
            [shadow addSubview:appIcon];
            [self.view addSubview:shadow];
            [self.iconArray addObject:shadow];
        }
    }
    
    //    CGFloat dockHeight = 96;
    //    UIView *dock = [[UIView alloc] initWithFrame:CGRectMake(0, IPhoneHeight - dockHeight, IPhoneWidth, dockHeight)];
    //    dock.backgroundColor = self.mainColor;
    //    [self.view insertSubview:dock atIndex:1];
    //    _dock = dock;
}

#pragma mark - target action
- (void)onClickIcon
{
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入icon行数";
    dialogViewController.textField.placeholder = @"6";
    dialogViewController.textField.maximumTextLength = 1;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    dialogViewController.shouldEnableSubmitButtonBlock = ^BOOL(QMUIDialogTextFieldViewController *aDialogViewController) {
        _row = aDialogViewController.textField.text;
        return aDialogViewController.textField.text.length == aDialogViewController.textField.maximumTextLength;
    };
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
        [self setupAppIconWithRow:[_row integerValue]];
        [self onClickedPaletteView];
    }];
    [dialogViewController show];
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
    [imagePicker showImagePickerWithType:ImagePickerPhoto inViewController:self cropSize:CGSizeMake(IPhoneWidth, 260)];
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

- (void)onClickedPaletteView
{
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(50, 300, 300, 300)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    _coverView = whiteView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300-50, 300, 50)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removePaletteView) forControlEvents:UIControlEventTouchUpInside];
    [_coverView addSubview:btn];
    
    UIImageView *paletteView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
    [paletteView setImage:[UIImage imageNamed:@"pickerColorWheel"]];
    paletteView.multipleTouchEnabled = YES;
    paletteView.userInteractionEnabled = YES;
    [_coverView addSubview:paletteView];
    _paletteView = paletteView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePalettePan:)];
    [_paletteView addGestureRecognizer:pan];
}

- (void)sliderValueChanged:(UISlider *)sender
{
    [_blurFilter setBlurRadiusInPixels:sender.value];
    [_staticPicture processImage];
}

- (void)removePaletteView
{
    [_coverView removeFromSuperview];
}

- (void)handlePalettePan:(UIPanGestureRecognizer *)pan
{
    CGPoint tempPoint = [pan locationInView:_paletteView];
    self.mainColor = [_paletteView.image colorAtPixel:tempPoint];
    if (self.mainColor != nil)
    {
        [_dock setBackgroundColor:self.mainColor];
        for (UIImageView *appIcon in self.iconArray)
        {
            appIcon.layer.shadowColor = self.mainColor.CGColor;//shadowColor阴影颜色
        }
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

- (NSMutableArray *)iconArray
{
    if (!_iconArray)
    {
        _iconArray = [NSMutableArray array];
    }
    return _iconArray;
}
@end
