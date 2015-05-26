//
//  Timer.h
//  Butter
//
//  Created by Kyle Lucovsky on 5/25/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Interval;

@interface Timer : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * cancelTime;
@property (nonatomic, retain) NSSet *intervals;
@end

@interface Timer (CoreDataGeneratedAccessors)

- (void)addIntervalsObject:(Interval *)value;
- (void)removeIntervalsObject:(Interval *)value;
- (void)addIntervals:(NSSet *)values;
- (void)removeIntervals:(NSSet *)values;

@end
