//
//  HHIconView.h
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/2.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHIconView : UIView

@property (nonatomic, strong) UIColor *mainColor;

- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view;

//- (void)setupAppIconWithView:(UIView *)view
//                      CGRect:(CGRect)rect;
@end
