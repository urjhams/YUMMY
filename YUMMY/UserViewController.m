//
//  UserViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/4/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "UIImageView+AFNetworking.h"
#import "UserViewController.h"
#import "UserRecipeCollectionViewCell.h"
#import "TabBarController.h"
#import "userInfosSingleton.h"
#import "UserWhoFollowViewController.h"
#import "SearchResultViewController.h"
#import "recipeOfUser.h"
#import "RecipeContentViewController.h"

@interface UserViewController () {
    NSMutableArray *recipeObject;
    NSString *currentRecipeID;
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
- (IBAction)toMyRecipeContent:(id)sender;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!recipeObject) {
        recipeObject = [[NSMutableArray alloc] init];
    }
    
    self.userRecipeCollectionView.delegate = self;
    self.userRecipeCollectionView.dataSource = self;
    
    self.userRecipes.text = @"";
    self.userLike.text = @"";
    self.userBookmark.text = @"";
    self.userFolow.text = @"";
    
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
    
    //userInfo

    //useravatar
    /*
    userInfomaton = [[NSMutableArray alloc] init];
    userInfomaton = [[userInfosSingleton sharedUserInfos] userInfos];
    NSString *myAvatarName = [userInfomaton objectAtIndex:5];
    NSURL *avatarUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://yummy-quan.esy.es/avatar/%@",myAvatarName]];
    NSData *avatarData = [[NSData alloc] initWithContentsOfURL:avatarUrl];*/
    self.userAvatar.image = [[userInfosSingleton sharedUserAvatar] theUserAvatar];
    self.userAvatar.contentMode = UIViewContentModeScaleAspectFit;
    //self.userAvatar.image = [UIImage imageWithData:avatarData];

    self.userAccount.text = [NSString stringWithFormat:@"@%@",[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:1]];
    
    [self getRecipeByUser:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
    
    [self getUserInfoWithID:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
    
}

#pragma mark - getUserInfo (Asynchoronus)

- (void) getUserInfoWithID:(NSString *)userID {
    @try {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:@"UserID",userID, nil];
        [manager POST:@"http://yummy-quan.esy.es/get_user_info.php"
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *jsonData = (NSDictionary *)responseObject;
                  self.userRecipes.text = [NSString stringWithFormat:@"%ld",(long)jsonData[@"SoCongthucTao"]];
                  self.userLike.text = [NSString stringWithFormat:@"%ld",(long)jsonData[@"SoLike"]];
                  self.userBookmark.text = [NSString stringWithFormat:@"%ld",(long)jsonData[@"SoBookmark"]];
                  self.userFolow.text = [NSString stringWithFormat:@"%ld",(long)jsonData[@"SoNguoiFollow"]];

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
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:@"UserID",userID, nil];
        [manager POST:@"http://yummy-quan.esy.es/get_congthuc_created.php"
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
                      
                      if (!recipeObject) {
                          recipeObject = [[NSMutableArray alloc] initWithObjects:currentRecipe, nil];
                      } else {
                          [recipeObject addObject:currentRecipe];
                      }
                      
                  }
                  [self.userRecipeCollectionView reloadData];
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"Error:%@",error);
              }];
    } @catch (NSException *exception) {
        NSLog(@"EX:%@",exception);
    }
}

#pragma mark - lấy ảnh cho ô công thức (Asynchoronus)
- (void)setRecipeAvatarOfObject:(recipeOfUser *)theRecipeObject {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://yummy-quan.esy.es/congthuc/%@",theRecipeObject.recipeAvatar]];
    UIImageView *downloadImageView = [[UIImageView alloc] init];
    [downloadImageView setImageWithURL:url];
    theRecipeObject.avatarImg = downloadImageView.image;
    /*NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    theRecipeObject.avatarImg = image;
                });
            }
        }
    }];
    [dataTask resume];*/
}

#pragma mark - chỉnh màu status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [recipeObject count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserRecipeCollectionViewCell *cell = [self.userRecipeCollectionView dequeueReusableCellWithReuseIdentifier:@"UserRecipe" forIndexPath:indexPath];
    recipeOfUser *recipe = [recipeObject objectAtIndex:indexPath.item];
    cell.RecipeCate.text = recipe.recipeCate;
    cell.lblRecipeName.text = recipe.recipeName;
    //cell.recipeImage.image = recipe.avatarImg;        //dùng khi chạy setRecipeAvatarOfObject: ở getRecipeByUser:
    //getImage asynchoronus
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://yummy-quan.esy.es/congthuc/%@",recipe.recipeAvatar]];
    UIImageView *downloadImageView = [[UIImageView alloc] init];
    [downloadImageView setImageWithURL:url];
    UserRecipeCollectionViewCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    updateCell.recipeImage.image = downloadImageView.image;
    
    self.userRecipeCollectionViewHeight.constant = self.userRecipeCollectionView.contentSize.height;
    /*
    NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UserRecipeCollectionViewCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                    updateCell.recipeImage.image = image;
                });
            }
        }
    }];
    [dataTask resume];*/
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [[UIColor clearColor] CGColor];
    cell.layer.cornerRadius = 7.0f;
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width /2.2;
    CGFloat cellHeight = cellWidth * 1.36;
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - action


- (IBAction)toFollower:(id)sender {
    [self performSegueWithIdentifier:@"WhoFollowMe" sender:self];
}

- (IBAction)toLike:(id)sender {
    [self performSegueWithIdentifier:@"myLiked" sender:self];
}

- (IBAction)toBookmark:(id)sender {
    [self performSegueWithIdentifier:@"myBookmarked" sender:self];
}

- (IBAction)changeAvatar:(id)sender {
    //[self performSegueWithIdentifier:@"" sender:self];
}

- (IBAction)toSetting:(id)sender {
    //[self performSegueWithIdentifier:@"" sender:self];
}

- (IBAction)toMyRecipeContent:(id)sender {
    UIButton *thisButton = (UIButton *)sender;
    NSIndexPath *index = [NSIndexPath indexPathForItem:thisButton.tag inSection:0];
    if (recipeObject) {
        recipeOfUser *thisRecipe = [recipeObject objectAtIndex:index.item];
        if (!currentRecipeID) {
            currentRecipeID = [[NSString alloc] init];
        }
        currentRecipeID = thisRecipe.recipeID;
    }
    [self performSegueWithIdentifier:@"toRecipeContent" sender:self];
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"WhoFollowMe"]) {
        UserWhoFollowViewController *destVC = [segue destinationViewController];
        if (!destVC.myID) {
            destVC.myID = [[NSString alloc] init];
        }
        destVC.myID = [[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0];
    }
    if ([segue.identifier isEqualToString:@"myRecipe"]) {
        SearchResultViewController *destVC = [segue destinationViewController];
        destVC.key = 3;
    }
    if ([segue.identifier isEqualToString:@"myBookmarked"]) {
        SearchResultViewController *destVC = [segue destinationViewController];
        destVC.key = 4;
    }
    if ([segue.identifier isEqualToString:@"myLiked"]) {
        SearchResultViewController *destVC = [segue destinationViewController];
        destVC.key = 5;
    }
    if ([segue.identifier isEqualToString:@"toRecipeContent"]) {
        RecipeContentViewController *destVC = [segue destinationViewController];
        if (!destVC.inputRecipeID) {
            destVC.inputRecipeID = [[NSString alloc] init];
        }
        destVC.inputRecipeID = currentRecipeID;
    }
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
