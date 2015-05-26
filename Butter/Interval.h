//
//  Interval.h
//  Butter
//
//  Created by Kyle Lucovsky on 5/25/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Timer;

@interface Interval : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) Timer *timer;

@end
