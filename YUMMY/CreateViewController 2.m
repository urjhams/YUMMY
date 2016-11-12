//
//  CreateViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/30/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CreateViewController.h"
#import "TabBarController.h"

@interface CreateViewController ()
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *createView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navibar;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Background
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.view.bounds];
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //[self.view addSubview:[[UIImageView alloc] initWithImage:self.background]];
    [self.view addSubview:blurEffectView];
    
    //gọi các subview lên trên blur effect view
    [self.view bringSubviewToFront:self.createView];
    [self.view bringSubviewToFront:self.navibar];
    
    //transparent navigation bar
    [self.navibar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navibar.shadowImage =[UIImage new];
    [self.navibar setTranslucent:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - ẩn navigation bar & tabbar
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
*/

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
