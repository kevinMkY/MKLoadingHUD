//
//  UIView+MKUIViewFrame.m
//  iYongche
//
//  Created by ykh on 16/2/18.
//  Copyright © 2016年 yongche. All rights reserved.
//

#import "UIView+MKUIViewFrame.h"

@implementation UIView (MKUIViewFrame)

- (void)setMk_x:(CGFloat)mk_x
{
    CGRect frame = self.frame;
    frame.origin.x = mk_x;
    self.frame = frame;
}

- (CGFloat)mk_x
{
    return self.frame.origin.x;
}

- (void)setMk_y:(CGFloat)mk_y
{
    CGRect frame = self.frame;
    frame.origin.y = mk_y;
    self.frame = frame;
}

- (CGFloat)mk_y
{
    return self.frame.origin.y;
}

- (void)setMk_width:(CGFloat)mk_w
{
    CGRect frame = self.frame;
    frame.size.width = mk_w;
    self.frame = frame;
}

- (CGFloat)mk_width
{
    return self.frame.size.width;
}

- (void)setMk_height:(CGFloat)mk_h
{
    CGRect frame = self.frame;
    frame.size.height = mk_h;
    self.frame = frame;
}

- (CGFloat)mk_height
{
    return self.frame.size.height;
}

- (CGFloat)mk_left {
    return self.frame.origin.x;
}

- (void)setMk_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)mk_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMk_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)mk_top {
    return self.frame.origin.y;
}

- (void)setMk_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)mk_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMk_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)mk_centerX {
    return self.center.x;
}

- (void)setMk_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)mk_centerY {
    return self.center.y;
}

- (void)setMk_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


@end
