//
//  HHMainImageView.m
//  HHWallPaper
//
//  Created by 黄志航 on 2017/4/28.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "HHMainImageView.h"

@interface HHMainImageView ()
{
    CGPoint startPoint;
}
@end

@implementation HHMainImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        [self setLayerShadow];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        self.userInteractionEnabled = YES;
        [self setLayerShadow];
    }
    return self;
}

- (void)setLayerShadow
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 1;//阴影透明度，默认0
    self.layer.shadowRadius = 3;//阴影半径，默认3
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float x = self.bounds.origin.x;
    float y = self.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = self.bounds.origin;
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle  = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    CGPoint lddRight = CGPointMake(x+width , y+ height );
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:topLeft];
    //添加四个二元曲线
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self];
    startPoint = point;
    
    //该view置于最前
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - startPoint.x;
    float dy = point.y - startPoint.y;
    
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    
    /* 限制用户不可将视图托出屏幕 */
    float halfx = CGRectGetMidX(self.bounds);
    //x坐标左边界
    newcenter.x = MAX(halfx, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    
    //移动view
    self.center = newcenter;
}

@end
