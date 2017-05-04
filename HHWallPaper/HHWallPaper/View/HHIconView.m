//
//  HHIconView.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/5/2.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "HHIconView.h"
#import "UIImage+QMUI.h"

@interface HHIconView ()

@end

@implementation HHIconView

- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupAppIconWithView:view CGRect:frame];
    }
    return self;
}

- (void)setupAppIconWithView:(UIView *)view
                      CGRect:(CGRect)rect
{
    UIImage *shotImage = [UIImage qmui_imageWithView:view afterScreenUpdates:YES];
    UIImage *afterImage = [shotImage qmui_imageWithClippedRect:rect];
    UIImageView *appIcon = [[UIImageView alloc] initWithFrame:rect];
    [appIcon setImage:afterImage];
    appIcon.layer.masksToBounds = YES;
    appIcon.layer.cornerRadius = 10;
    
    self.frame = rect;
    appIcon.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.layer.cornerRadius = 10;
    self.layer.shadowColor = [UIColor redColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 1;//阴影透明度，默认0
    self.layer.shadowRadius = 3;//阴影半径，默认3
    
    float width = appIcon.bounds.size.width;
    float height = appIcon.bounds.size.height;
    float x = appIcon.bounds.origin.x;
    float y = appIcon.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = appIcon.bounds.origin;
    CGPoint topRight     = CGPointMake(x+width,y);
    CGPoint topMiddle    = CGPointMake(x+(width/2),y-addWH);
    
    CGPoint rightMiddle  = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    CGPoint lddRight = CGPointMake(x+width, y+height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    
    [path addQuadCurveToPoint:topRight
                 controlPoint:lddRight];
    
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
    [self addSubview:appIcon];
}

@end
