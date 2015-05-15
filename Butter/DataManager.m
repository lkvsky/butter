//
//  DataManager.m
//  Butter
//
//  Created by Kyle Lucovsky on 5/15/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (instancetype)sharedInstance
{
    static DataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    
    return dataManager;
}

@synthesize insertionContext = _insertionContext;
@synthesize readingContext = _readingContext;

- (NSManagedObjectContext *)insertionContext
{
    if (_insertionContext == nil) {
        _insertionContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_insertionContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [_insertionContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    
    return _insertionContext;
}

- (NSManagedObjectContext *)readingContext
{
    if (_readingContext == nil) {
        _readingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_readingContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [_readingContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    
    return _readingContext;
}

#pragma mark - Create / Update Data

- (NSFetchRequest *)createFetchRequestForEntityWithName:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors withBatchSize:(NSNumber *)batchSize
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_readingContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    
    if (nil != predicate) {
        fetchRequest.predicate = predicate;
    }
    
    if (nil != sortDescriptors) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    if (nil != batchSize) {
        fetchRequest.fetchBatchSize = (int)batchSize;
    }
    
    return fetchRequest;
}


- (NSArray *)doFetchRequestForEntityWithName:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors withBatchSize:(NSNumber *)batchSize
{
    NSFetchRequest *fetchRequest = [self createFetchRequestForEntityWithName:entityName withPredicate:predicate withSortDescriptors:sortDescriptors withBatchSize:batchSize];
    NSError *error;
    NSArray *results = [_readingContext executeFetchRequest:fetchRequest error:&error];
    
    if (nil != results) {
        return results;
    } else {
        //handle error - this is for debug only
        NSLog(@"%@ %@", error, error.localizedDescription);
        abort();
    }
}
@end
