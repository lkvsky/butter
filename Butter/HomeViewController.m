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

@interface HomeViewController ()
// views
@property (weak, nonatomic) CAGradientLayer *backgroundGradient;
@property (weak, nonatomic) IBOutlet UIButton *timerControl;

// utilities
@property (strong, nonatomic) NSTimer *intervalCounter;
@property (strong, nonatomic) Timer *timer;
@property (nonatomic) BOOL timerStarted;
@property (nonatomic) BOOL editing;
@end

@implementation HomeViewController

#pragma mark - View Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Buttr";
    
    [self setupNavBar];
    [self setupBackgroundGradient];
    [self setupTimerControl];
    [self setupNewTimer];
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
    [self.timerDisplayView renderTime:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTimer:)];
    [self.timerDisplayView addGestureRecognizer:tap];
}

- (void)setupTimerControl
{
    self.timerControl.layer.borderColor = [UIColor blackColor].CGColor;
    self.timerControl.layer.borderWidth = 2.0;
    self.timerControl.layer.cornerRadius = 20.0;
}

#pragma mark - Gestures and Events

- (void)timerFired:(NSTimer *)intervalCounter
{
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:self.timer.startTime];
    
    if ([self.timer.duration isEqualToNumber:@0]) {
        [self.timerDisplayView renderTime:secondsBetween];
    } else {
        [self.timerDisplayView renderTime:([self.timer.duration integerValue] - secondsBetween)];
    }
    
    if ([self.timer.duration integerValue] > 0 && ([[NSNumber numberWithDouble:secondsBetween] intValue] >= [self.timer.duration integerValue])) {
        self.timer.duration = @0;
        [self stopTimer];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.backgroundGradient.frame = self.view.bounds;
}

- (void)editTimer:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.125
                     animations:^{
                         self.timerDisplayView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     }
                     completion:^(BOOL finished) {
                         self.timerDisplayView.transform = CGAffineTransformIdentity;
                         
                         if (self.timerStarted) return;
                         [self.timerDisplayView renderEditControls];
                         self.editing = YES;
                     }];
}

- (void)startTimer
{
    [self.timerControl setTitle:@"Pause" forState:UIControlStateNormal];
    self.timerStarted = YES;
    
    self.intervalCounter = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    self.timer.startTime = [NSDate date];
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

@end
