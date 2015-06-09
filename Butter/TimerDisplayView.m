//
//  TimerDisplayView.m
//  Butter
//
//  Created by Kyle Lucovsky on 6/8/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "TimerDisplayView.h"

#define kLabelCenterOffset 120

@interface TimerDisplayView()

// sub-views
@property (weak, nonatomic) UILabel *secondsLabel;
@property (weak, nonatomic) UILabel *minutesLabel;
@property (weak, nonatomic) UILabel *hoursLabel;

// metadata
@property (nonatomic) NSInteger seconds;
@property (nonatomic) NSInteger minutes;
@property (nonatomic) NSInteger hours;
@end

@implementation TimerDisplayView

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    [self setup];
    
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor clearColor];
    [self setupTimerLabel];
}

- (void)setupTimerLabel
{
    // initialize labels
    UILabel *secondsLabel = [[UILabel alloc] init];
    UILabel *minutesLabel = [[UILabel alloc] init];
    UILabel *hoursLabel = [[UILabel alloc] init];
    
    // initialize dividers
    UILabel *leftDivider = [[UILabel alloc] init];
    UILabel *rightDivider = [[UILabel alloc] init];
    leftDivider.text = @":";
    rightDivider.text = @":";
    
    // add general attributes and vertically center
    for (UILabel *label in @[secondsLabel, minutesLabel, hoursLabel, leftDivider, rightDivider]) {
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.font = [UIFont fontWithName:@"SanFranciscoText-Regular" size:80];
        [self addSubview:label];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
    }
    
    // store weak references
    self.secondsLabel = secondsLabel;
    self.minutesLabel = minutesLabel;
    self.hoursLabel = hoursLabel;
    
    // apply horizontal center constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:secondsLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:kLabelCenterOffset]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:minutesLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:hoursLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:-kLabelCenterOffset]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:leftDivider
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:-kLabelCenterOffset / 2]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:rightDivider
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:kLabelCenterOffset / 2]];
}

#pragma mark - Time Management Helpers

- (void)updateTime:(NSInteger)timeDifference forType:(ButtrUnit)unit
{
    switch (unit) {
        case ButtrSeconds:
            self.seconds += timeDifference;
            break;
            
        case ButtrMinutes:
            self.minutes += timeDifference;
            
        case ButterHours:
            self.hours += timeDifference;
            
        default:
            break;
    }
    
    [self updateTimerLabel];
}

- (void)updateTimerLabel
{
    self.secondsLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.seconds];
    self.minutesLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.minutes];
    self.hoursLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.hours];
}

#pragma mark - Public Methods

- (void)renderTime:(NSInteger)time
{
    self.seconds = time % 60;
    self.minutes = (time / 60) % 60;
    self.hours = (time / 3600);
    
    [self updateTimerLabel];
}

- (void)addTimeForType:(ButtrUnit)unit;
{
    [self updateTime:1 forType:unit];
}

- (void)removeTimeForType:(ButtrUnit)unit;
{
    [self updateTime:-1 forType:unit];
}

@end
