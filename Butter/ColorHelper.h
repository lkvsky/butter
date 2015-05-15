//
//  ColorHelper.h
//  Butter
//
//  Created by Kyle Lucovsky on 5/10/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ColorHelper : NSObject
+ (instancetype)sharedInstance;
- (CAGradientLayer *)yellowGradient;
@end
