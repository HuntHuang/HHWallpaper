//
//  QDCollectionViewDemoCell.m
//  qmuidemo
//
//  Created by ZhoonChen on 15/9/24.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import "QDCollectionViewDemoCell.h"
#import "QMUICommonDefines.h"
#import "UILabel+QMUI.h"

#define UIColorTheme1 UIColorMake(239, 83, 98) // Grapefruit
#define UIColorTheme2 UIColorMake(254, 109, 75) // Bittersweet
#define UIColorTheme3 UIColorMake(255, 207, 71) // Sunflower
#define UIColorTheme4 UIColorMake(159, 214, 97) // Grass
#define UIColorTheme5 UIColorMake(63, 208, 173) // Mint
#define UIColorTheme6 UIColorMake(49, 189, 243) // Aqua
#define UIColorTheme7 UIColorMake(90, 154, 239) // Blue Jeans
#define UIColorTheme8 UIColorMake(172, 143, 239) // Lavender
#define UIColorTheme9 UIColorMake(238, 133, 193) // Pink Rose

@implementation QDCollectionViewDemoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 3;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [self randomThemeColor];
    
    if (self.sampleImage.length > 0)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
        [imageView setImage:[UIImage imageNamed:self.sampleImage]];
        [self.contentView addSubview:imageView];
    }
}

- (void)dealloc
{
    _sampleImage = nil;
}

- (UIColor *)randomThemeColor
{
    NSArray *themeColors = @[UIColorTheme1,
                             UIColorTheme2,
                             UIColorTheme3,
                             UIColorTheme4,
                             UIColorTheme5,
                             UIColorTheme6,
                             UIColorTheme7,
                             UIColorTheme8,
                             UIColorTheme9];
    return themeColors[arc4random() % 9];
}

@end
