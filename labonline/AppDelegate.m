//
//  AppDelegate.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "TencentOpenAPI/TencentOAuth.h"



@interface AppDelegate ()

@end

NSString *const COCIM_SERVER_PATH = @"http://123.57.155.106:8080/labonline";
NSString *const COCIM_INTERFACE_LOGIN =  @"http://123.57.155.106:8080/labonline/hyController/login.do";
NSString *const COCIM_INTERFACE_REG=@"http://123.57.155.106:8080/labonline/hyController/insertHyyh.do";
NSString *const COCIM_INTERFACE_PAST_MAGAZINE=@"http://123.57.155.106:8080/labonline/zzwzController/queryNfList.do";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    NSLog(@"123456780");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *mainViewController=[[MainViewController alloc] init];
    //    mainViewController.view.backgroundColor=[UIColor grayColor];
    
    UINavigationController *mainNVC = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    
    LeftViewController *leftViewController=[[LeftViewController alloc]initWithNibName:nil bundle:nil];
    leftViewController.delegate=mainViewController;
    //    leftViewController.view.backgroundColor=[UIColor brownColor];
    
    UIViewController *rightViewController=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    rightViewController.view.backgroundColor=[UIColor purpleColor];
    
    _sideViewController=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
    _sideViewController.rootViewController=mainNVC;
    _sideViewController.leftViewController=leftViewController;
//    _sideViewController.rightViewController=rightViewController;
    
    
    _sideViewController.leftViewShowWidth=240;
    _sideViewController.needSwipeShowMenu=true;//默认开启的可滑动展示
    //动画效果可以被自己自定义，具体请看api
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault objectForKey:@"userName"];
//    if (name==nil) {
//        LoginViewController *loginVC=[[LoginViewController alloc] initWithNibName:nil bundle:nil];
//        loginVC.sideViewController=_sideViewController;
//        self.window.rootViewController=loginVC;
//    }else{
        self.window.rootViewController=_sideViewController;
//    }

//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PDFArray"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.window makeKeyAndVisible];
    
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

//QQ分享用到
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [TencentOAuth HandleOpenURL:url];

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}
//禁止横屏
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
