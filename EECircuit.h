//
//  EECircuit.h
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-08.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EECircuit : NSObject

@property (nonatomic) int totalNumberOfNodes;

@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, strong) NSMutableDictionary *linearSystem;

//Keeps track of what rows in linearSystem correspond to supernode equations and the nodes that are part of it.
@property (nonatomic, strong) NSMutableDictionary *supernodes;

- (instancetype)initWithTotalNumberOfNodes:(int)totalNumberOfNodes;
- (void)constructSystem;
- (void)fixSystemForSupernodes;
- (NSMutableArray *)solveLinearSystem:(NSMutableDictionary *)linearSystem;

@end
