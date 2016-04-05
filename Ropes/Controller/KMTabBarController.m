//
//  KMTabBarController.m
//  Ropes
//
//  Created by Madoka on 16/3/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMTabBarController.h"
#import "UIImage+reSize.h"
#import "KMNavigationController.h"
@interface KMTabBarController ()
@property (nonatomic, strong) KMNavigationController *preferentialController;
@property (nonatomic, strong) KMNavigationController *walletController;
@property (nonatomic, strong) KMNavigationController *myInfoController;
@end

@implementation KMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubControllers];
}

- (void)createSubControllers
{
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:150.0/255 green:148.0/255 blue:148.0/255 alpha:1], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:208.0/255 green:41.0/255 blue:47.0/255 alpha:1], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    [self createPreferentialTab];
    [self createWalletTab];
    [self createMyInfoTab];
    self.viewControllers = @[self.preferentialController,
                             self.walletController,
                             self.myInfoController
                             ];
}

- (void)createPreferentialTab
{
    
    KMNavigationController *preferentialController = [[UIStoryboard storyboardWithName:@"KMLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"preferentialNavController"];
    UIImage *selectedImage = [[UIImage reSizeImage:[UIImage imageNamed:@"tag_normal"] toSize:CGSizeMake(20, 20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *unselectedImage = [[UIImage reSizeImage:[UIImage imageNamed:@"tag_highlight"] toSize:CGSizeMake(20, 20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    preferentialController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"优惠" image:unselectedImage selectedImage:selectedImage];
    
    self.preferentialController = preferentialController;
}

- (void)createWalletTab
{
    
    KMNavigationController *walletController = [[UIStoryboard storyboardWithName:@"KMLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"walletNavController"];
    
    UIImage *selectedImage = [[UIImage reSizeImage:[UIImage imageNamed:@"card_normal"] toSize:CGSizeMake(20, 20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *unselectedImage = [[UIImage reSizeImage:[UIImage imageNamed:@"card_highlight"] toSize:CGSizeMake(20, 20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    walletController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"钱包" image:unselectedImage selectedImage:selectedImage];
    
    self.walletController = walletController;
}

- (void)createMyInfoTab
{
    
    KMNavigationController *myInfoController = [[UIStoryboard storyboardWithName:@"KMLogin" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"myInfoNavController"];
    UIImage *selectedImage = [[UIImage reSizeImage:[UIImage imageNamed:@"user_normal"] toSize:CGSizeMake(20, 20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *unselectedImage = [[UIImage reSizeImage:[UIImage imageNamed:@"user_highlight"] toSize:CGSizeMake(20, 20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myInfoController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:unselectedImage selectedImage:selectedImage];
    
    self.myInfoController = myInfoController;
}
@end
