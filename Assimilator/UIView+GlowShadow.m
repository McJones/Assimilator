//
//  UIView+GlowShadow.m
//  Assimilator
//
//  Created by Tim Nugent on 17/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

#import "UIView+GlowShadow.h"

@implementation UIView(GlowShadow)

- (void)addGlowShadow
{
    [self addGlowShadowWithColour:[UIColor cyanColor] Rasterise:NO];
}
- (void)addGlowShadowWithColour:(UIColor *)colour
{
    [self addGlowShadowWithColour:colour Rasterise:NO];
}
- (void)addGlowShadowWithColour:(UIColor *)colour Rasterise:(BOOL)shouldRasterise
{
    self.layer.shouldRasterize = shouldRasterise;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.layer.shadowColor = colour.CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 1.f;
    self.layer.shadowRadius = 3.f;
}
- (void)addGlowShadowAndRasterise:(BOOL)shouldRasterise
{
    [self addGlowShadowWithColour:[UIColor cyanColor] Rasterise:shouldRasterise];
}

@end
