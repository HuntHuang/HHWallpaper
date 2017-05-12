//
//  HHPaletteView.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/11.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "HHPaletteView.h"
#import "UIColor+FlatUI.h"
#import "UIImage+ColorSelect.h"
#import "HHButton.h"

@interface HHPaletteView ()

@property (nonatomic, weak) UIImageView *paletteView;

@end

@implementation HHPaletteView

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor concreteColor];
    
    HHButton *sureBtn = [[HHButton alloc] initWithFrame:CGRectMake(self.width - 40, 10, 30, 30)];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    HHButton *closeBtn = [[HHButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];

    CGFloat xPostion = (self.width - 240)/2;
    UIImageView *paletteView = [[UIImageView alloc] initWithFrame:CGRectMake(xPostion, self.height-250, 240, 240)];
    [paletteView setImage:[UIImage imageNamed:@"pickerColorWheel"]];
    paletteView.multipleTouchEnabled = YES;
    paletteView.userInteractionEnabled = YES;
    [self addSubview:paletteView];
    _paletteView = paletteView;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePalettePan:)];
    [_paletteView addGestureRecognizer:pan];
    
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf positionAtY:IPhoneHeight - weakSelf.height];
    }];
}

- (void)removeView
{
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf positionAtY:IPhoneHeight];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)handlePalettePan:(UIPanGestureRecognizer *)pan
{
    CGPoint tempPoint = [pan locationInView:_paletteView];
    UIColor *mainColor = [_paletteView.image colorAtPixel:tempPoint];
    if (mainColor != nil && self.panGesturesCallBack)
    {
        self.panGesturesCallBack(mainColor);
    }
}

@end
