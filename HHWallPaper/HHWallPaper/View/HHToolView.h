//
//  HHToolView.h
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/12.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHToolView : UIScrollView

@property (nonatomic, copy) void(^buttonCallback)(NSInteger tag, UIView *toolView);

@end
