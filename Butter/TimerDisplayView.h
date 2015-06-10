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
    ButtrHours
};

@interface TimerDisplayView : UIView
- (void)renderEditControls;
- (void)removeEditingControls;
- (void)renderTime:(NSInteger)time;
- (NSInteger)getTimerDuration;
@end
