//
//  anotherUserViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "UIImageView+AFNetworking.h"
#import "anotherUserViewController.h"
#import "UserRecipeCollectionViewCell.h"
#import "recipeOfUser.h"
#import "RecipeContentViewController.h"
#import "baseUrl.h"

@interface anotherUserViewController () {
    NSMutableArray *recipeObjects;
    NSString *currentRecipeID;
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
    
    recipeObjects = [[NSMutableArray alloc] init];
    
    //self.userImg.image = self.thisUserAvatar;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.width / 2;
    self.userImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.userImg setClipsToBounds:YES];
    self.lblUsername.text = [NSString stringWithFormat:@"@%@",self.thisUsername];
    
    self.lblRecipeNumber.text = @"";
    self.lblLikeNumber.text = @"";
    self.lblBookmarkNumber.text = @"";
    self.lblFollowNumber.text = @"";
    
    [self.theNavibar setBackgroundColor:[UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:0.6]];
    [self.theNavibar setHidden:YES];
    
    //cover
    self.coverImg.image = [UIImage imageNamed:@"cover-default"];
    
    [self setNeedsStatusBarAppearanceUpdate];// update lại màu status bar
    
    
    [self getUserInfoWithID:self.thisUserID];

}

- (void) getUserInfoWithID:(NSString *)userID {
    @try {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:userID,@"UserID", nil];
        [manager POST:get_user_info
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *jsonData = (NSDictionary *)responseObject;
                  self.lblRecipeNumber.text = [NSString stringWithFormat:@"%ld",(long)jsonData[@"SoCongthucTao"]];
                  self.lblLikeNumber.text = [NSString stringWithFormat:@"%ld",(long)jsonData[@"SoLike"]];
                  self.lblBookmarkNumber.text = [NSString stringWithFormat:@"%ld",(long)jsonData[@"SoBookmark"]];
                  self.lblFollowNumber.text = [NSString stringWithFormat:@"%ld",(long)jsonData[@"SoNguoiFollow"]];
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"Error:%@",error);
              }];
    } @catch (NSException *exception) {
        NSLog(@"EX:%@",exception);
    }
}

#pragma mark - getUser's Recipe created (Asynchoronus)

- (void) getRecipeByUser:(NSString *)userID {
    @try {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:userID,@"UserID", nil];
        [manager POST:get_congthuc_created
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *jsonData = (NSDictionary *)responseObject;
                  NSMutableArray *rsArray = [jsonData objectForKey:@"results"];
                  for (int i = 0; i < rsArray.count; i++) {
                      id recipeID = [[rsArray objectAtIndex:i] valueForKey:@"CongthucID"];
                      id recipeName = [[rsArray objectAtIndex:i] valueForKey:@"Tencongthuc"];
                      NSString *name = [NSString stringWithUTF8String:[recipeName cStringUsingEncoding:NSUTF8StringEncoding]];
                      id recipeAvatarName = [[rsArray objectAtIndex:i] valueForKey:@"Avatar"];
                      NSString *avatar = [NSString stringWithUTF8String:[recipeAvatarName cStringUsingEncoding:NSUTF8StringEncoding]];
                      id recipeCate = [[rsArray objectAtIndex:i] valueForKey:@"TenLoaicongthuc"];
                      NSString *cate = [NSString stringWithUTF8String:[recipeCate cStringUsingEncoding:NSUTF8StringEncoding]];
                      
                      recipeOfUser *currentRecipe = [[recipeOfUser alloc] init];
                      currentRecipe.recipeID = recipeID;
                      currentRecipe.recipeName = name;
                      currentRecipe.recipeCate = cate;
                      currentRecipe.recipeAvatar = avatar;
                      //[self setRecipeAvatarOfObject:currentRecipe];     //tạm thời không dùng vì đang gán hàm ở cellForItemAtIndexPath
                      
                      if (!recipeObjects) {
                          recipeObjects = [[NSMutableArray alloc] initWithObjects:currentRecipe, nil];
                      } else {
                          [recipeObjects addObject:currentRecipe];
                      }
                      
                  }
                  [self.recipeCollectionview reloadData];
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"Error:%@",error);
              }];
    } @catch (NSException *exception) {
        NSLog(@"EX:%@",exception);
    }
}

#pragma mark - lấy ảnh cho ô công thức (Asynchoronus)
- (void)setRecipeAvatarOfObject:(recipeOfUser *)theRecipeObject {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",folder_congthuc,theRecipeObject.recipeAvatar]];
    UIImageView *downloadImageView = [[UIImageView alloc] init];
    [downloadImageView setImageWithURL:url];
    theRecipeObject.avatarImg = downloadImageView.image;
}

#pragma mark - chỉnh màu status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [recipeObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserRecipeCollectionViewCell *cell = [self.recipeCollectionview dequeueReusableCellWithReuseIdentifier:@"UserRecipe" forIndexPath:indexPath];
    recipeOfUser *recipe = [recipeObjects objectAtIndex:indexPath.item];
    cell.RecipeCate.text = recipe.recipeCate;
    cell.lblRecipeName.text = recipe.recipeName;
    //getImage asynchoronus
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",folder_congthuc,recipe.recipeAvatar]];
    [cell.recipeImage setImageWithURL:url];
    cell.recipeImage.contentMode = UIViewContentModeScaleAspectFill;
    self.recipeCollectionviewHeight.constant = self.recipeCollectionview.contentSize.height;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [[UIColor clearColor] CGColor];
    cell.layer.cornerRadius = 7.0f;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width /2.5;
    CGFloat cellHeight = cellWidth * 1.5;
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - điều chỉnh khoảng cách giữa cell với nhau và với viền

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(5, 10, 30, 10);  //top left bottom right
    return sectionInset;
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
