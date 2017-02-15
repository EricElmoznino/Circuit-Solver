//
//  EEDetailBranchViewController.m
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-10.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "EEDetailBranchViewController.h"
#import "EEBranchesStore.h"
#import "AppDelegate.h"

@interface EEDetailBranchViewController ()

@property (weak, nonatomic) IBOutlet UIStepper *startNodeStepper;
@property (weak, nonatomic) IBOutlet UIStepper *endNodeStepper;
@property (weak, nonatomic) IBOutlet UILabel *startNodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endNodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *independentCurrentTextField;
@property (weak, nonatomic) IBOutlet UITextField *independentVoltageTextField;
@property (weak, nonatomic) IBOutlet UITextField *resistanceTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentUnits;
@property (weak, nonatomic) IBOutlet UILabel *voltageUnits;
@property (weak, nonatomic) IBOutlet UILabel *resistanceUnits;

@property (weak, nonatomic) IBOutlet UIImageView *resistorSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *voltagePositiveSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *voltageNegativeSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *currentPositiveSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *currentNegativeSymbol;

@property (weak, nonatomic) IBOutlet UILabel *currentSymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *voltageSymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *resistorSymbolLabel;

@property (weak, nonatomic) IBOutlet UILabel *startNodeSymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *endNodeSymbolLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startNodeGroundSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *endNodeGroundSymbol;

@property (weak, nonatomic) IBOutlet UIView *diagramView;

@end

@implementation EEDetailBranchViewController

#pragma mark - Appear/Disapear Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.startNodeStepper addTarget:self
                              action:@selector(updateStartNodeLabel)
                    forControlEvents:UIControlEventValueChanged];
    [self.endNodeStepper addTarget:self
                            action:@selector(updateEndNodeLabel)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //State restoration has not occured yet.
    //Let the interface be updated in method
    //applicationFinishedRestoringState
    if (!self.branch) {
        return;
    }
    
    [self updateInterface];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    //Unit conversion multiplier
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    double currentMultiplier = [[settings objectForKey:EECurrentUnitPrefsKey] doubleValue];
    double voltageMultiplier = [[settings objectForKey:EEVoltageUnitPrefsKey] doubleValue];
    double resistanceMultiplier = [[settings objectForKey:EEResistanceUnitPrefsKey] doubleValue];
    
    //Update branch data
    self.branch.startNode = (int)self.startNodeStepper.value;
    self.branch.endNode = (int)self.endNodeStepper.value;
    self.branch.independentCurrent = [self.independentCurrentTextField.text doubleValue] *
        currentMultiplier;
    self.branch.independentVoltage = [self.independentVoltageTextField.text doubleValue] *
        voltageMultiplier;
    self.branch.resistance = [self.resistanceTextField.text doubleValue] *
        resistanceMultiplier;
}

- (IBAction)dismissWithDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissWithCancel:(id)sender
{
    [[EEBranchesStore sharedStore] removeBranch:self.branch];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate and UIControlDelegate

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    //If the user did not enter a valid number, force the textField to 0
    NSNumber *userEnteredNumber;
    userEnteredNumber = [formatter
                         numberFromString:textField.text];
    if (userEnteredNumber == nil) {
        textField.text = @"0";
    }
    
    //If the user entered a number with leading 0's or a negative value for resistance
    formatter.allowsFloats = YES;
    formatter.usesGroupingSeparator = NO;
    userEnteredNumber = [formatter numberFromString:textField.text];
    if (textField == self.resistanceTextField) {
        userEnteredNumber = [NSNumber numberWithDouble:fabs([userEnteredNumber doubleValue])];
    }
    textField.text = [formatter stringFromNumber:userEnteredNumber];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //User finished typing a field
    //Configure the branch diagram image
    [self updateBranchDiagram];
}

#pragma mark - Interface Configuration

- (void)updateStartNodeLabel
{
    if (self.startNodeStepper.value == 0) {
        self.startNodeLabel.text = @"GND";
    }
    else {
        self.startNodeLabel.text = [NSString stringWithFormat:@"%d",(int)self.startNodeStepper.value];
    }
    
    //Configure the branch diagram image
    [self updateNodesDiagramSection];
}

- (void)updateEndNodeLabel
{
    if (self.endNodeStepper.value == 0) {
        self.endNodeLabel.text = @"GND";
    }
    else {
        self.endNodeLabel.text = [NSString stringWithFormat:@"%d",(int)self.endNodeStepper.value];
    }
    
    //Configure the branch diagram image
    [self updateNodesDiagramSection];
}

- (void)updateInterface
{
    //Configure the node setup UI elements
    self.startNodeStepper.value = self.branch.startNode;
    self.endNodeStepper.value = self.branch.endNode;
    
    if (self.startNodeStepper.value == 0) {
        self.startNodeLabel.text = @"GND";
    }
    else {
        self.startNodeLabel.text = [NSString stringWithFormat:@"%d",(int)self.startNodeStepper.value];
    }
    if (self.endNodeStepper.value == 0) {
        self.endNodeLabel.text = @"GND";
    }
    else {
        self.endNodeLabel.text = [NSString stringWithFormat:@"%d",(int)self.endNodeStepper.value];
    }
    
    //Configure the branch setup UI elements
    [self updateBranchSetupElements];
    
    //Configure the branch diagram image
    [self updateBranchDiagram];
    [self updateNodesDiagramSection];
    
    //Hide the cancel and done buttons if branch is not new
    if (!self.isNew) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)updateBranchSetupElements
{
    //Configure the text displayed by the labels
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
    double current = self.branch.independentCurrent / currentMultiplier;
    double voltage = self.branch.independentVoltage / voltageMultiplier;
    double resistance = self.branch.resistance / resistanceMultiplier;
    
    self.independentCurrentTextField.text = [NSString stringWithFormat:@"%@",
                              [formatter stringFromNumber:[NSNumber numberWithDouble:current]]];
    self.independentVoltageTextField.text = [NSString stringWithFormat:@"%@",
                              [formatter stringFromNumber:[NSNumber numberWithDouble:voltage]]];
    self.resistanceTextField.text = [NSString stringWithFormat:@"%@",
                                 [formatter stringFromNumber:[NSNumber numberWithDouble:resistance]]];
    self.currentUnits.text = [NSString stringWithFormat:@"%@A",currentSymbolPrefix];
    self.voltageUnits.text = [NSString stringWithFormat:@"%@V",voltageSymbolPrefix];
    self.resistanceUnits.text = [NSString stringWithFormat:@"%@Ω",resistanceSymbolPrefix];
}

- (void)updateBranchDiagram
{
    //Configure the text displayed by the labels
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    double current = fabs([self.independentCurrentTextField.text doubleValue]);
    double voltage = fabs([self.independentVoltageTextField.text doubleValue]);
    double resistance = fabs([self.resistanceTextField.text doubleValue]);
    
    self.currentSymbolLabel.text = [NSString stringWithFormat:@"%@%@",
                                    [formatter stringFromNumber:[NSNumber numberWithDouble:current]],
                                    self.currentUnits.text];
    self.voltageSymbolLabel.text = [NSString stringWithFormat:@"%@%@",
                                    [formatter stringFromNumber:[NSNumber numberWithDouble:voltage]],
                                    self.voltageUnits.text];
    self.resistorSymbolLabel.text = [NSString stringWithFormat:@"%@%@",
                                     [formatter stringFromNumber:[NSNumber numberWithDouble:resistance]],
                                     self.resistanceUnits.text];
    
    //Update which elements are visible
    if ([self.independentCurrentTextField.text doubleValue] == 0) {
        self.currentPositiveSymbol.hidden = YES;
        self.currentNegativeSymbol.hidden = YES;
        self.currentSymbolLabel.hidden = YES;
    }
    else if ([self.independentCurrentTextField.text doubleValue] > 0) {
        self.currentPositiveSymbol.hidden = NO;
        self.currentNegativeSymbol.hidden = YES;
        self.currentSymbolLabel.hidden = NO;
    }
    else {
        self.currentPositiveSymbol.hidden = YES;
        self.currentNegativeSymbol.hidden = NO;
        self.currentSymbolLabel.hidden = NO;
    }
    
    if ([self.independentVoltageTextField.text doubleValue] == 0) {
        self.voltagePositiveSymbol.hidden = YES;
        self.voltageNegativeSymbol. hidden = YES;
        self.voltageSymbolLabel.hidden = YES;
    }
    else if ([self.independentVoltageTextField.text doubleValue] > 0) {
        self.voltagePositiveSymbol.hidden = NO;
        self.voltageNegativeSymbol.hidden = YES;
        self.voltageSymbolLabel.hidden = NO;
    }
    else {
        self.voltagePositiveSymbol.hidden = YES;
        self.voltageNegativeSymbol.hidden = NO;
        self.voltageSymbolLabel.hidden = NO;
    }
    
    if ([self.resistanceTextField.text doubleValue] == 0) {
        self.resistorSymbol.hidden = YES;
        self.resistorSymbolLabel.hidden = YES;
    }
    else {
        self.resistorSymbol.hidden = NO;
        self.resistorSymbolLabel.hidden = NO;
    }
}

- (void)updateNodesDiagramSection
{
    //Update the text displayed by the labels
    self.startNodeSymbolLabel.text = self.startNodeLabel.text;
    self.endNodeSymbolLabel.text = self.endNodeLabel.text;
    
    //Update which elements are visible
    if (self.startNodeStepper.value) {
        self.startNodeSymbolLabel.hidden = NO;
        self.startNodeGroundSymbol.hidden = YES;
    }
    else {
        self.startNodeSymbolLabel.hidden = YES;
        self.startNodeGroundSymbol.hidden = NO;
    }
    
    if (self.endNodeStepper.value) {
        self.endNodeSymbolLabel.hidden = NO;
        self.endNodeGroundSymbol.hidden = YES;
    }
    else {
        self.endNodeSymbolLabel.hidden = YES;
        self.endNodeGroundSymbol.hidden = NO;
    }
}

#pragma mark - State Restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.branch.branchKey forKey:@"branch.branchKey"];
    [coder encodeBool:self.isNew forKey:@"isNew"];
    
    //Save changes to the branch
    self.branch.startNode = (int)self.startNodeStepper.value;
    self.branch.endNode = (int)self.endNodeStepper.value;
    self.branch.independentCurrent = [self.independentCurrentTextField.text doubleValue];
    self.branch.independentVoltage = [self.independentVoltageTextField.text doubleValue];
    self.branch.resistance = [self.resistanceTextField.text doubleValue];
    
    //Have the store save changes to disk
    [[EEBranchesStore sharedStore] saveChanges];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    BOOL isNew = [coder decodeBoolForKey:@"isNew"];
    self.isNew = isNew;
    
    NSString *branchKey = [coder decodeObjectForKey:@"branch.branchKey"];
    for (EEBranch *branch in [[EEBranchesStore sharedStore] allBranches]) {
        if ([branchKey isEqualToString:branch.branchKey]) {
            self.branch = branch;
            break;
        }
    }
    
    //Refresh the view
    [self.view setNeedsDisplay];
}

- (void)applicationFinishedRestoringState
{
    [self updateInterface];
}

@end
