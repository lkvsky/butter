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
#import "AddTimerViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) CAGradientLayer *backgroundGradient;
@property (strong, nonatomic) NSArray *timers;
@end

@implementation HomeViewController


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
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tapPlus)];
    self.navigationItem.rightBarButtonItem = plusButton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Pacifico" size:21.0]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Buttr";

    [self setupNavBar];
    [self setupBackgroundGradient];
    
    self.timers = [[DataManager sharedInstance] doFetchRequestForEntityWithName:@"Timer" withPredicate:nil withSortDescriptors:nil withBatchSize:@5];
}

#pragma mark - Gestures and Events

- (IBAction)tapPlus
{
    AddTimerViewController *addTimerVC = [[AddTimerViewController alloc] initWithNibName:@"AddTimerViewController" bundle:nil];
    [self showViewController:addTimerVC sender:self];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.backgroundGradient removeFromSuperlayer];
    self.backgroundGradient = nil;
    [self setupBackgroundGradient];
}

@end
