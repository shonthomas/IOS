//
//  AppDelegate.m
//  Flicks
//
//  Created by Shon Thomas on 9/12/16.
//  Copyright © 2016 shon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Set up the first View Controller
    UINavigationController *nowPlayingNC = [storyboard instantiateViewControllerWithIdentifier:@"MoviesNavigationController"];
    
    nowPlayingNC.view.backgroundColor = [UIColor orangeColor];
    nowPlayingNC.tabBarItem.title = @"Now Playing";
    nowPlayingNC.tabBarItem.image = [UIImage imageNamed:@"clapboard"];
    
    ListViewController *nowPlayingViewController = (ListViewController *)[nowPlayingNC topViewController];
    nowPlayingViewController.endpoint = @"now_playing";
    nowPlayingViewController.title = @"Now Playing";

    
    // Set up the second View Controller
    UINavigationController *topRatedNC = [storyboard instantiateViewControllerWithIdentifier:@"MoviesNavigationController"];
    
    topRatedNC.view.backgroundColor = [UIColor orangeColor];
    topRatedNC.tabBarItem.title = @"Top Rated";
    topRatedNC.tabBarItem.image = [UIImage imageNamed:@"top_rated"];
    
    ListViewController *topRatedViewController = (ListViewController *)[topRatedNC topViewController];
    topRatedViewController.endpoint = @"top_rated";
    topRatedViewController.title = @"Top Rated";
    
    // Set up the Tab Bar Controller to have two tabs
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[nowPlayingNC, topRatedNC]];

    // Tabbar & items appearance
    [UITabBar.appearance setBarTintColor:[UIColor colorWithRed:209/255.0 green:161/255.0 blue:44/255.0 alpha:1.0]];
    [UITabBar.appearance setTintColor:[UIColor blackColor]];
    [UITabBarItem.appearance setTitleTextAttributes:@{
                    NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    
    // Make the Tab Bar Controller the root view controller
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
//    [self.window setBackgroundColor:[UIColor orangeColor]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
