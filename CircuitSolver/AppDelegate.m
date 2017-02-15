//
//  AppDelegate.m
//  CircuitSolver
//
//  Created by GAD ELMOZNINO on 2015-06-08.
//  Copyright (c) 2015 Eric Elmoznino. All rights reserved.
//

#import "AppDelegate.h"
#import "EEBranchesStore.h"

NSString * const EECurrentUnitPrefsKey = @"CurrentUnit";
NSString * const EEVoltageUnitPrefsKey = @"VoltageUnit";
NSString * const EEResistanceUnitPrefsKey = @"ResistanceUnit";
NSString * const EEUnitPrefixesKey = @"UnitPrefixesKey";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize
{
    NSNumber *defaultCurrentMultiplier = @1;
    NSNumber *defaultVoltageMultiplier = @1;
    NSNumber *defaultResistanceMultiplier = @1;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *factorySettings = @{EECurrentUnitPrefsKey:defaultCurrentMultiplier,
                                      EEVoltageUnitPrefsKey:defaultVoltageMultiplier,
                                      EEResistanceUnitPrefsKey:defaultResistanceMultiplier,
                                      EEUnitPrefixesKey:@[@"μ",
                                                          @"m",
                                                          @"",
                                                          @"k",
                                                          @"M"]
                                      };
    [defaults registerDefaults:factorySettings];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];*/
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EEBranchesStore sharedStore] saveChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
