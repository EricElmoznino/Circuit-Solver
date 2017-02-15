//
//  EESettingsViewController.m
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-28.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "EESettingsViewController.h"
#import "AppDelegate.h"

@interface EESettingsViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *componentPickerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *componentUnitControl;

@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;

@end

@implementation EESettingsViewController

#pragma mark - Appear/Disappear Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSInteger selectedComponent = [self.componentPickerView selectedRowInComponent:0];
    [self showUnitForComponent:selectedComponent];
    
    //Check for the device to change the size of the "Unit" label font
    UIUserInterfaceIdiom device = [UIDevice currentDevice].userInterfaceIdiom;
    if (device == UIUserInterfaceIdiomPad) {
        self.unitsLabel.font = [UIFont systemFontOfSize:30];
    }
    else {
        self.unitsLabel.font = [UIFont systemFontOfSize:20];
    }
}

#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 80;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (row==0) {
        UIImage *currentImage = [UIImage imageNamed:@"Current_Positive"];
        UIImageView *currentImageView = [[UIImageView alloc] initWithImage:currentImage];
        currentImageView.frame = CGRectMake(5, 5, 70, 70);
        currentImageView.contentMode = UIViewContentModeScaleAspectFit;
        return currentImageView;
    }
    else if (row==1) {
        UIImage *voltageImage = [UIImage imageNamed:@"Voltage_Positive"];
        UIImageView *voltageImageView = [[UIImageView alloc] initWithImage:voltageImage];
        voltageImageView.frame = CGRectMake(5, 5, 70, 70);
        voltageImageView.contentMode = UIViewContentModeScaleAspectFit;
        return voltageImageView;
    }
    else {
        UIImage *resistorImage = [UIImage imageNamed:@"Resistor"];
        UIImageView *resistorImageView = [[UIImageView alloc] initWithImage:resistorImage];
        resistorImageView.frame = CGRectMake(5, 5, 70, 70);
        resistorImageView.contentMode = UIViewContentModeScaleAspectFit;
        return resistorImageView;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self showUnitForComponent:row];
}

#pragma mark - UISegmentedControl

- (IBAction)didChangeUnit:(id)sender {
    NSInteger selectedComponent = [self.componentPickerView selectedRowInComponent:0];
    [self selectUnitForComponent:selectedComponent];
}

- (void)showUnitForComponent:(NSInteger)selectedComponent
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSNumber *selectedUnitMultiplier;
    
    if (selectedComponent == 0) {
        selectedUnitMultiplier = [settings objectForKey:EECurrentUnitPrefsKey];
    }
    else if (selectedComponent == 1) {
        selectedUnitMultiplier = [settings objectForKey:EEVoltageUnitPrefsKey];
    }
    else {
        selectedUnitMultiplier = [settings objectForKey:EEResistanceUnitPrefsKey];
    }
    
    NSArray *availableUnitMultipliers = @[@0.000001,
                                          @0.001,
                                          @1,
                                          @1000,
                                          @1000000];
    NSInteger selectedUnitIndex = [availableUnitMultipliers indexOfObject:selectedUnitMultiplier];
    
    self.componentUnitControl.selectedSegmentIndex = selectedUnitIndex;
}

- (void)selectUnitForComponent:(NSInteger)selectedComponent
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSInteger selectedUnitIndex = self.componentUnitControl.selectedSegmentIndex;
    
    NSArray *availableUnitMultipliers = @[@0.000001,
                                          @0.001,
                                          @1,
                                          @1000,
                                          @1000000];
    NSNumber *selectedUnitMultiplier = availableUnitMultipliers[selectedUnitIndex];
    
    if (selectedComponent == 0) {
        [settings setObject:selectedUnitMultiplier forKey:EECurrentUnitPrefsKey];
    }
    else if (selectedComponent == 1) {
        [settings setObject:selectedUnitMultiplier forKey:EEVoltageUnitPrefsKey];
    }
    else {
        [settings setObject:selectedUnitMultiplier forKey:EEResistanceUnitPrefsKey];
    }
}

#pragma mark - State Restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    NSInteger selectedPickerRow = [self.componentPickerView selectedRowInComponent:0];
    [coder encodeInteger:selectedPickerRow forKey:@"selectedPickerRow"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    NSInteger selectedPickerRow = [coder decodeIntegerForKey:@"selectedPickerRow"];
    [self.componentPickerView selectRow:selectedPickerRow inComponent:0 animated:NO];
    
    [self viewWillAppear:NO];
}

@end
