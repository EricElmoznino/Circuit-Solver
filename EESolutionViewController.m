//
//  EESolutionViewController.m
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-11.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "EESolutionViewController.h"
#import "AppDelegate.h"

@interface EESolutionViewController ()

@end

@implementation EESolutionViewController

#pragma mark - Appear/Disappear Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Hide empty rows
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Prevent row selection
    self.tableView.allowsSelection = NO;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.solution count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EESolutionCell"
                                                            forIndexPath:indexPath];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *voltage = self.solution[indexPath.row];
    
    //Unit symbol
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    double voltageMultiplier = [[settings objectForKey:EEVoltageUnitPrefsKey] doubleValue];
    NSArray *unitPrefixes = [settings objectForKey:EEUnitPrefixesKey];
    NSArray *availableMultipliers = @[@0.000001,
                                      @0.001,
                                      @1,
                                      @1000,
                                      @1000000];
    NSInteger voltageUnitIndex = [availableMultipliers indexOfObject:
                                  [NSNumber numberWithDouble:voltageMultiplier]];
    NSString *voltageSymbolPrefix = unitPrefixes[voltageUnitIndex];
    
    //Configure cell data
    cell.textLabel.text = [NSString stringWithFormat:@"Node: %d",(int)indexPath.row+1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@V",
                                 [formatter stringFromNumber:voltage],
                                 voltageSymbolPrefix];
    
    return cell;
}

#pragma mark - State Restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.solution forKey:@"solution"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    self.solution = [coder decodeObjectForKey:@"solution"];
}


@end
