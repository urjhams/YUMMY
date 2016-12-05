//
//  RecipeContentViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "RecipeContentViewController.h"
#import "fullRecipeContentObject.h"
#import "userInfosSingleton.h"
#import "anotherUserViewController.h"
#import "stepObject.h"
#import "commentObject.h"
#import "commentTableViewCell.h"
#import "stepTableViewCell.h"

@interface RecipeContentViewController () {
    NSMutableArray *commentObjects;
    NSMutableArray *stepObjects;
    NSMutableArray *ingredientObjects;
    fullRecipeContentObject *thisRecipe;
}
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

@property (weak, nonatomic) IBOutlet UITableView *stepTableView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *theNaviBar;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (weak, nonatomic) IBOutlet UITableView *ingredientTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepTableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingredientTableViewHeight;

- (IBAction)backVC:(id)sender;
- (IBAction)clickLike:(id)sender;
- (IBAction)clickBookmark:(id)sender;
- (IBAction)clickComment:(id)sender;

- (void) whenScrolling:(UIScrollView *)scrollView;
@end

@implementation RecipeContentViewController
@synthesize inputRecipeAvatar;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lblLike.text = @"";
    self.lblForPerson.text = @"";
    self.lblTime.text = @"";
    self.lblDifficult.text = @"";
    self.lblUserName.text = @"";
    self.lblUserSay.text = @"";
    self.lblLike.text =@"";
    
    
    self.theNaviBar.backgroundColor = [UIColor darkGrayColor];
    //[self.theNaviBar setAlpha:0.7];
    [self.theNaviBar setBackgroundColor:[UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:0.65]];
    self.RecipeAvatar.contentMode = UIViewContentModeScaleToFill;
    
    [self.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
    [self.btnBookmark setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [self.btnBookmark setImage:[UIImage imageNamed:@"bookmarked"] forState:UIControlStateSelected];
    
    self.theNaviBar.hidden = YES;
    
    [self getRecipeByID:self.inputRecipeID];
    //[self getIngredientsWithRecipeID:self.inputRecipeID];
    //[self getStepsDataOfRecipe:self.inputRecipeID];
    //[self getCommentsDataOfRecipe:self.inputRecipeID];
    
    self.RecipeAvatar.image = self.inputRecipeAvatar;
    self.imgUserAvatar.contentMode = UIViewContentModeScaleAspectFill;
    self.imgUserAvatar.layer.cornerRadius = self.imgUserAvatar.frame.size.width / 2;
    [self.imgUserAvatar setClipsToBounds:YES];
    
    self.theScrollView.delegate = self;
    
    self.stepTableView.delegate = self;
    self.stepTableView.dataSource = self;
    
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
}

#pragma mark - get_congthuc (Asynchoronus)

- (void) getRecipeByID:(NSString *)theID {
    @try {
        NSURL *url =[NSURL URLWithString:@"http://yummy-quan.esy.es/get_congthuc_withID.php"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@",theID];
        NSString *postLenght = [NSString stringWithFormat:@"%lu",(unsigned long)[parameters length]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        [urlRequest setValue:postLenght forHTTPHeaderField:@"Content-lenght"];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if ([[jsonData objectForKey:@"code"] integerValue] == 1) {
                    NSMutableArray *rsArray = [jsonData objectForKey:@"results"];
                    
                    thisRecipe = [[fullRecipeContentObject alloc] init];
                    //trên webservice vẫn đẩy vào 1 array tuy nhiên chỉ có 1 phần tử tại index 0
                    thisRecipe.congthucid = [[rsArray objectAtIndex:0] valueForKey:@"CongthucID"];
                    thisRecipe.tencongthuc = [[rsArray objectAtIndex:0] valueForKey:@"Tencongthuc"];
                    thisRecipe.noidung = [[rsArray objectAtIndex:0] valueForKey:@"Noidung"];
                    thisRecipe.dokho = [[rsArray objectAtIndex:0] valueForKey:@"Dokho"];
                    thisRecipe.songuoi = [[rsArray objectAtIndex:0] valueForKey:@"Songuoi"];
                    thisRecipe.thoigian = [[rsArray objectAtIndex:0] valueForKey:@"Thoigian"];
                    thisRecipe.mota = [[rsArray objectAtIndex:0] valueForKey:@"Mota"];
                    thisRecipe.ngaytao = [[rsArray objectAtIndex:0] valueForKey:@"Ngaytao"];
                    thisRecipe.ngaysua = [[rsArray objectAtIndex:0] valueForKey:@"Ngaysua"];
                    thisRecipe.avatar = [[rsArray objectAtIndex:0] valueForKey:@"Avatar"];
                    thisRecipe.userid = [[rsArray objectAtIndex:0] valueForKey:@"UserID"];
                    thisRecipe.username = [[rsArray objectAtIndex:0] valueForKey:@"Username"];
                    thisRecipe.useravatar = [[rsArray objectAtIndex:0] valueForKey:@"UserAvatar"];
                    
                    //gán dữ liệu
                    
                    self.RecipeName.text = thisRecipe.tencongthuc;
                    //mình đã like công thức này chưa
                    [thisRecipe recipeLiked:thisRecipe.congthucid byUser:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
                    if (thisRecipe.liked == YES) {
                        [self.btnLike setSelected:YES];
                    } else {
                        [self.btnLike setSelected:NO];
                    }
                    //mình đã đánh dấu công thức này chưa
                    [thisRecipe recipeBookmarked:thisRecipe.congthucid byUser:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
                    if (thisRecipe.bookmarked == YES) {
                        [self.btnBookmark setSelected:YES];
                    } else {
                        [self.btnBookmark setSelected:NO];
                    }
                    self.lblUserName.text = thisRecipe.username;
                    self.lblUserSay.text = thisRecipe.mota;
                    self.lblDifficult.text = thisRecipe.dokho;
                    self.lblTime.text = thisRecipe.thoigian;
                    self.lblForPerson.text = thisRecipe.songuoi;
                    
                    [self getLikesOfRecipe:thisRecipe.congthucid];
                    NSURL *userAvatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://yummy-quan.esy.es/avatar/%@",thisRecipe.useravatar]];
                    NSURLSessionTask *dataTask3 = [[NSURLSession sharedSession] dataTaskWithURL:userAvatarURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        if (data) {
                            UIImage *rsImg = [UIImage imageWithData:data];
                            if (rsImg) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.imgUserAvatar.image = rsImg;
                                });
                            }
                        }
                    }];
                    [dataTask3 resume];
                    
                    NSLog(@"%@",[jsonData objectForKey:@"message"]);
                } else {
                    NSLog(@"%@",[jsonData objectForKey:@"message"]);
                }
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

#pragma mark - getLikes (Asynchoronus)

- (void) getLikesOfRecipe:(NSString *)recipeID {
    @try {
        NSURL *url =[NSURL URLWithString:@"http://yummy-quan.esy.es/get_congthucLikes_withID.php"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@",recipeID];
        NSString *postLenght = [NSString stringWithFormat:@"%lu",(unsigned long)[parameters length]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        [urlRequest setValue:postLenght forHTTPHeaderField:@"Content-lenght"];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                if ([[jsonData valueForKey:@"code"] integerValue] == 1) {
                    
                    NSArray *rsArray = [jsonData objectForKey:@"results"];
                    
                    id solike = [[rsArray objectAtIndex:0] valueForKey:@"Like"];
                    
                    self.lblLike.text = (NSString *)solike;
                    
                    NSLog(@"%@",[jsonData valueForKey:@"message"]);
                    
                } else {
                    
                    NSLog(@"%@",[jsonData valueForKey:@"message"]);
                }
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}


#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.commentTableView) {
        return commentObjects.count;
    }
    else {
        return stepObjects.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.commentTableView) {
        commentTableViewCell *cell = [self.commentTableView dequeueReusableCellWithIdentifier:@"commentContent" forIndexPath:indexPath];
        commentObject *currentObject = [commentObjects objectAtIndex:indexPath.row];
        cell.username.text = currentObject.username;
        cell.userComment.text = currentObject.noidung;
        cell.userAvatar.contentMode = UIViewContentModeScaleAspectFit;
        cell.userAvatar.layer.cornerRadius = cell.userAvatar.frame.size.width / 2;
        [cell.userAvatar setClipsToBounds:YES];
        NSURL *avatarUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://yummy-quan.esy.es/avatar/%@",currentObject.avatar]];
        NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:avatarUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.userAvatar.image = image;
                    });
                }
            }
        }];
        [dataTask resume];
        self.commentTableViewHeight.constant = self.commentTableView.contentSize.height;
        return cell;
    } else {
        stepTableViewCell *cell = [self.stepTableView dequeueReusableCellWithIdentifier:@"stepContent" forIndexPath:indexPath];
        stepObject *currentObject = [stepObjects objectAtIndex:indexPath.row];
        cell.lblStepNumber.text = [NSString stringWithFormat:@"Bước %@:",currentObject.sott];
        cell.stepContent.text = currentObject.noidung;
        cell.stepImg.contentMode = UIViewContentModeScaleAspectFit;
        cell.stepImg.layer.cornerRadius = cell.stepImg.frame.size.width / 2;
        [cell.stepImg setClipsToBounds:YES];
        NSURL *avatarUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://yummy-quan.esy.es/congthuc/%@",currentObject.avatar]];
        NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:avatarUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.stepImg.image = image;
                    });
                }
            }
        }];
        [dataTask resume];
        
        self.stepTableViewHeight.constant = self.stepTableView.contentSize.height;
        return cell;
    }
    
}

#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self whenScrolling:self.theScrollView];
}

#pragma mark - action

- (IBAction)backVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickLike:(id)sender {
    if ([sender isSelected]) {
        [thisRecipe me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unlikeThisRecipe:self.inputRecipeID];
        [self getLikesOfRecipe:self.inputRecipeID];
        [sender setSelected:NO];
    } else {
        [thisRecipe me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] likeThisRecipe:self.inputRecipeID];
        [self getLikesOfRecipe:self.inputRecipeID];
        [sender setSelected:YES];
    }
    
}

- (IBAction)clickBookmark:(id)sender {
    if ([sender isSelected]) {
        [thisRecipe me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unbookmarkThisRecipe:self.inputRecipeID];
        [sender setSelected:NO];
    } else {
        [thisRecipe me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] bookmarkThisRecipe:self.inputRecipeID];
        [sender setSelected:NO];
    }
}

- (IBAction)clickComment:(id)sender {
    [self performSegueWithIdentifier:@"toUserDetail" sender:self];
}


#pragma mark - segue:
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toUserDetail"]) {
        anotherUserViewController *destVC = [segue destinationViewController];
        destVC.thisUserID = thisRecipe.userid;
    }
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
