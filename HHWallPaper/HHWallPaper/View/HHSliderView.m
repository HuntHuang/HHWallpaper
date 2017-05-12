//
//  HHSliderView.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/12.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "HHSliderView.h"
#import "HHButton.h"
#import "UIColor+FlatUI.h"
#import "UISlider+FlatUI.h"

@implementation HHSliderView

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor silverColor];
    
    HHButton *sureBtn = [[HHButton alloc] initWithFrame:CGRectMake(self.width - 40, 5, 30, 30)];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    HHButton *closeBtn = [[HHButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.width, 30)];
    titleLabel.text = @"高斯模糊度";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor midnightBlueColor];
    [self addSubview:titleLabel];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 100, IPhoneWidth-20, 40)];
    slider.maximumValue = 20;
    slider.minimumValue = 0;
    slider.value = 0;
    slider.continuous = YES;
    [slider configureFlatSliderWithTrackColor:[UIColor emerlandColor]
                                progressColor:[UIColor alizarinColor]
                                   thumbColor:[UIColor pomegranateColor]];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    
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

- (void)sliderValueChanged:(UISlider *)sender
{
    if (self.sliderCallback)
    {
        self.sliderCallback(sender.value);
    }
}

@end
