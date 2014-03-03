//
//  AppDelegate.m
//  Assimilator
//
//  Created by Tim Nugent on 9/02/2014.
//  Copyright (c) 2014 Tim Nugent. All rights reserved.
//

#import "AppDelegate.h"
#import "Assimilator.h"

#warning change these to actually connect to the Parse DB
#define APP_ID nil
#define CLIENT_KEY nil

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	
	[Parse setApplicationId:APP_ID
				  clientKey:CLIENT_KEY];
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
	
	NSDictionary *locations = [[NSUserDefaults standardUserDefaults] objectForKey:@"locations"];
	if (locations)
	{
		NSLog(@"locations found");
		[Assimilator sharedAssimilator].locations = [locations mutableCopy];
	}
	
	NSString *allegiance = [[NSUserDefaults standardUserDefaults] objectForKey:@"allegiance"];
	if (allegiance)
	{
		NSLog(@"Allegiance found");
		if ([allegiance isEqualToString:LIZARD_KEY])
			[Assimilator sharedAssimilator].allegiance = LIZARD_PEOPLE;
		else
			[Assimilator sharedAssimilator].allegiance = ILLUMINATI;
		
		// jump to the search assimilator search view controller
		UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
		[navVC pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AssimilatorSearchViewController"] animated:NO];
	}
	
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
