//
//  EEBranch.h
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-08.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEBranch : NSObject
<NSCoding>

@property (nonatomic, strong) NSString *branchKey;

@property (nonatomic) int startNode;
@property (nonatomic) int endNode;

@property (nonatomic) double independentCurrent;
@property (nonatomic) double independentVoltage;
@property (nonatomic) double resistance;

@property (nonatomic) BOOL isSupernode;

- (instancetype)initWithStartNode:(int)startNode;
+ (instancetype)copyFromBranch:(EEBranch *)branch;
+ (instancetype)reverseCopyFromBranch:(EEBranch *)branch;

@end
