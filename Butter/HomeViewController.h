//
//  ViewController.h
//  Butter
//
//  Created by Kyle Lucovsky on 5/10/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerDisplayView;

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet TimerDisplayView *timerDisplayView;
@end

