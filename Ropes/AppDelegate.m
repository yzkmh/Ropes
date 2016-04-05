//
//  AppDelegate.m
//  Ropes
//
//  Created by Madoka on 16/3/1.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "AppDelegate.h"
#import "KMNavigationController.h"
#import "KMUser.h"
#import "KMUserManager.h"
#import "KMTabBarController.h"
#import "KMLoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /* 添加tabBarController */
//    [self addTarBarController];
    
    [self setNav];
    // 读取本地账号信息
//    KMUser *localUser = [NSKeyedUnarchiver unarchiveObjectWithFile:kPATH];
//    if (localUser.isAutoLogin) {
//        [[KMUserManager getInstance] loginWithPhoneNum:localUser.phone password:localUser.pwd comlation:^(BOOL result, NSString *message, id user) {
//            
//            if (result) {
//                [KMUserManager getInstance].currentUser = user;
//                KMTabBarController *tabController = [[UIStoryboard storyboardWithName:@"KMLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabBarConroller"];
//                UIWindow *window = [[UIWindow alloc] initWithFrame:KMMainScreenBounds];
//                window.rootViewController = tabController;
//                [window makeKeyAndVisible];
//            } else
//            {
//                KMNavigationController *nav = [[UIStoryboard storyboardWithName:@"KMLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"navController"];
//                KMLoginViewController *loginVC = nav.topViewController;
//                loginVC.phoneNumTextField.text = localUser.phone;
//                loginVC.passwordTextField.text = localUser.pwd;
//                loginVC.autoLoginBtn.selected = localUser.isAutoLogin;
//                loginVC.remeberPwdBtn.selected = localUser.isRememberPwd;
//                
//                UIWindow *window = [[UIWindow alloc] initWithFrame:KMMainScreenBounds];
//                window.rootViewController = nav;
//                [window makeKeyAndVisible];
//            }
//        }];
//        
//    } else
//    {
//
//        KMNavigationController *nav = [[UIStoryboard storyboardWithName:@"KMLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"navController"];
//        KMLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"KMLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"loginViewController"];;
//        loginVC.phoneNumTextField.text = localUser.phone;
//        loginVC.passwordTextField.text = localUser.pwd;
//        loginVC.autoLoginBtn.selected = localUser.isAutoLogin;
//        loginVC.remeberPwdBtn.selected = localUser.isRememberPwd;
//        
//        UIWindow *window = [[UIWindow alloc] initWithFrame:KMMainScreenBounds];
//        window.rootViewController = nav;
//        [window makeKeyAndVisible];
//    }
    
    
    return YES;
}

// 设置全局导航条
- (void)setNav
{
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置显示的颜色
    bar.barTintColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0];
    //设置字体颜色
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setBackgroundImage:[UIImage imageNamed:@"bigBg"] forBarMetrics:UIBarMetricsDefault];
    //或者用这个都行
    [bar.backItem setTitle:@""];
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
