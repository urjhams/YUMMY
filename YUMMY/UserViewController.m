//
//  UserViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/4/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "UserViewController.h"
#import "UserRecipeCollectionViewCell.h"

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

- (IBAction)settingClick:(id)sender;
- (IBAction)toFollower:(id)sender;
- (IBAction)toLike:(id)sender;
- (IBAction)toBookmark:(id)sender;
- (IBAction)changeAvatar:(id)sender;

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
    
    [self setNeedsStatusBarAppearanceUpdate];// update lại màu status bar
    
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

- (IBAction)settingClick:(id)sender {
    
}

- (IBAction)toFollower:(id)sender {
    
}

- (IBAction)toLike:(id)sender {
    
}

- (IBAction)toBookmark:(id)sender {
    
}

- (IBAction)changeAvatar:(id)sender {
    
}

@end
