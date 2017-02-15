//
//  AppDelegate.h
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-08.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const EECurrentUnitPrefsKey;
extern NSString * const EEVoltageUnitPrefsKey;
extern NSString * const EEResistanceUnitPrefsKey;
extern NSString * const EEUnitPrefixesKey;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

