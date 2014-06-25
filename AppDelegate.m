//
//  AppDelegate.m
//  Braillev4
//
//  Created by Brown, Melissa on 4/9/14.
//  Copyright (c) 2014 Heartland Community College. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate()

@property (nonatomic, strong)ViewController *viewController;
@end

@implementation AppDelegate
    NSString *const TIMEOUT_KEY = @"timeout";


#pragma mark- Preferences

- (void)loadDefaultSettingsIfNecessary {
    NSString *firstLaunchKey = @"AppLaunched";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:firstLaunchKey]) {
        [userDefaults setBool:YES forKey:firstLaunchKey];
        NSMutableDictionary *defaultsDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"]] pathForResource:@"Root" ofType:@"plist"]];
        NSArray *preferencesSpecifiers = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
        for(NSDictionary *preference in preferencesSpecifiers){
            id key = [preference objectForKey:@"Key"];
            id defaultValue = [preference objectForKey:@"DefaultValue"];
            if(key && defaultValue){
                [defaultsDictionary setObject:defaultValue forKey:key];
            }
        }
        
        [userDefaults registerDefaults:defaultsDictionary];
        [userDefaults synchronize];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadDefaultSettingsIfNecessary];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil]];
    self.window.rootViewController = nc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_viewController loadPreferences];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
