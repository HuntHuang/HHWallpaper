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
#import "GPUImageGaussianBlurFilter.h"
#import "UIImage+QMUI.h"
#import "UIImage+ColorSelect.h"
#import "CommonTool.h"
#import "QMUITips.h"
#import "LDImagePicker.h"

@interface CustomViewController ()<LDImagePickerDelegate>

@property (nonatomic, weak) UIView *toolBarView;
@property (nonatomic, weak) UIView *dock;
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UIImageView *paletteView;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) NSMutableArray *iconArray;
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
    
    UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 0, 80, 40)];
    [iconBtn setTitle:@"特效icon" forState:UIControlStateNormal];
    [iconBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(onClickIcon) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:iconBtn];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 0, 40, 40)];
    [saveBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onClickedSave) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:saveBtn];
    
    UIButton *paletteBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 0, 40, 40)];
    [paletteBtn setImage:[UIImage imageNamed:@"palette"] forState:UIControlStateNormal];
    [paletteBtn addTarget:self action:@selector(onClickedPaletteView) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:paletteBtn];
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
        [self setupAppIconWithRow:[_row integerValue]];
        [aDialogViewController hide];
        [self onClickedPaletteView];
    }];
    [dialogViewController show];
}

- (void)onClickBackground
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
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
    [self.view addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePaletteView)];
    [_backgroundView addGestureRecognizer:tap];
    
    UIImageView *paletteView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 250, 240, 240)];
    [paletteView setImage:[UIImage imageNamed:@"pickerColorWheel"]];
    [_backgroundView addSubview:paletteView];
    _paletteView = paletteView;
}

- (void)removePaletteView
{
    [_backgroundView removeFromSuperview];
}

- (void)setBackgroundViewWithImage:(UIImage *)image
{
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 18;
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
    [bgImgView setImage:blurredImage];
    [bgImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    bgImgView.contentMode =  UIViewContentModeScaleAspectFill;
    bgImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    bgImgView.clipsToBounds  = YES;
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
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

- (void)setupAppIconWithRow:(NSInteger)row
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedImageView)];
    [self.view addGestureRecognizer:tap];
    
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < row; j++)
        {
            CGFloat iconLength = 57;
            CGFloat xMargin    = 37;
            CGFloat yMargin    = j > 0 ? 42 : 40;
            CGFloat xPosition  = xMargin*(i+1) + iconLength*i;
            CGFloat yPosition  = yMargin*(j+1) + iconLength*j;
            UIImageView *appIcon = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, iconLength, iconLength)];
            [appIcon setImage:[UIImage imageNamed:@"appIcon"]];
            appIcon.layer.shadowColor = self.mainColor.CGColor;//shadowColor阴影颜色
            appIcon.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
            appIcon.layer.shadowOpacity = 1;//阴影透明度，默认0
            appIcon.layer.shadowRadius = 3;//阴影半径，默认3
            
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
            appIcon.layer.shadowPath = path.CGPath;
            [self.view addSubview:appIcon];
            [self.iconArray addObject:appIcon];
        }
    }
    
//    CGFloat dockHeight = 96;
//    UIView *dock = [[UIView alloc] initWithFrame:CGRectMake(0, IPhoneHeight - dockHeight, IPhoneWidth, dockHeight)];
//    dock.backgroundColor = self.mainColor;
//    [self.view insertSubview:dock atIndex:1];
//    _dock = dock;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:_paletteView];
    self.mainColor = [_paletteView.image colorAtPixel:tempPoint];
    [_dock setBackgroundColor:self.mainColor];
    for (UIImageView *appIcon in self.iconArray)
    {
        appIcon.layer.shadowColor = self.mainColor.CGColor;//shadowColor阴影颜色
    }
}

#pragma mark - LDImagePickerDelegate
- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage
{
    [self setBackgroundViewWithImage:editedImage];
    [self setMainImageViewWithImage:editedImage];
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
