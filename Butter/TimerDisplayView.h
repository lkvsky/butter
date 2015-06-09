//
//  TimerDisplayView.h
//  Butter
//
//  Created by Kyle Lucovsky on 6/8/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtrUnit) {
    ButtrSeconds,
    ButtrMinutes,
    ButterHours
};

@interface TimerDisplayView : UIView
- (void)renderTime:(NSInteger)time;
- (void)addTimeForType:(ButtrUnit)unit;
- (void)removeTimeForType:(ButtrUnit)unit;
@end
