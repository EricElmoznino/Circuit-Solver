//
//  EEBranchesStore.m
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-09.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "EEBranchesStore.h"
#import "EEBranch.h"

@interface EEBranchesStore()

@property (nonatomic) NSMutableArray *privateBranches;

@end


@implementation EEBranchesStore

+ (instancetype)sharedStore
{
    static EEBranchesStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[EEBranchesStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        NSString *path = [self branchArchivePath];
        _privateBranches = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_privateBranches) {
            _privateBranches = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allBranches
{
    return self.privateBranches;
}

- (void)addBranch:(EEBranch *)branch
{
    [self.privateBranches addObject:branch];
}

- (void)removeBranch:(EEBranch *)branch
{
    [self.privateBranches removeObjectIdenticalTo:branch];
}

- (NSString *)branchArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"branches.archive"];
}

- (void)saveChanges
{
    NSString *path = [self branchArchivePath];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:_privateBranches toFile:path];
    
    if (!success) {
        NSLog(@"Error: Could not save the EEBranches");
    }
}

@end
