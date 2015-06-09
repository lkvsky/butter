//
//  AddTimerViewController.m
//  Butter
//
//  Created by Kyle Lucovsky on 5/10/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "EditTimerViewController.h"

@interface EditTimerViewController ()
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackgroundGradient];
    [self setupNavBar];
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


@end
