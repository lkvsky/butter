//
//  DataManager.h
//  Butter
//
//  Created by Kyle Lucovsky on 5/15/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *insertionContext;
@property (nonatomic, strong) NSManagedObjectContext *readingContext;

+ (instancetype)sharedInstance;
- (NSArray *)doFetchRequestForEntityWithName:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors withBatchSize:(NSNumber *)batchSize;
@end
