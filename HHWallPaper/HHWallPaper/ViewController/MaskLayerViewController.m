//
//  MaskLayerViewController.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/20.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "MaskLayerViewController.h"
#import "UIImage+QMUI.h"
#import "QMUITips.h"

@interface MaskLayerViewController ()

@property (nonatomic, strong) UIImage *mainImage;
@property (nonatomic, weak) UIButton *saveBtn;

@end

@implementation MaskLayerViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedImageView)];
    [self.view addGestureRecognizer:tap];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IPhoneWidth, IPhoneHeight)];
    [backgroundImage setImage:self.mainImage];
    [self.view addSubview:backgroundImage];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(10, 25, IPhoneWidth-20, IPhoneHeight-30-96-15)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.3;
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 10.0;
    [self.view addSubview:whiteView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, whiteView.bounds.size.width-10, whiteView.bounds.size.height-10)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.2;
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 10.0;
    [whiteView addSubview:backView];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, IPhoneHeight - 50, 40, 40)];
    [saveBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onClickedSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    _saveBtn = saveBtn;
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

@end
