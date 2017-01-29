//
//  TabBarController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/20/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TabBarController.h"
#import "CreateViewController.h"
#import "UserViewController.h"

@interface TabBarController ()
@property (strong,nonatomic) UITabBarItem *currentItem;

@end

@implementation TabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    //class này là một tabBarController, nó không hẳn là 1 property của UITabBarController
    //nên không dùng self.tabBarController.delegate = self;
    
    //this class is a tabBarController, not really a property of UITabBarController so do not use self.tabBarController.delegate = self
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - UITabbarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}
*/
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[CreateViewController class]]) {
        CreateViewController *view = [tabBarController.storyboard instantiateViewControllerWithIdentifier:@"tab3"];
        //view.background = [self snapShot];
        view.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:view animated:YES completion:nil];
        return false;
    }
    return TRUE;
}
/*
#pragma mark - lấy màn hình hiện thời lưu vào làm 1 UIImage -- unused
- (UIImage *)snapShot {
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenShot;
}
*/
@end
