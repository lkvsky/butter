//
//  ColorHelper.m
//  Butter
//
//  Created by Kyle Lucovsky on 5/10/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "ColorHelper.h"

@implementation ColorHelper

+ (instancetype)sharedInstance;
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (CAGradientLayer *)yellowGradient
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    UIColor *lightColor = [UIColor colorWithRed:241.0/255.0 green:183.0/255.0 blue:40.0/255.0 alpha:1.0];
    UIColor *darkColor = [UIColor colorWithRed:239.0/255.0 green:165.0/255.0 blue:78.0/255.0 alpha:1.0];
    
    gradient.colors = @[(id)darkColor.CGColor, (id)lightColor.CGColor];
    gradient.locations = @[@0.0, @1.0];
    
    return gradient;
}

@end
