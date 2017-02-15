//
//  EECircuit.m
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-08.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "EECircuit.h"
#import "EENode.h"

@implementation EECircuit

- (instancetype)initWithTotalNumberOfNodes:(int)totalNumberOfNodes
{
    self = [super init];
    
    if (self) {
        self.totalNumberOfNodes = totalNumberOfNodes;
        
        self.nodes = [[NSMutableArray alloc] init];
        for (int i=0; i<totalNumberOfNodes; i++) {
            EENode *node = [[EENode alloc] initWithNodeNumber:i totalNumberOfNodes:totalNumberOfNodes];
            [self.nodes addObject:node];
        }
        
        self.linearSystem = [[NSMutableDictionary alloc] init];
        self.supernodes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)constructSystem
{
    for (int i=0; i<self.totalNumberOfNodes; i++) {
        EENode *node = self.nodes[i];
        NSMutableArray *linearEquation = node.linearEquation;
        [self.linearSystem setObject:linearEquation
                   forKeyedSubscript:[NSNumber numberWithInt:i]];
    }
}

- (void)fixSystemForSupernodes
{
    for (EENode *node in self.nodes) {
        int startNode = node.nodeNumber;
        
        for (NSNumber *endNodeNumber in [node.superNodeConnections allKeys]) {
            int endNode = [endNodeNumber intValue];
            
            int flag = [self searchSupernodes:self.supernodes
                                 forStartNode:startNode
                                      endNode:endNode];
            if (flag == -1) {
                ;
            }
            else {
                NSNumber *flagNumber = [NSNumber numberWithInt:flag];
                
                NSMutableArray *KCLEquation = [self.linearSystem objectForKey:flagNumber];
                NSMutableArray *SupernodeEquation = [self.linearSystem objectForKey:endNodeNumber];
                
                for (int i=0; i<=self.totalNumberOfNodes; i++) {
                    NSNumber *initialNumber = KCLEquation[i];
                    double initialValue = [initialNumber doubleValue];
                    NSNumber *addedNumber = SupernodeEquation[i];
                    double addedValue = [addedNumber doubleValue];
                    
                    double newValue = initialValue + addedValue;
                    NSNumber *newNumber = [NSNumber numberWithDouble:newValue];
                    
                    KCLEquation[i] = newNumber;
                    SupernodeEquation[i] = @0.0;
                }
                
                NSNumber *voltageNumber = [node.superNodeConnections objectForKey:endNodeNumber];
                double voltageValue = [voltageNumber doubleValue];
                
                SupernodeEquation[startNode] = [NSNumber numberWithDouble:1.0];
                SupernodeEquation[endNode] = [NSNumber numberWithDouble:(-1.0)];
                SupernodeEquation[self.totalNumberOfNodes] = [NSNumber numberWithDouble:(-voltageValue)];
            }
        }
    }
}

- (int)searchSupernodes:(NSMutableDictionary *)supernodes forStartNode:(int)startNode endNode:(int)endNode
{
    for (NSNumber *correspondingSystemRow in [supernodes allKeys]) {
        NSMutableArray *memberNodes = [supernodes objectForKey:correspondingSystemRow];
        
        BOOL containsStartNode = NO;
        BOOL containsEndNode = NO;
        if ([memberNodes containsObject:[NSNumber numberWithInt:startNode]]) {
            containsStartNode = YES;
        }
        if ([memberNodes containsObject:[NSNumber numberWithInt:endNode]]) {
            containsEndNode = YES;
        }
        
        //A supernode has already been created that contains this connection. Return a value that indicates nothing has to be done
        if (containsStartNode && containsEndNode) {
            return -1;
        }
        
        //The supernode that the start node is in did not contain the end node. The end node forms another component in this existing supernode. Add the end node to this existing supernode and return its corresponding row number in the linear system so that the equation of the end node can be added to it
        else if (containsStartNode && !containsEndNode) {
            [memberNodes addObject:[NSNumber numberWithInt:endNode]];
            return [correspondingSystemRow intValue];
        }
        
        //The supernode that the end node is in did not contain the start node. The start node forms another component in this existing supernode. Do nothing, as this case will be handled in another itteration of the function, in which the start and end node are reversed
        else if (!containsStartNode && containsEndNode) {
            return -1;
        }
        
        //If none of these is the case, do nothing and let the loop check the following supernode network
    }
    
    //If the loop has been exausted, there is no existing supernode network that corresponds to or includes the inputed start-end one. A new supernode entry must be created in the supernodes array
    
    //Create the supernode array with the two member nodes
    NSMutableArray *newSupernode = [[NSMutableArray alloc] init];
    [newSupernode addObject:[NSNumber numberWithInt:startNode]];
    [newSupernode addObject:[NSNumber numberWithInt:endNode]];
    
    //Add the supernode to the supernodes network dictionary under the key corresponding to the row of the start node (which is equal to the start node itself)
    [supernodes setObject:newSupernode
        forKeyedSubscript:[NSNumber numberWithInt:startNode]];
    
    //Return the corresponding row number in the system of the new supernode so that the end node equation can be added to it
    return startNode;
}

- (NSMutableArray *)solveLinearSystem:(NSMutableDictionary *)linearSystem
{
    //Allocate a C array to simplify the process of solving the system
    double **system = (double **)malloc((self.totalNumberOfNodes+1) * sizeof(double *));
    for (int i=0; i<self.totalNumberOfNodes+1; i++) {
        system[i] = (double *)malloc((self.totalNumberOfNodes+1) * sizeof(double));
    }
    
    //Initialize the elements of the C array with those of the linearSystem
    for (int i=0; i<self.totalNumberOfNodes; i++) {
        NSNumber *key = [NSNumber numberWithInt:i];
        NSMutableArray *linearEquation = [self.linearSystem objectForKey:key];
        
        for (int j=0; j<self.totalNumberOfNodes+1; j++) {
            NSNumber *doubleNumber = linearEquation[j];
            system[i][j] = [doubleNumber doubleValue];
        }
    }
    
    //Create extra equation at the system's last row to represent that the voltage of ground (node 0) is equal to 0
    system[self.totalNumberOfNodes][0] = 1.0;
    for (int i=1; i<self.totalNumberOfNodes+1; i++) {
        system[self.totalNumberOfNodes][i] = 0.0;
    }
    
    //Begin solving the system of equations
    int n = self.totalNumberOfNodes;
    //For every column in the matrix (excluding the augmented part)
    for (int i=0 ; i<n ; i++){
        //Search for maximum in this column
        double maxVal = fabs(system[i][i]);
        int maxRow =i;
        for (int k=i+1 ; k<n+1 ; k++){
            if (fabs(system[k][i]) > maxVal){
                maxVal = fabs(system[k][i]);
                maxRow = k;
            }
        }
        
        //Swap maximum row with current row (column by column)
        for (int k=i ; k<n+1 ; k++){
            double temp = system[maxRow][k];
            system[maxRow][k] = system[i][k];
            system[i][k] = temp;
        }
        
        //Make all rows below this one 0 in current column
        for (int k=i+1 ; k<n+1 ; k++){
            double c = -system[k][i]/system[i][i];
            for (int j=i ; j<n+1 ; j++){
                if (i==j)
                    system[k][j] = 0;
                else
                    system[k][j] += c*system[i][j];
            }
        }
    }
    
    //Solve the system Ax=b for an upper triangular matrix A
    NSMutableArray *solution = [[NSMutableArray alloc] init];
    for (int i=0; i<n; i++) {
        [solution addObject:@0];
    }
    for (int i=n-1; i>=0; i--) {
        solution[i] = [NSNumber numberWithDouble:system[i][n]/system[i][i]];
        for (int k=i-1; k>=0; k--) {
            system[k][n] -= system[k][i] * [solution[i] doubleValue];
        }
    }
    //Correct for rounding error due to floating point value
    double threshold = 1.0e-10;
    for (int i=0; i<n; i++) {
        if (fabs([solution[i] doubleValue]) < threshold) {
            solution[i] = @0;
        }
    }
    
    //Free the system
    for (int i=0; i<self.totalNumberOfNodes+1; i++) {
        free(system[i]);
    }
    free(system);
    
    return solution;
}

@end
