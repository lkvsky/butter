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
@property (weak, nonatomic) IBOutlet UIView *labelContainer;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;

// IBOutletCollections
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"stopwatchMode"];
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor clearColor];
    self.multipleTouchEnabled = YES;
    
    [self addObserver:self forKeyPath:@"stopwatchMode" options:0 context:nil];
    
    for (UIButton *button in self.buttons) {
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.cornerRadius = 15;
        button.layer.opacity = 0;
    }
}

#pragma mark - Gestures and Events

- (IBAction)addControlTapped:(UIButton *)button
{
    [self updateTime:1 forType:button.tag];
}

- (IBAction)minusControlTapped:(UIButton *)button
{
    [self updateTime:-1 forType:button.tag];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"stopwatchMode"]) {
        if (self.stopwatchMode) {
            [self renderStopwatchMode];
        } else {
            [self renderCountdownMode];
        }
    }
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

- (void)renderStopwatchMode
{
    for (UILabel *label in self.labels) {
        label.textColor = [UIColor whiteColor];
    }
}

- (void)renderCountdownMode
{
    for (UILabel *label in self.labels) {
        label.textColor = [UIColor blackColor];
    }
}

#pragma mark - Public Methods

- (void)renderEditControls
{
    for (UIButton *button in self.buttons) {
        button.layer.opacity = 1;
    }
}

- (void)removeEditingControls
{
    for (UIButton *button in self.buttons) {
        button.layer.opacity = 0;
    }
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
