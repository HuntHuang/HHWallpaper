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

- (void)setupAppIconWithView:(UIView *)view
                        rect:(CGRect)rect;

@end
