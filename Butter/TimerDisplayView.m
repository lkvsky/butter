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
@property (weak, nonatomic) UIView *secondsControl;
@property (weak, nonatomic) UIView *minutesControl;
@property (weak, nonatomic) UIView *hoursControl;

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
                                                          constant:-20]];
    }
    
    // store weak references
    self.secondsLabel = secondsLabel;
    self.minutesLabel = minutesLabel;
    self.hoursLabel = hoursLabel;
    
    // apply horizontal center constraints for labels
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
    
    // apply horizontal center constraints for dividers
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

- (UIView *)createEditControlsForType:(ButtrUnit)unit
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *subtractButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIView *buttonContainer = [[UIView alloc] init];
    
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [subtractButton setTitle:@"-" forState:UIControlStateNormal];
    
    [addButton addTarget:self action:@selector(addControlTapped:) forControlEvents:UIControlEventTouchUpInside];
    [subtractButton addTarget:self action:@selector(subtractControlTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    for (UIButton *button in @[subtractButton, addButton]) {
        [buttonContainer addSubview:button];
        button.tag = unit;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.layer.cornerRadius = 15;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 1;
        
        [buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:buttonContainer
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:0.5
                                                                     constant:-1]];
        
        [buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:buttonContainer
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0]];
        
        [buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:buttonContainer
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0]];
    }
    
    [buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:subtractButton
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:buttonContainer
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:0]];
    
    [buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:addButton
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:buttonContainer
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0
                                                                 constant:0]];
    
    return buttonContainer;
}

#pragma mark - Gestures and Events

- (void)addControlTapped:(UIButton *)button
{
    [self updateTime:1 forType:button.tag];
}

- (void)subtractControlTapped:(UIButton *)button
{
    [self updateTime:-1 forType:button.tag];
}

#pragma mark - Time Management Helpers

- (void)updateTime:(NSInteger)timeDifference forType:(ButtrUnit)unit
{
    switch (unit) {
        case ButtrSeconds:
            self.seconds += timeDifference;
            self.seconds = [self adjustUnit:self.seconds toLimit:59];
            break;
            
        case ButtrMinutes:
            self.minutes += timeDifference;
            self.minutes = [self adjustUnit:self.minutes toLimit:59];
            break;
            
        case ButtrHours:
            self.hours += timeDifference;
            self.hours = [self adjustUnit:self.hours toLimit:23];
            break;
            
        default:
            break;
    }
    
    [self updateTimerLabel];
}

- (NSInteger)adjustUnit:(NSInteger)unit toLimit:(NSInteger)limit
{
    if (unit < 0) {
        return limit;
    } else if (unit > limit) {
        return 0;
    } else {
        return unit;
    }
}

- (void)updateTimerLabel
{
    self.secondsLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.seconds];
    self.minutesLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.minutes];
    self.hoursLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.hours];
}

#pragma mark - Public Methods

- (void)renderEditControls
{
    UIView *secondsControl = [self createEditControlsForType:ButtrSeconds];
    UIView *minutesControl = [self createEditControlsForType:ButtrMinutes];
    UIView *hoursControl = [self createEditControlsForType:ButtrHours];

    for (UIView *controls in @[secondsControl, minutesControl, hoursControl]) {
        controls.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:controls];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:controls
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:kLabelCenterOffset/3]];
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:secondsControl
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:kLabelCenterOffset]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:minutesControl
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:hoursControl
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:-kLabelCenterOffset]];
    
    self.secondsControl = secondsControl;
    self.minutesControl = minutesControl;
    self.hoursControl = hoursControl;
}

- (void)removeEditingControls
{
    [self.secondsControl removeFromSuperview];
    [self.minutesControl removeFromSuperview];
    [self.hoursControl removeFromSuperview];
}

- (void)renderTime:(NSInteger)time
{
    self.seconds = time % 60;
    self.minutes = (time / 60) % 60;
    self.hours = (time / 3600);
    
    [self updateTimerLabel];
}

- (NSInteger)getTimerDuration
{
    return (self.seconds + (self.minutes * 60) + (self.hours * 3600));
}

@end
