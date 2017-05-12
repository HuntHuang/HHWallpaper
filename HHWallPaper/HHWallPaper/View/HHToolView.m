//
//  HHToolView.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/12.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "HHToolView.h"
#import "HHButton.h"

@implementation HHToolView

- (void)layoutSubviews
{
    NSArray *titleArray = @[@"背景图片", @"背景颜色", @"相框图片", @"特效icon", @"保存"];
    for (int i = 0; i < 5; i++)
    {
        HHButton *button = [[HHButton alloc] initWithFrame:CGRectMake(10 + i*80, 0, 70, 40)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(onClickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)onClickedButton:(UIButton *)sender
{
    if (self.buttonCallback)
    {
        self.buttonCallback(sender.tag, self);
    }
}

@end
