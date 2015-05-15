//
//  ViewController.m
//  Butter
//
//  Created by Kyle Lucovsky on 5/10/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "HomeViewController.h"
#import "ColorHelper.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addTimerButton;
@end

@implementation HomeViewController

- (IBAction)touchAddTimerButton:(UIButton *)sender
{
    
}

- (void)setBackgroundGradient
{
    CAGradientLayer *gradient = [[ColorHelper sharedInstance] yellowGradient];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [self setBackgroundGradient];
}

@end
