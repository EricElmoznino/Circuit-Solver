//
//  EENode.h
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-08.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EENode : NSObject

@property (nonatomic) int nodeNumber;
@property (nonatomic) int totalNumberOfNodes;

@property (nonatomic, strong) NSMutableArray *branches;
@property (nonatomic, strong) NSMutableArray *linearEquation;
@property (nonatomic, strong) NSMutableDictionary *superNodeConnections;

- (instancetype)initWithNodeNumber:(int)nodeNumber totalNumberOfNodes:(int)totalNumberOfNodes;
- (void)constructEquation;
- (void)constructSupernodeConnections;

@end
