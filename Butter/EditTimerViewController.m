//
//  AddTimerViewController.m
//  Butter
//
//  Created by Kyle Lucovsky on 5/10/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "EditTimerViewController.h"
#import "TimerDisplayView.h"
#import "ColorHelper.h"
#import "Timer.h"

@interface EditTimerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *timerControl;
@property (weak, nonatomic) CAGradientLayer *backgroundGradient;
@end

@implementation EditTimerViewController

#pragma mark - View Initialization

- (void)setupBackgroundGradient
{
    CAGradientLayer *gradient = [[ColorHelper sharedInstance] yellowGradient];
    gradient.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
    self.backgroundGradient = gradient;
}

- (void)setupNavBar
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-left-blue.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)setupTimer
{
    [self.timerDisplayView renderTime:0];
    [self.timerDisplayView renderEditControls];
    
    self.timerControl.layer.borderColor = [UIColor blackColor].CGColor;
    self.timerControl.layer.borderWidth = 2.0;
    self.timerControl.layer.cornerRadius = 20.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackgroundGradient];
    [self setupNavBar];
    [self setupTimer];
}

#pragma mark - Gestures and Events

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.backgroundGradient removeFromSuperlayer];
    self.backgroundGradient = nil;
    [self setupBackgroundGradient];
}

- (IBAction)startTimer:(id)sender
{
    self.timer.duration = [NSNumber numberWithInteger:[self.timerDisplayView getTimerDuration]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
