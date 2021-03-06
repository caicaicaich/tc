//
//  AppDelegate.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "AppDelegate.h"
#import "config.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "LoginViewController.h"
#import <RTRootNavigationController/RTRootNavigationController.h>
//#import "PRPDebug.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  [self ConfigApp];
    
    LoginViewController *loginVC= [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.window.rootViewController = [[RTRootNavigationController alloc] initWithRootViewController:loginVC];
    [self.window makeKeyAndVisible];
    
  return YES;
}

- (void)ConfigApp
{
  if ([AMapAPIKey length] == 0)
  {
    NSString *reason = [NSString stringWithFormat:@"❌apiKey为空，请检查key是否正确设置。"];
    NSLog(@"%@",reason);
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
//    [alert show];
  }
  
  [AMapServices sharedServices].apiKey = (NSString *)AMapAPIKey;
  
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
