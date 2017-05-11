//
//  HHPaletteView.h
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/11.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPaletteView : UIView

@property (nonatomic, copy) void(^panGesturesCallBack)(UIColor *color);

@end
