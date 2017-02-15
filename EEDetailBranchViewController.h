//
//  EEDetailBranchViewController.h
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-10.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEBranch.h"

@interface EEDetailBranchViewController : UIViewController

@property (nonatomic, strong) EEBranch *branch;
@property (nonatomic) BOOL isNew;

@end
