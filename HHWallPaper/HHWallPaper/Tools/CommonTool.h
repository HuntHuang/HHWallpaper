//
//  CommonTool.h
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/11.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

+ (void)screenShots;

+ (BOOL)isIPhone5Screen;  // ip5 ip5s ip6放大模式
+ (BOOL)isIPhone6Screen;  // ip6
+ (BOOL)isIPhone6pScreen;  // ip6p

@end
