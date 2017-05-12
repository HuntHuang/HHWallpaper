//
//  HHSliderView.h
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/12.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSliderView : UIView

@property (nonatomic, copy) void(^sliderCallback)(float value);

@end
