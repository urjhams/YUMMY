//
//  UserViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/4/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "UserViewController.h"
#import "UserRecipeCollectionViewCell.h"
#import "ViewController.h"

@interface UserViewController () {
    NSMutableArray *recipeID;
    NSMutableArray *recipeImg;
    NSMutableArray *recipeName;
    NSMutableArray *recipeCate;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userAccount;
@property (weak, nonatomic) IBOutlet UILabel *userRecipes;
@property (weak, nonatomic) IBOutlet UILabel *userFolow;
@property (weak, nonatomic) IBOutlet UILabel *userBookmark;
@property (weak, nonatomic) IBOutlet UILabel *userLike;
@property (weak, nonatomic) IBOutlet UICollectionView *userRecipeCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userRecipeCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UINavigationBar *theNaviBar;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;

- (IBAction)toFollower:(id)sender;
- (IBAction)toLike:(id)sender;
- (IBAction)toBookmark:(id)sender;
- (IBAction)changeAvatar:(id)sender;
- (IBAction)toSetting:(id)sender;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userRecipeCollectionView.delegate = self;
    self.userRecipeCollectionView.dataSource = self;
    
    //round avatar
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2;
    [self.userAvatar setClipsToBounds:YES];
    
    //cover
    self.imgCover.image = [UIImage imageNamed:@"cover-default"];
    
    [self.btnSetting setImage:[UIImage imageNamed:@"settingbtn-white"] forState:UIControlStateNormal];
    self.theNaviBar.backgroundColor = [UIColor darkGrayColor];
    [self.theNaviBar setAlpha:0.65];
    self.theNaviBar.hidden = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];// update lại màu status bar
    //self.myInfos = userInfoArr;
    //NSLog(@"%@",self.myInfos);
    
}


#pragma mark - chỉnh màu status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [recipeName count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserRecipeCollectionViewCell *cell = [self.userRecipeCollectionView dequeueReusableCellWithReuseIdentifier:@"UserRecipe" forIndexPath:indexPath];
    
    cell.recipeImage.image = [UIImage imageNamed:[recipeImg objectAtIndex:indexPath.item]];
    cell.RecipeCate.text = [NSString stringWithFormat:@"%@",[recipeCate objectAtIndex:indexPath.item]];
    cell.lblRecipeName.text = [NSString stringWithFormat:@"%@",[recipeName objectAtIndex:indexPath.item]];
    
    self.userRecipeCollectionViewHeight.constant = self.userRecipeCollectionView.contentSize.height;
    
    return cell;
}

#pragma mark - điều chỉnh khoảng cách giữa cell với nhau và với viền

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(-15, 10, 55, 10);  //top left bottom right
    return sectionInset;
}

#pragma mark - collectionview cell size config
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width /2.2;
    CGFloat cellHeight = cellWidth * 1.36;
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - action


- (IBAction)toFollower:(id)sender {
    
}

- (IBAction)toLike:(id)sender {
    
}

- (IBAction)toBookmark:(id)sender {
    
}

- (IBAction)changeAvatar:(id)sender {
    
}

- (IBAction)toSetting:(id)sender {
}

#pragma mark - navibar hidden/show
- (void)whenScrolling:(UIScrollView *)scrollView effectNavibar:(UINavigationBar *)naviBar {
    float offSetY = scrollView.contentOffset.y;
    if (offSetY < 60) {
        
        if (self.btnSetting.hidden == YES) [self.btnSetting setHidden:NO];
        
        if (naviBar.hidden == NO) {
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^(void) {
                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                                 if (offSetY >50) {
                                     [naviBar setAlpha:0.5];
                                     [naviBar setHidden:NO];
                                     [self.btnSetting setAlpha:0.2];
                                 } else if (offSetY > 45) {
                                     [naviBar setAlpha:0.35];
                                     [naviBar setHidden:NO];
                                     [self.btnSetting setAlpha:0.35];
                                 } else if (offSetY > 40) {
                                     [naviBar setAlpha:0.2];
                                     [naviBar setHidden:NO];
                                     [self.btnSetting setAlpha:0.5];
                                 } else if (offSetY > 35) {
                                     [naviBar setAlpha:0.15];
                                     [naviBar setHidden:NO];
                                     [self.btnSetting setAlpha:0.8];
                                 } else {
                                     [naviBar setHidden:YES];
                                     [self.btnSetting setAlpha:1];
                                 }
                             }
                             completion:nil];
        }
        
    }
    else {
        
        if (self.btnSetting.hidden == NO) [self.btnSetting setHidden:YES];
        
        if (naviBar.hidden == YES) {
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^(void) {
                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                                 [naviBar setAlpha:0.65];
                                 [naviBar setHidden:NO];
                             }
                             completion:nil];
        }
        
    }
}


@end
