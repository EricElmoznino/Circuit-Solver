//
//  EEBranchesViewController.m
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-09.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "EEBranchesViewController.h"
#import "EEDetailBranchViewController.h"
#import "EESolutionViewController.h"
#import "EEBranchesStore.h"
#import "EEBranch.h"
#import "EENode.h"
#import "EECircuit.h"
#import "EETableCell.h"
#import "AppDelegate.h"

@interface EEBranchesViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearAllButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *solveButton;

@property (strong, nonatomic) NSArray *solution;

@end

@implementation EEBranchesViewController

#pragma mark - Appear/Disapear Methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Hide empty rows
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    //Disable the clear all and solve buttons if the user
    //has not entered any branches
    self.solveButton.enabled = YES;
    self.clearAllButton.enabled = YES;
    if (![[[EEBranchesStore sharedStore] allBranches] count]) {
        self.solveButton.enabled = NO;
        self.clearAllButton.enabled = NO;
    }
    
    //Disable the solve button if the
    //circuit currently has no solution
    self.solution = [self solutionToLinearSystem];
    if ([self.solution count]==0) {
        self.solveButton.enabled = NO;
    }
    for (NSNumber *number in self.solution) {
        if (isnan([number floatValue]) || isinf(fabsf([number floatValue]))) {
            self.solveButton.enabled = NO;
            break;
        }
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[EEBranchesStore sharedStore] allBranches] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EETableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EEBranchCell"
                                                            forIndexPath:indexPath];
    NSArray *branches = [[EEBranchesStore sharedStore] allBranches];
    EEBranch *branch = branches[indexPath.row];
    
    //Configure the text displayed by the cell labels
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    //Unit conversion multiplier
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    double currentMultiplier = [[settings objectForKey:EECurrentUnitPrefsKey] doubleValue];
    double voltageMultiplier = [[settings objectForKey:EEVoltageUnitPrefsKey] doubleValue];
    double resistanceMultiplier = [[settings objectForKey:EEResistanceUnitPrefsKey] doubleValue];
    
    //Unit symbol
    NSArray *unitPrefixes = [settings objectForKey:EEUnitPrefixesKey];
    NSArray *availableMultipliers = @[@0.000001,
                                      @0.001,
                                      @1,
                                      @1000,
                                      @1000000];
    NSInteger currentUnitIndex = [availableMultipliers indexOfObject:[NSNumber numberWithDouble:currentMultiplier]];
    NSInteger voltageUnitIndex = [availableMultipliers indexOfObject:[NSNumber numberWithDouble:voltageMultiplier]];
    NSInteger resistanceUnitIndex = [availableMultipliers indexOfObject:[NSNumber numberWithDouble:resistanceMultiplier]];
    NSString *currentSymbolPrefix = unitPrefixes[currentUnitIndex];
    NSString *voltageSymbolPrefix = unitPrefixes[voltageUnitIndex];
    NSString *resistanceSymbolPrefix = unitPrefixes[resistanceUnitIndex];
    
    //Set the text displayed by the labels
    double current = fabs(branch.independentCurrent) / currentMultiplier;
    double voltage = fabs(branch.independentVoltage) / voltageMultiplier;
    double resistance = fabs(branch.resistance) / resistanceMultiplier;
    
    cell.currentLabel.text = [NSString stringWithFormat:@"%@%@A",
                              [formatter stringFromNumber:[NSNumber numberWithDouble:current]],
                              currentSymbolPrefix];
    cell.voltageLabel.text = [NSString stringWithFormat:@"%@%@V",
                              [formatter stringFromNumber:[NSNumber numberWithDouble:voltage]],
                              voltageSymbolPrefix];
    cell.resistanceLabel.text = [NSString stringWithFormat:@"%@%@Ω",
                                 [formatter stringFromNumber:[NSNumber numberWithDouble:resistance]],
                                 resistanceSymbolPrefix];
    
    cell.startNodeLabel.text = [NSString stringWithFormat:@"%d",branch.startNode];
    cell.endNodeLabel.text = [NSString stringWithFormat:@"%D",branch.endNode];
    
    //Configure which elements of the cell are visible
    if (branch.independentCurrent == 0) {
        cell.currentPositiveSymbol.hidden = YES;
        cell.currentNegativeSymbol.hidden = YES;
        cell.currentLabel.hidden = YES;
    }
    else if (branch.independentCurrent > 0) {
        cell.currentPositiveSymbol.hidden = NO;
        cell.currentNegativeSymbol.hidden = YES;
        cell.currentLabel.hidden = NO;
    }
    else {
        cell.currentPositiveSymbol.hidden = YES;
        cell.currentNegativeSymbol.hidden = NO;
        cell.currentLabel.hidden = NO;
    }
    
    if (branch.independentVoltage == 0) {
        cell.voltagePositiveSymbol.hidden = YES;
        cell.voltageNegativeSymbol.hidden = YES;
        cell.voltageLabel.hidden = YES;
    }
    else if (branch.independentVoltage > 0) {
        cell.voltagePositiveSymbol.hidden = NO;
        cell.voltageNegativeSymbol.hidden = YES;
        cell.voltageLabel.hidden = NO;
    }
    else {
        cell.voltagePositiveSymbol.hidden = YES;
        cell.voltageNegativeSymbol.hidden = NO;
        cell.voltageLabel.hidden = NO;
    }
    
    if (branch.resistance == 0) {
        cell.resistorSymbol.hidden = YES;
        cell.resistanceLabel.hidden = YES;
    }
    else {
        cell.resistorSymbol.hidden = NO;
        cell.resistanceLabel.hidden = NO;
    }
    
    if (branch.startNode) {
        cell.startNodeLabel.hidden = NO;
        cell.startNodeGroundSymbol.hidden = YES;
    }
    else {
        cell.startNodeLabel.hidden = YES;
        cell.startNodeGroundSymbol.hidden = NO;
    }
    
    if (branch.endNode) {
        cell.endNodeLabel.hidden = NO;
        cell.endNodeGroundSymbol.hidden = YES;
    }
    else {
        cell.endNodeLabel.hidden = YES;
        cell.endNodeGroundSymbol.hidden = NO;
    }
    
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSArray *branches = [[EEBranchesStore sharedStore] allBranches];
        EEBranch *branch = branches[indexPath.row];
        [[EEBranchesStore sharedStore] removeBranch:branch];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Disable the clear all and solve buttons if the user
    //has not entered any branches
    self.solveButton.enabled = YES;
    self.clearAllButton.enabled = YES;
    if (![[[EEBranchesStore sharedStore] allBranches] count]) {
        self.solveButton.enabled = NO;
        self.clearAllButton.enabled = NO;
    }
    
    //Disable the solve button if the
    //circuit currently has no solution
    self.solution = [self solutionToLinearSystem];
    if ([self.solution count]==0) {
        self.solveButton.enabled = NO;
    }
    for (NSNumber *number in self.solution) {
        if (isnan([number floatValue]) || isinf(fabsf([number floatValue]))) {
            self.solveButton.enabled = NO;
            break;
        }
    }
}

#pragma mark - Solve and Clear Methods

- (IBAction)clearAllBranches:(id)sender
{
    NSArray *branches = [[EEBranchesStore sharedStore] allBranches];
    for (int i=(int)[[[EEBranchesStore sharedStore] allBranches] count]-1; i>=0; i--) {
        EEBranch *branch = branches[i];
        [[EEBranchesStore sharedStore] removeBranch:branch];
    }
    [self.tableView reloadData];
    
    //Disable the clear all and solve buttons if the user
    //has not entered any branches
    self.solveButton.enabled = YES;
    self.clearAllButton.enabled = YES;
    if (![[[EEBranchesStore sharedStore] allBranches] count]) {
        self.solveButton.enabled = NO;
        self.clearAllButton.enabled = NO;
    }
    
    //Disable the solve button if the
    //circuit currently has no solution
    self.solution = [self solutionToLinearSystem];
    if ([self.solution count]==0) {
        self.solveButton.enabled = NO;
    }
    for (NSNumber *number in self.solution) {
        if (isnan([number floatValue]) || isinf(fabsf([number floatValue]))) {
            self.solveButton.enabled = NO;
            break;
        }
    }
}

- (NSArray *)solutionToLinearSystem
{
    //Find the total number of nodes in the circuit
    int totalNumberOfNodes = 0;
    for (EEBranch *branch in [[EEBranchesStore sharedStore] allBranches]) {
        if (branch.startNode+1 > totalNumberOfNodes) {
            totalNumberOfNodes = branch.startNode+1;
        }
        if (branch.endNode+1 > totalNumberOfNodes) {
            totalNumberOfNodes = branch.endNode+1;
        }
    }
    
    //Create the circuit with the branches
    EECircuit *circuit = [[EECircuit alloc] initWithTotalNumberOfNodes:totalNumberOfNodes];
    for (EEBranch *branch in [[EEBranchesStore sharedStore] allBranches]) {
        EENode *firstNode = circuit.nodes[branch.startNode];
        [firstNode.branches addObject:[EEBranch copyFromBranch:branch]];
        
        EENode *secondNode = circuit.nodes[branch.endNode];
        [secondNode.branches addObject:[EEBranch reverseCopyFromBranch:branch]];
    }
    
    //Construct the node equations and supernode connections
    for (EENode *node in circuit.nodes) {
        [node constructEquation];
        [node constructSupernodeConnections];
    }
    
    //Construct and fix the circuit linear system
    [circuit constructSystem];
    [circuit fixSystemForSupernodes];
    
    //The solution to the linear system
    NSMutableArray *solutionWithGround = [circuit solveLinearSystem:circuit.linearSystem];
    
    //Convert units
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    double voltageMultiplier = [[settings objectForKey:EEVoltageUnitPrefsKey] doubleValue];
    for (int i=0; i<totalNumberOfNodes; i++) {
        double doubleValue = [solutionWithGround[i] doubleValue];
        doubleValue /= voltageMultiplier;
        solutionWithGround[i] = [NSNumber numberWithDouble:doubleValue];
    }
    
    //Solution without ground included
    if ([solutionWithGround count]) {
        [solutionWithGround removeObjectAtIndex:0];
    }
    NSArray *solution = [solutionWithGround copy];
    
    return solution;
}

#pragma mark - State Restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewBranch"]) {
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        EEDetailBranchViewController *dvc = (EEDetailBranchViewController *)[nc topViewController];
        
        EEBranch *branch = [[EEBranch alloc] initWithStartNode:0];
        [[EEBranchesStore sharedStore] addBranch:branch];
        
        dvc.branch = branch;
        dvc.isNew = YES;
    }
    else if ([segue.identifier isEqualToString:@"ExistingBranch"]) {
        EEDetailBranchViewController *dvc = (EEDetailBranchViewController *)segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        NSArray *branches = [[EEBranchesStore sharedStore] allBranches];
        EEBranch *branch = [branches objectAtIndex:indexPath.row];
        
        dvc.branch = branch;
        dvc.isNew = NO;
    }
    else if ([segue.identifier isEqualToString:@"ShowSolution"]) {
        EESolutionViewController *svc = (EESolutionViewController *)segue.destinationViewController;
        svc.solution = self.solution;
    }
}

@end
