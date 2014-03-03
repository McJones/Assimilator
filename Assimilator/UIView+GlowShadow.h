//
//  UIView+GlowShadow.h
//  Assimilator
//
//  Created by Tim Nugent on 17/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GlowShadow)

- (void)addGlowShadow;
- (void)addGlowShadowWithColour:(UIColor *)colour;
- (void)addGlowShadowAndRasterise:(BOOL)shouldRasterise;
- (void)addGlowShadowWithColour:(UIColor *)colour Rasterise:(BOOL)shouldRasterise;

@end
