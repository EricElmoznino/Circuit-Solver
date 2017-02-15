//
//  EEBranchesViewController.h
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-09.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EEBranchesViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
