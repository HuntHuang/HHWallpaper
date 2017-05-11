//
//  UIView+Layout.m
//  FTLibrary
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "UIView+Layout.h"


@implementation UIView (Layout)

- (void)removeSubviews {
	for(UIView *view in self.subviews) {
		[view removeFromSuperview];
	}
}

- (CGFloat)width {
	CGRect frame = [self frame];
	return frame.size.width;
}

- (void)setWidth:(CGFloat)value {
	CGRect frame = [self frame];
	frame.size.width = round(value);
	[self setFrame:frame];
}

- (CGFloat)height {
	CGRect frame = [self frame];
	return frame.size.height;	
}

- (void)setHeight:(CGFloat)value {
	CGRect frame = [self frame];
	frame.size.height = round(value);
	[self setFrame:frame];
}

- (CGFloat)bottomPosition {
	return ([self height] + [self yPosition]);
}

- (void)setSize:(CGSize)size {
	CGRect frame = [self frame];
	frame.size.width = round(size.width);
	frame.size.height = round(size.height);
	[self setFrame:frame];
}

- (CGSize)size {
	CGRect frame = [self frame];
	return frame.size;
}

- (CGPoint)origin {
	CGRect frame = [self frame];
	return frame.origin;
}

- (void)setOrigin:(CGPoint)point {
	CGRect frame = [self frame];
	frame.origin = point;
	[self setFrame:frame];
}

- (CGFloat)xPosition {
	CGRect frame = [self frame];
	return frame.origin.x;
}

- (CGFloat)yPosition {
	CGRect frame = [self frame];
	return frame.origin.y;	
}

- (CGFloat)baselinePosition {
	return [self yPosition] + [self height];
}

- (void)positionAtX:(CGFloat)xValue {
	CGRect frame = [self frame];
	frame.origin.x = round(xValue);
	[self setFrame:frame];
}

- (void)positionAtY:(CGFloat)yValue {
	CGRect frame = [self frame];
	frame.origin.y = round(yValue);
	[self setFrame:frame];
}

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue {
	CGRect frame = [self frame];
	frame.origin.x = round(xValue);
	frame.origin.y = round(yValue);
	[self setFrame:frame];
}

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withWidth:(CGFloat)width {
	CGRect frame = [self frame];
	frame.origin.x = round(xValue);
	frame.origin.y = round(yValue);
	frame.size.width = width;
	[self setFrame:frame];	
}

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withHeight:(CGFloat)height {
	CGRect frame = [self frame];
	frame.origin.x = round(xValue);
	frame.origin.y = round(yValue);
	frame.size.height = height;
	[self setFrame:frame];	
}

- (void)positionAtX:(CGFloat)xValue withHeight:(CGFloat)height {
	CGRect frame = [self frame];
	frame.origin.x = round(xValue);
	frame.size.height = height;
	[self setFrame:frame];	
}

- (void)centerInSuperView {
	CGFloat xPos = round((self.superview.frame.size.width - self.frame.size.width) / 2.0);
	CGFloat yPos = round((self.superview.frame.size.height - self.frame.size.height) / 2.0);	
	[self positionAtX:xPos andY:yPos];
}

- (void)aestheticCenterInSuperView {
	CGFloat xPos = round(([self.superview width] - [self width]) / 2.0);
	CGFloat yPos = round(([self.superview height] - [self height]) / 2.0) - ([self.superview height] / 8.0);
	[self positionAtX:xPos andY:yPos];	
}

- (void)bringToFront {
	[self.superview bringSubviewToFront:self];	
}

- (void)sendToBack {
	[self.superview sendSubviewToBack:self];	
}

//ZF

- (void)centerAtX{
    CGFloat xPos = round((self.superview.frame.size.width - self.frame.size.width) / 2.0);
    [self positionAtX:xPos];
}



- (void)centerAtXQuarter{
    CGFloat xPos = round((self.superview.frame.size.width / 4) - (self.frame.size.width / 2));
    [self positionAtX:xPos];    
}



- (void)centerAtX3Quarter{
    [self centerAtXQuarter];
    CGFloat xPos = round((self.superview.frame.size.width / 2) + self.frame.origin.x);
    [self positionAtX:xPos];
}


@end
