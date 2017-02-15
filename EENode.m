//
//  EENode.m
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-08.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "EENode.h"
#import "EEBranch.h"

@implementation EENode

- (instancetype)initWithNodeNumber:(int)nodeNumber totalNumberOfNodes:(int)totalNumberOfNodes
{
    self = [super init];
    
    if (self) {
        self.nodeNumber = nodeNumber;
        self.totalNumberOfNodes = totalNumberOfNodes;
        
        self.branches = [[NSMutableArray alloc] init];
        self.superNodeConnections = [[NSMutableDictionary alloc] init];
        
        self.linearEquation = [[NSMutableArray alloc] init];
        for (int i=0; i<=totalNumberOfNodes; i++) {
            [self.linearEquation addObject:@0];
        }
    }
    
    return self;
}

- (void)constructEquation
{
    int totalNumberOfNodes = self.totalNumberOfNodes;
    NSMutableArray *linearEquation = self.linearEquation;
    
    for (int i=0; i<[self.branches count]; i++) {
        EEBranch *branch = self.branches[i];
        if (branch.isSupernode) {
            ;
        }
        else if (branch.independentCurrent) {
            NSNumber *value = linearEquation[totalNumberOfNodes];
            double doubleValue = [value doubleValue];
            doubleValue += -branch.independentCurrent;
            linearEquation[totalNumberOfNodes] = [NSNumber numberWithDouble:doubleValue];
        }
        else {
            NSNumber *value = linearEquation[branch.startNode];
            double doubleValue = [value doubleValue];
            doubleValue += 1.0 / branch.resistance;
            linearEquation[branch.startNode] = [NSNumber numberWithDouble:doubleValue];
            
            value = linearEquation[branch.endNode];
            doubleValue = [value doubleValue];
            doubleValue += -1.0 / branch.resistance;
            linearEquation[branch.endNode] = [NSNumber numberWithDouble:doubleValue];
            
            value = linearEquation[totalNumberOfNodes];
            doubleValue = [value doubleValue];
            doubleValue += -branch.independentVoltage / branch.resistance;
            linearEquation[totalNumberOfNodes] = [NSNumber numberWithDouble:doubleValue];
        }
    }
}

- (void)constructSupernodeConnections
{
    for (EEBranch *branch in self.branches) {
        if (branch.isSupernode) {
            [self.superNodeConnections setObject:[NSNumber numberWithDouble:branch.independentVoltage]
                                          forKey:[NSNumber numberWithInt:branch.endNode]];
        }
    }
}

@end
