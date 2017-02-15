//
//  EEBranchesStore.h
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-09.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEBranch.h"

@interface EEBranchesStore : NSObject

@property (nonatomic,readonly)NSArray *allBranches;

+ (instancetype)sharedStore;
- (void)addBranch:(EEBranch *)branch;
- (void)removeBranch:(EEBranch *)branch;

- (void)saveChanges;

@end
