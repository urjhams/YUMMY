//
//  RecipeContentViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "RecipeContentViewController.h"

@interface RecipeContentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *RecipeAvatar;
@property (weak, nonatomic) IBOutlet UILabel *RecipeName;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnBookmark;
@property (weak, nonatomic) IBOutlet UILabel *lblLike;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserSay;
@property (weak, nonatomic) IBOutlet UILabel *lblDifficult;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblForPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblIngredient;
@property (weak, nonatomic) IBOutlet UITableView *stepTableView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *theNaviBar;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepTableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingredientsContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutContentHeight;

- (IBAction)backVC:(id)sender;

- (void) whenScrolling:(UIScrollView *)scrollView;
@end

@implementation RecipeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.theScrollView.delegate = self;

    self.theNaviBar.backgroundColor = [UIColor darkGrayColor];
    //[self.theNaviBar setAlpha:0.7];
    [self.theNaviBar setBackgroundColor:[UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:0.65]];
    self.RecipeAvatar.contentMode = UIViewContentModeScaleAspectFill;
    
    //self.RecipeAvatar.image = [UIImage imageNamed:@"cover-default"];

    
    self.theNaviBar.hidden = YES;
    //[self.theNaviBar setFrame:CGRectMake(0, 0, 320, 300)];
    
    //[self whenScrollviewScroll:self.theScrollView];
    
}

#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self whenScrolling:self.theScrollView];
}

#pragma mark - action

- (IBAction)backVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - hide/show navbar
- (void)whenScrolling:(UIScrollView *)scrollView {
    float offSetY = scrollView.contentOffset.y;
    if (offSetY < 60) {
        if (self.theNaviBar.hidden == NO) {
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^(void) {
                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                                 if (offSetY >50) {
                                     [self.theNaviBar setAlpha:0.5];
                                     [self.theNaviBar setHidden:NO];
                                 } else if (offSetY > 45) {
                                     [self.theNaviBar setAlpha:0.35];
                                     [self.theNaviBar setHidden:NO];
                                 } else if (offSetY > 40) {
                                     [self.theNaviBar setAlpha:0.2];
                                     [self.theNaviBar setHidden:NO];
                                 } else if (offSetY > 35) {
                                     [self.theNaviBar setAlpha:0.15];
                                     [self.theNaviBar setHidden:NO];
                                 } else {
                                     [self.theNaviBar setHidden:YES];
                                 }
                             }
                             completion:nil];
        }
    }
    else {
        if (self.theNaviBar.hidden == YES) {
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^(void) {
                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                                 [self.theNaviBar setAlpha:1];
                                 [self.theNaviBar setHidden:NO];
                             }
                             completion:nil];
        }
    }
}


@end
