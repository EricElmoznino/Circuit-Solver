//
//  EETableCell.h
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-14.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EETableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *startNodeGroundSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *endNodeGroundSymbol;

@property (weak, nonatomic) IBOutlet UILabel *startNodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endNodeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *currentPositiveSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *currentNegativeSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *voltagePositiveSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *voltageNegativeSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *resistorSymbol;

@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *voltageLabel;
@property (weak, nonatomic) IBOutlet UILabel *resistanceLabel;

@end
