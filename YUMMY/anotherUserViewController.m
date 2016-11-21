//
//  anotherUserViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "anotherUserViewController.h"
#import "UserRecipeCollectionViewCell.h"

@interface anotherUserViewController () {
    NSMutableArray *imgArr;
    NSMutableArray *cateArr;
    NSMutableArray *nameArr;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *theNavibar;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblBookmarkNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblLikeNumber;
@property (weak, nonatomic) IBOutlet UICollectionView *recipeCollectionview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recipeCollectionviewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollview;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

- (IBAction)backVC:(id)sender;
- (IBAction)follow:(id)sender;
@end

@implementation anotherUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recipeCollectionview.delegate = self;
    self.recipeCollectionview.dataSource = self;
    self.theScrollview.delegate = self;
    
    
}

#pragma mark - delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return nameArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserRecipeCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"UserRecipe" forIndexPath:indexPath];
    cell.recipeImage = [imgArr objectAtIndex:indexPath.item];
    cell.RecipeCate = [cateArr objectAtIndex:indexPath.item];
    cell.lblRecipeName = [nameArr objectAtIndex:indexPath.item];
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


#pragma mark - scrollviewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self whenScrolling:self.theScrollview effectNavibar:self.theNavibar];
}

#pragma mark - action

- (IBAction)backVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)follow:(id)sender {
    
}

#pragma mark - show/hide navibar

- (void)whenScrolling:(UIScrollView *)scrollView effectNavibar:(UINavigationBar *)naviBar {
    float offSetY = scrollView.contentOffset.y;
    if (offSetY < 60) {
        
        if (self.btnBack.hidden == YES) [self.btnBack setHidden:NO];
        if (self.btnFollow.hidden == YES) [self.btnFollow setHidden:NO];
        
        if (naviBar.hidden == NO) {
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^(void) {
                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                                 if (offSetY >50) {
                                     [naviBar setAlpha:0.5];
                                     [naviBar setHidden:NO];
                                     [self.btnFollow setAlpha:0.2];
                                     [self.btnBack setAlpha:0.2];
                                 } else if (offSetY > 45) {
                                     [naviBar setAlpha:0.35];
                                     [naviBar setHidden:NO];
                                     [self.btnFollow setAlpha:0.35];
                                     [self.btnBack setAlpha:0.35];
                                 } else if (offSetY > 40) {
                                     [naviBar setAlpha:0.2];
                                     [naviBar setHidden:NO];
                                     [self.btnFollow setAlpha:0.5];
                                     [self.btnBack setAlpha:0.5];
                                 } else if (offSetY > 35) {
                                     [naviBar setAlpha:0.15];
                                     [naviBar setHidden:NO];
                                     [self.btnFollow setAlpha:0.8];
                                     [self.btnBack setAlpha:0.8];
                                 } else {
                                     [naviBar setHidden:YES];
                                     [self.btnFollow setAlpha:1];
                                     [self.btnBack setAlpha:1];
                                 }
                             }
                             completion:nil];
        }

    }
    else {
        
        if (self.btnBack.hidden == NO) [self.btnBack setHidden:YES];
        if (self.btnFollow.hidden == NO) [self.btnFollow setHidden:YES];
        
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
