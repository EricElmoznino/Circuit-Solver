//
//  EEBranch.m
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-08.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "EEBranch.h"

@implementation EEBranch

- (instancetype)initWithStartNode:(int)startNode
{
    self = [super init];
    
    if (self) {
        self.startNode = startNode;
        
        self.endNode = 0;
        self.independentCurrent = 0.0;
        self.independentVoltage = 0.0;
        self.resistance = 0.0;
        
        self.isSupernode = NO;
        
        NSUUID *uuid = [[NSUUID alloc] init];
        self.branchKey = [uuid UUIDString];
    }
    
    return self;
}

+ (instancetype)copyFromBranch:(EEBranch *)branch
{
    EEBranch *nodeBranch = [[EEBranch alloc] initWithStartNode:branch.startNode];
    nodeBranch.endNode = branch.endNode;
    nodeBranch.independentCurrent = branch.independentCurrent;
    nodeBranch.independentVoltage = branch.independentVoltage;
    nodeBranch.resistance = branch.resistance;
    
    if (nodeBranch.independentVoltage != 0 &&
        nodeBranch.resistance == 0 &&
        nodeBranch.independentCurrent == 0) {
        nodeBranch.isSupernode = true;
    }
    
    return nodeBranch;
}

+ (instancetype)reverseCopyFromBranch:(EEBranch *)branch
{
    EEBranch *nodeBranch = [[EEBranch alloc] initWithStartNode:branch.endNode];
    nodeBranch.endNode = branch.startNode;
    nodeBranch.independentCurrent = -branch.independentCurrent;
    nodeBranch.independentVoltage = -branch.independentVoltage;
    nodeBranch.resistance = branch.resistance;
    
    if (nodeBranch.independentVoltage != 0 &&
        nodeBranch.resistance == 0 &&
        nodeBranch.independentCurrent == 0) {
        nodeBranch.isSupernode = true;
    }
    
    return nodeBranch;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.startNode forKey:@"startNode"];
    [aCoder encodeInt:self.endNode forKey:@"endNode"];
    [aCoder encodeDouble:self.independentCurrent forKey:@"independentCurrent"];
    [aCoder encodeDouble:self.independentVoltage forKey:@"independentVoltage"];
    [aCoder encodeDouble:self.resistance forKey:@"resistance"];
    [aCoder encodeBool:self.isSupernode forKey:@"isSupernode"];
    [aCoder encodeObject:self.branchKey forKey:@"branchKey"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.startNode = [aDecoder decodeIntForKey:@"startNode"];
        self.endNode = [aDecoder decodeIntForKey:@"endNode"];
        self.independentCurrent = [aDecoder decodeDoubleForKey:@"independentCurrent"];
        self.independentVoltage = [aDecoder decodeDoubleForKey:@"independentVoltage"];
        self.resistance = [aDecoder decodeDoubleForKey:@"resistance"];
        self.isSupernode = [aDecoder decodeBoolForKey:@"isSupernode"];
        self.branchKey = [aDecoder decodeObjectForKey:@"branchKey"];
    }
    
    return self;
}

@end
