//
//  ViewController.m
//  Butter
//
//  Created by Kyle Lucovsky on 5/10/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "HomeViewController.h"
#import "ColorHelper.h"
#import "DataManager.h"
#import "Timer.h"
#import "TimerDisplayView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController ()
// views
@property (weak, nonatomic) CAGradientLayer *backgroundGradient;
@property (weak, nonatomic) IBOutlet UIButton *timerControl;
@property (weak, nonatomic) IBOutlet UIButton *clearTimer;
@property (weak, nonatomic) IBOutlet UIView *timerDisplayContainer;
@property (weak, nonatomic) TimerDisplayView *timerDisplayView;

// IBOutletCollections
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *timerButtons;

// utilities
@property (strong, nonatomic) NSTimer *intervalCounter;
@property (strong, nonatomic) Timer *timer;
@property (nonatomic) BOOL timerStarted;
@property (nonatomic) BOOL editing;
@property (assign) SystemSoundID butterBark;
@end

@implementation HomeViewController

#pragma mark - View Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Buttr";
    
    [self setupNavBar];
    [self setupBackgroundGradient];
    [self setupTimerDisplayView];
    [self setupTimerControls];
    [self setupNewTimer];
}

- (void)setupTimerDisplayView
{
    TimerDisplayView *timerDisplayView = [[[NSBundle mainBundle] loadNibNamed:@"TimerDisplayView" owner:nil options:nil] lastObject];
    [self.timerDisplayContainer addSubview:timerDisplayView];
    self.timerDisplayView = timerDisplayView;
    
    [self.timerDisplayContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.timerDisplayView
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.timerDisplayContainer
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:0]];
    
    [self.timerDisplayContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.timerDisplayView
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.timerDisplayContainer
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:0]];
    
    [self.timerDisplayContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.timerDisplayView
                                                                           attribute:NSLayoutAttributeLeading
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.timerDisplayContainer
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0
                                                                            constant:0]];
    
    [self.timerDisplayContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.timerDisplayView
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.timerDisplayContainer
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0
                                                                            constant:0]];

}

- (void)setupBackgroundGradient
{
    ColorHelper *colorHelper = [ColorHelper sharedInstance];
    CAGradientLayer *gradient = [colorHelper yellowGradient];
    gradient.frame = self.view.bounds;
    self.view.backgroundColor = [colorHelper lightYellow];
    [self.view.layer insertSublayer:gradient atIndex:0];
    self.backgroundGradient = gradient;
}

- (void)setupNavBar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Pacifico" size:21.0]}];
}

- (void)setupNewTimer
{
    DataManager *dataManager = [DataManager sharedInstance];
    self.timer = (Timer *)[NSEntityDescription insertNewObjectForEntityForName:@"Timer" inManagedObjectContext:dataManager.insertionContext];
}

- (void)setupTimerControls
{
    for (UIButton *button in self.timerButtons) {
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 2.0;
        button.layer.cornerRadius = 20.0;
    }
}

- (void)playButterBark
{
    NSString *butterPath = [[NSBundle mainBundle]
                            pathForResource:@"butter_bark" ofType:@"wav"];
    NSURL *butterUrl = [NSURL fileURLWithPath:butterPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)butterUrl, &_butterBark);
    AudioServicesPlaySystemSound(_butterBark);
    
    [self vibrate];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(killAlert) userInfo:nil repeats:NO];
}

- (void)vibrate
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

- (void)killAlert
{
    [self vibrate];
    AudioServicesDisposeSystemSoundID(_butterBark);
}

#pragma mark - Gestures and Events

- (void)timerFired:(NSTimer *)intervalCounter
{
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:self.timer.startTime];
    
    if (self.timerDisplayView.stopwatchMode) {
        NSInteger time = [self.timer.duration integerValue];
        [self.timerDisplayView renderTime:time];
        self.timer.duration = [NSNumber numberWithInteger:time + 1];
    } else {
        [self.timerDisplayView renderTime:([self.timer.duration integerValue] - secondsBetween)];
    }
    
    if ([self.timer.duration integerValue] > 0 && ([[NSNumber numberWithDouble:secondsBetween] intValue] >= [self.timer.duration integerValue])) {
        [self playButterBark];
        self.timer.duration = @0;
        [self stopTimer];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.backgroundGradient.frame = self.view.bounds;
}

- (void)startTimer
{
    if ([self.timer.duration isEqualToNumber:@0] && self.timerDisplayView.stopwatchMode == NO) {
        self.timerDisplayView.stopwatchMode = YES;
    }
    
    [self.timerControl setTitle:@"Pause" forState:UIControlStateNormal];
    self.timerStarted = YES;
    self.timer.startTime = [NSDate date];
    
    self.intervalCounter = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [self.intervalCounter fire];
}

- (void)stopTimer
{
    [self.timerControl setTitle:@"Start" forState:UIControlStateNormal];
    self.timerStarted = NO;
    
    [self.intervalCounter invalidate];
    self.intervalCounter = nil;
    
    if (![self.timer.duration isEqualToNumber:@0]) {
        self.timer.duration = [NSNumber numberWithInteger:[self.timerDisplayView getTimerDuration]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UITouch *touch = (UITouch *)obj;
        CGPoint touchPoint = [touch locationInView:self.timerDisplayView];
        
        if ([self.timerDisplayView pointInside:touchPoint withEvent:nil]) {
            [UIView animateWithDuration:0.125 animations:^{
                self.timerDisplayView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            }];
        }
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UITouch *touch = (UITouch *)obj;
        CGPoint touchPoint = [touch locationInView:self.timerDisplayView];
        
        [UIView animateWithDuration:0.125
                         animations:^{
                             self.timerDisplayView.transform = CGAffineTransformIdentity;
                         }];
        
        if ([self.timerDisplayView pointInside:touchPoint withEvent:nil]) {
            [UIView animateWithDuration:0.125
                             animations:^{
                                 if (!self.timerStarted && !self.editing && !self.timerDisplayView.stopwatchMode) {
                                    [self.timerDisplayView renderEditControls];
                                     self.editing = YES;
                                 }
                             }];
        }
    }];
}

- (IBAction)toggleTimer:(id)sender
{
    if (self.timerStarted) {
        [self stopTimer];
    } else {
        if (self.editing) {
            self.timer.duration = [NSNumber numberWithInteger:[self.timerDisplayView getTimerDuration]];
            [self.timerDisplayView renderTime:[self.timer.duration integerValue]];
            [self.timerDisplayView removeEditingControls];
            self.editing = NO;
        }
        
        [self startTimer];
    }
}

- (IBAction)clearTimer:(id)sender
{
    if (self.timerStarted) {
        [self stopTimer];
    }
    
    self.timer.duration = @0;
    [self.timerDisplayView renderTime:0];
    self.timerDisplayView.stopwatchMode = NO;
    
    if (self.editing) {
        [self.timerDisplayView removeEditingControls];
        self.editing = NO;
    }
}

@end
