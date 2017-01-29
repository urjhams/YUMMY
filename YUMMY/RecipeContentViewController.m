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
#import "ingredientObject.h"
#import "commentTableViewCell.h"
#import "stepTableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "baseUrl.h"

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
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;

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

- (void) whenScrolling:(UIScrollView *)scrollView;
@end

@implementation RecipeContentViewController
@synthesize inputRecipeAvatar;
@synthesize inputRecipeID;
@synthesize liked;
@synthesize bookmarked;
- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.btnLike.adjustsImageWhenHighlighted = NO;
    self.btnBookmark.adjustsImageWhenHighlighted = NO;
    
    self.theScrollView.delegate = self;
    
    self.stepTableView.delegate = self;
    self.stepTableView.dataSource = self;
    
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    
    self.ingredientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.stepTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.theNaviBar.backgroundColor = [UIColor darkGrayColor];
    //[self.theNaviBar setAlpha:0.7];
    [self.theNaviBar setBackgroundColor:[UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:0.65]];
    self.RecipeAvatar.contentMode = UIViewContentModeScaleAspectFill;
    
    commentObjects = [[NSMutableArray alloc] init];
    stepObjects = [[NSMutableArray alloc] init];
    ingredientObjects = [[NSMutableArray alloc] init];
    
    [self.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
    [self.btnBookmark setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [self.btnBookmark setImage:[UIImage imageNamed:@"bookmarked"] forState:UIControlStateSelected];
    [self.btnLike setSelected:self.liked];
    [self.btnBookmark setSelected:self.bookmarked];
    //self.theNaviBar.hidden = YES;
    
    [self getRecipeByID:self.inputRecipeID];
    [self getLikesOfRecipe:self.inputRecipeID];
    [self getIngredientsOfRecipe:self.inputRecipeID];
    [self getStepsOfRecipe:self.inputRecipeID];
    [self getCommentsOfRecipe:self.inputRecipeID];
    
    self.RecipeAvatar.image = self.inputRecipeAvatar;
    self.RecipeAvatar.contentMode = UIViewContentModeScaleAspectFill;
    [self.RecipeAvatar setClipsToBounds:YES];
    
    self.imgUserAvatar.contentMode = UIViewContentModeScaleAspectFill;
    self.imgUserAvatar.layer.cornerRadius = self.imgUserAvatar.frame.size.width / 2;
    [self.imgUserAvatar setClipsToBounds:YES];
}

#pragma mark - get_congthuc (Asynchoronus)

- (void) getRecipeByID:(NSString *)theID {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:theID,@"CongthucID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_congthuc_withID
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             NSLog(@"JSON: %@",responseObject);
             if ([jsonData[@"code"] integerValue] == 1) {
                 
                 NSArray *rsArray = (NSArray *)[jsonData objectForKey:@"results"];
                 
                 thisRecipe = [[fullRecipeContentObject alloc] init];
                 
                 //trên webservice vẫn đẩy vào 1 array tuy nhiên chỉ có 1 phần tử tại index 0
                 //the result on webservice will return 1 array with 1 object at index 0
                 
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
                 NSLog(@"object: %@",(NSDictionary *)thisRecipe);
                 
                 self.RecipeName.text = thisRecipe.tencongthuc;
                 
                 NSMutableDictionary *recipeIDparam = [[NSMutableDictionary alloc] init];
                 [recipeIDparam setObject:theID forKey:@"CongthucID"];
                 //mình đã like công thức này chưa
                 //check did like already
                 AFHTTPSessionManager *checkLikeManager = [AFHTTPSessionManager manager];
                 [checkLikeManager POST:get_like parameters:recipeIDparam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"JSON Liked: %@",responseObject);
                     NSDictionary *jsonData = (NSDictionary *)responseObject;
                     if ([[jsonData valueForKey:@"code"] integerValue] == 1) {
                         [self setLiked:YES];
                         //[self.btnLike setSelected:YES];
                         NSLog(@"%@",[jsonData objectForKey:@"message"]);
                     } else {
                         [self setLiked:false];
                         //[self.btnLike setSelected:NO];
                         NSLog(@"%@",[jsonData objectForKey:@"message"]);
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"error: %@",error);
                 }];
                 
                 //mình đã đánh dấu công thức này chưa
                 //check did bookmark already
                 AFHTTPSessionManager *checkBookmarkManager = [AFHTTPSessionManager manager];
                 [checkBookmarkManager POST:get_bookmark parameters:recipeIDparam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"JSON bookmarked: %@",responseObject);
                     NSDictionary *jsonData = (NSDictionary *)responseObject;
                     if ([[jsonData valueForKey:@"code"] integerValue] == 1) {
                         [self.btnBookmark setSelected:YES];
                         NSLog(@"%@",[jsonData objectForKey:@"message"]);
                     } else {
                         [self.btnBookmark setSelected:NO];
                         NSLog(@"%@",[jsonData objectForKey:@"message"]);
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"Error: %@",error);
                 }];
                 
                 self.lblUserName.text = [NSString stringWithFormat:@"@%@",thisRecipe.username];
                 self.lblUserSay.text = thisRecipe.mota;
                 self.lblDifficult.text = [NSString stringWithFormat:@"Độ khó : %@",thisRecipe.dokho];
                 self.lblTime.text = [NSString stringWithFormat:@"Thời gian : %@ phút",thisRecipe.thoigian];
                 self.lblForPerson.text = [NSString stringWithFormat:@"Dành cho : %@ người",thisRecipe.songuoi];
                 
                 NSURL *userAvatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",folder_avatar,thisRecipe.useravatar]];
                 [self.imgUserAvatar setImageWithURL:userAvatarURL];
                 
                 
                 NSLog(@"%@",jsonData[@"message"]);
             } else {
                 NSLog(@"%@",jsonData[@"message"]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];

}

#pragma mark - getLikes (Asynchoronus)

- (void) getLikesOfRecipe:(NSString *)recipeID {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeID,@"CongthucID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_congthucLikes_withID parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        NSLog(@"jsondata: %@",jsonData);
        NSLog(@"responeObj: %@",responseObject);
        if ([[jsonData valueForKey:@"code"] integerValue] == 1) {
            
            NSArray *rsArray = [jsonData objectForKey:@"results"];
            
            NSString * solike = (NSString *)[[rsArray objectAtIndex:0] valueForKey:@"Like"];
            
            self.lblLike.text = [NSString stringWithFormat:@"%@",solike];
            
            NSLog(@"%@",[jsonData valueForKey:@"message"]);
        } else {
            
            NSLog(@"%@",[jsonData valueForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - get steps

- (void)getStepsOfRecipe:(NSString *)recipeID {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:recipeID forKey:@"CongthucID"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_buoclam_congthuc parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        NSArray *rsArray = [jsonData objectForKey:@"results"];
        if ([[jsonData objectForKey:@"code"] integerValue] == 1) {
            for (int i = 0; i < rsArray.count; i++) {
                
                stepObject *thisStep = [[stepObject alloc] init];
                thisStep.buocid = (NSString *)[[rsArray objectAtIndex:i] valueForKey:@"BuocID"];
                thisStep.noidung = (NSString *)[[rsArray objectAtIndex:i] valueForKey:@"Noidung"];
                thisStep.congthucid = (NSString *)[[rsArray objectAtIndex:i] valueForKey:@"CongthucID"];
                thisStep.sott = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"SoTT"];
                thisStep.avatar = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Avatar"];
                thisStep.ngaytao = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Ngaytao"];
                thisStep.ngaysua = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Ngaysua"];
                
                if (!stepObjects) {
                    stepObjects = [[NSMutableArray alloc] init];
                }
                [stepObjects addObject:thisStep];
                NSLog(@"%@",thisStep.noidung);
            }
            [self.stepTableView reloadData];
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        } else {
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@",error);
    }];
}

#pragma mark - get comment

- (void)getCommentsOfRecipe:(NSString *)recipeID {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:recipeID forKey:@"CongthucID"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_comment_congthuc parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        NSArray *rsArray = [jsonData objectForKey:@"results"];
        if ([[jsonData objectForKey:@"code"] integerValue] == 1) {
            for (int i = 0; i < rsArray.count; i++) {
                
                commentObject *thisComment = [[commentObject alloc] init];
                thisComment.commentid = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"CommentID"];
                thisComment.noidung = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Noidung"];
                thisComment.ngaytao = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Ngaytao"];
                thisComment.ngaysua = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Ngaysua"];
                thisComment.congthucid = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"CongthuaID"];
                thisComment.userid = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"UserID"];
                thisComment.username = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Username"];
                thisComment.avatar = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Avatar"];
                
                if (!commentObjects) {
                    commentObjects = [[NSMutableArray alloc] init];
                }
                [commentObjects addObject:thisComment];
            }
            [self.commentTableView reloadData];
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        } else {
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@",error);
    }];
}

#pragma mark - get ingredient

- (void)getIngredientsOfRecipe:(NSString *)recipeID {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:recipeID forKey:@"CongthucID"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_nguyenlieu_congthuc parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        NSArray *rsArray = [jsonData objectForKey:@"results"];
        if ([[jsonData objectForKey:@"code"] integerValue] == 1) {
            for (int i = 0; i < rsArray.count; i++) {
                
                ingredientObject *thisIngredient = [[ingredientObject alloc] init];
                thisIngredient.nguyenlieuID = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"NguyenlieuID"];
                thisIngredient.dinhluong = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Dinhluong"];
                thisIngredient.tennguyenlieu = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Tennguyenlieu"];
                thisIngredient.donvi = [(NSString *)[rsArray objectAtIndex:i] valueForKey:@"Donvi"];
                
                if (!ingredientObjects) {
                    ingredientObjects = [[NSMutableArray alloc] init];
                }
                [ingredientObjects addObject:thisIngredient];
            }
            [self.ingredientTableView reloadData];
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        } else {
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@",error);
    }];
}

#pragma mark - checkLike
- (void)didLikeRecipe:(fullRecipeContentObject *)recipe {
    NSString *userID = [[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:userID,@"UserID",recipe.congthucid,@"CongthucID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_like
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             int code = (int)[jsonData[@"code"] integerValue];
             if (code == 1) {
                 NSLog(@"%@",jsonData[@"message"]);
                 recipe.liked = YES;
             } else {
                 NSLog(@"%@",jsonData[@"message"]);
                 recipe.liked = NO;
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];
    
}

#pragma mark - checkBookmark
-(void)didBookmarkRecipe:(fullRecipeContentObject *)recipe {
    NSString *userID = [[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipe.congthucid,@"CongthucID",userID,@"UserID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_bookmark
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             int code = (int)[jsonData[@"code"] integerValue];
             if (code == 1) {
                 NSLog(@"%@",jsonData[@"message"]);
                 recipe.bookmarked = YES;
             } else {
                 NSLog(@"%@",jsonData[@"message"]);
                 recipe.bookmarked = NO;
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];
    
}

#pragma mark - like (synchoronus)
- (void) me:(NSString *)userID likeThisRecipe:(NSString *)recipeID {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeID,@"CongthucID",userID,@"UserID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:like_congthuc
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             if ([jsonData[@"code"] integerValue] == 1) {
                 NSLog(@"%@",jsonData[@"message"]);
             } else {
                 NSLog(@"%@",jsonData[@"message"]);
             }
             [self getLikesOfRecipe:self.inputRecipeID];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];
}
#pragma mark - unlike (synchoronus)
- (void) me:(NSString *)userID unlikeThisRecipe:(NSString *)recipeID {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeID,@"CongthucID",userID,@"UserID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:unlike_congthuc
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             if ([jsonData[@"code"] integerValue] == 1) {
                 NSLog(@"%@",jsonData[@"message"]);
             } else {
                 NSLog(@"%@",jsonData[@"message"]);
             }
             [self getLikesOfRecipe:self.inputRecipeID];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];
}
#pragma mark - bookmark (synchoronus)
- (void) me:(NSString *)userID bookmarkThisRecipe:(NSString *)recipeID {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeID,@"CongthucID",userID,@"UserID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:bookmark_congthuc
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             if ([jsonData[@"code"] integerValue] == 1) {
                 NSLog(@"%@",jsonData[@"message"]);
             } else {
                 NSLog(@"%@",jsonData[@"message"]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];
}
#pragma mark - unbookmark (synchoronus)
- (void) me:(NSString *)userID unbookmarkThisRecipe:(NSString *)recipeID {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeID,@"CongthucID",userID,@"UserID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:unbookmark_congthuc
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             if ([jsonData[@"code"] integerValue] == 1) {
                 NSLog(@"%@",jsonData[@"message"]);
             } else {
                 NSLog(@"%@",jsonData[@"message"]);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];
}


#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.commentTableView) {
        return commentObjects.count;
    } else if (tableView == self.ingredientTableView) {
        return ingredientObjects.count;
    }
    else {
        return stepObjects.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.commentTableView) {
        commentTableViewCell *cell = [self.commentTableView dequeueReusableCellWithIdentifier:@"commentContent" forIndexPath:indexPath];
        commentObject *currentObject = (commentObject *)[commentObjects objectAtIndex:indexPath.row];
        cell.username.text = currentObject.username;
        cell.userComment.text = currentObject.noidung;
        cell.userAvatar.contentMode = UIViewContentModeScaleAspectFit;
        cell.userAvatar.layer.cornerRadius = cell.userAvatar.frame.size.width / 2;
        [cell.userAvatar setClipsToBounds:YES];
        NSURL *avatarUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",folder_avatar,currentObject.avatar]];
        [cell.userAvatar setImageWithURL:avatarUrl];
        [cell.userAvatar setClipsToBounds:YES];
        self.commentTableViewHeight.constant = self.commentTableView.contentSize.height;
        return cell;
    } else if (tableView == self.ingredientTableView) {
        UITableViewCell *cell = [self.ingredientTableView dequeueReusableCellWithIdentifier:@"ingredientCell" forIndexPath:indexPath];
        ingredientObject *currentObject = (ingredientObject *)[ingredientObjects objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@ %@",
                               currentObject.tennguyenlieu,
                               currentObject.dinhluong,
                               currentObject.donvi];
        return cell;
    } else {
        stepTableViewCell *cell = [self.stepTableView dequeueReusableCellWithIdentifier:@"stepContent" forIndexPath:indexPath];
        stepObject *currentObject = (stepObject *)[stepObjects objectAtIndex:indexPath.row];
        cell.lblStepNumber.text = [NSString stringWithFormat:@"Bước %@:",currentObject.sott];
        cell.stepContent.text = currentObject.noidung;
        
        cell.stepImg.contentMode = UIViewContentModeScaleAspectFit;
        [cell.stepImg setClipsToBounds:YES];
        NSURL *avatarUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",folder_congthuc,currentObject.avatar]];
        [cell.stepImg setImageWithURL:avatarUrl];
        [cell.stepImg setClipsToBounds:YES];
        self.stepTableViewHeight.constant = self.stepTableView.contentSize.height;
        return cell;
    }
    
}


#pragma mark - action

- (IBAction)backVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickLike:(id)sender {
    if ([sender isSelected]) {
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unlikeThisRecipe:self.inputRecipeID];
        [sender setSelected:NO];
    } else {
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] likeThisRecipe:self.inputRecipeID];
        [sender setSelected:YES];
    }
    
}

- (IBAction)clickBookmark:(id)sender {
    if ([sender isSelected]) {
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unbookmarkThisRecipe:self.inputRecipeID];
        [sender setSelected:NO];
    } else {
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] bookmarkThisRecipe:self.inputRecipeID];
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


#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //[self whenScrolling:self.theScrollView];
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

#pragma mark - ẩn keyboard khi chạm bên ngoài đối tượng textfield

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
