//
//  HHButton.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/3.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "HHButton.h"

@implementation HHButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupButton];
    }
    return self;
}

- (void)setupButton
{
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.buttonColor = [UIColor turquoiseColor];
    self.shadowColor = [UIColor greenSeaColor];
    self.shadowHeight = 3.0f;
    self.cornerRadius = 6.0f;
    [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
}

@end
