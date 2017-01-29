//
//  MainViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "baseUrl.h"
#import "MainViewController.h"
#import "userInfosSingleton.h"
#import "mainScreenRecipe.h"
#import "mainCell.h"
#import "RecipeContentViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface MainViewController () {
    NSMutableArray *recipeObjects;
    BOOL endOfData;
}
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@property (nonatomic) NSString *currentRecipeID;
@property (nonatomic) UIImage *currentRecipeAvatar;
@property (nonatomic) BOOL *isLiked;
@property (nonatomic) BOOL *isBookmarked;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainCollectionView.prefetchDataSource = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    endOfData = FALSE;
    recipeObjects = [[NSMutableArray alloc] init];
    [self getRecipes];
    
}

#pragma mark - getRecipes

-(void) getRecipes {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    int parameters;
    if ([recipeObjects count] == 0) {
        parameters = -1;
    } else {
        mainScreenRecipe *last = [recipeObjects lastObject];
        parameters = (int)[last.recipeID integerValue];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:parameters],@"last_id", nil];
    
    [manager POST:get_congthuc_main
       parameters:params
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        NSArray *rsArray = [jsonData objectForKey:@"results"];
        id code = [jsonData objectForKey:@"code"];
        if ([code integerValue] == 1) {
            for (int i = 0; i < rsArray.count; i++) {
                //values
                id recipeID = [[rsArray objectAtIndex:i] valueForKey:@"CongthucID"];
                
                id recipeName = [[rsArray objectAtIndex:i] valueForKey:@"Tencongthuc"];
                NSString *name = [NSString stringWithUTF8String:[recipeName cStringUsingEncoding:NSUTF8StringEncoding]];
                
                id recipeAvatarName = [[rsArray objectAtIndex:i] valueForKey:@"Avatar"];
                NSString *avatar = [NSString stringWithUTF8String:[recipeAvatarName cStringUsingEncoding:NSUTF8StringEncoding]];
                
                id recipeLikes = [[rsArray objectAtIndex:i] valueForKey:@"Like"];
                
                id recipesMainCate = [[rsArray objectAtIndex:i] valueForKey:@"TenLoaicongthuc"];
                NSString *mainCate;
                if (recipesMainCate) {
                    mainCate = [NSString stringWithUTF8String:[recipesMainCate cStringUsingEncoding:NSUTF8StringEncoding]];
                } else {
                    mainCate = @"";
                }
                mainScreenRecipe *recipeObject = [[mainScreenRecipe alloc] init];
                recipeObject.recipeID = recipeID;           //ID công thức
                recipeObject.recipeName = name;             //tên công thức
                recipeObject.recipeAvatar = avatar;         //tên ảnh công thức
                recipeObject.recipeLikes = recipeLikes;     //số likes của công thức
                recipeObject.recipeCate = mainCate;         //danh mục chính để hiển thị của công thức
                
                /*
                //kiểm tra xem công thức đã được like chưa - có thì nút like sẽ ở state selected và ngược lại
                [recipeObject recipeLiked:recipeID
                                   byUser:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
                //kiểm tra xem công thức đã được bookmark chưa - có thì nút bookmark sẽ ở state selected và ngược lại
                [recipeObject recipeBookmarked:recipeID
                                        byUser:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];*/
                
                NSString *userID = [[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0];
                NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeObject.recipeID,@"CongthucID",userID,@"UserID", nil];
                [manager POST:get_bookmark
                   parameters:parameters
                     progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSDictionary *jsonData = (NSDictionary *)responseObject;
                         int code = (int)[jsonData[@"code"] integerValue];
                         if (code == 1) {
                             NSLog(@"%@",jsonData[@"message"]);
                             recipeObject.bookmarkRecipe = [NSString stringWithFormat:@"yes"];
                         } else {
                             NSLog(@"%@",jsonData[@"message"]);
                             recipeObject.bookmarkRecipe = [NSString stringWithFormat:@"no"];
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error:%@",error);
                     }];
                
                [manager POST:get_bookmark
                   parameters:parameters
                     progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSDictionary *jsonData = (NSDictionary *)responseObject;
                         int code = (int)[jsonData[@"code"] integerValue];
                         if (code == 1) {
                             NSLog(@"%@",jsonData[@"message"]);
                             recipeObject.bookmarkRecipe = [NSString stringWithFormat:@"yes"];
                         } else {
                             NSLog(@"%@",jsonData[@"message"]);
                             recipeObject.bookmarkRecipe = [NSString stringWithFormat:@"no"];
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error:%@",error);
                     }];
                
                if (!recipeObjects) {
                    recipeObjects = [[NSMutableArray alloc] initWithObjects:recipeObject, nil];
                } else {
                    [recipeObjects addObject:recipeObject];
                }
            }
            [self.mainCollectionView reloadData];
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
        else {
            endOfData = TRUE;
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"get_congthuc_main Error: %@", error);
    }];
}

#pragma mark - load more
//load more data when scroll down on bottom of main screen
- (void)loadMore {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    mainScreenRecipe *last = [recipeObjects lastObject];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:last.recipeID forKey:@"last_id"];
    [manager POST:get_congthuc_main
       parameters:params
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
              NSDictionary *jsonData = (NSDictionary *)responseObject;
              NSArray *rsArray = [jsonData objectForKey:@"results"];
              id code = [jsonData objectForKey:@"code"];
              if ([code integerValue] == 1) {
                  for (int i = 0; i < rsArray.count; i++) {
                      //values
                      id recipeID = [[rsArray objectAtIndex:i] valueForKey:@"CongthucID"];
                      
                      id recipeName = [[rsArray objectAtIndex:i] valueForKey:@"Tencongthuc"];
                      NSString *name = [NSString stringWithUTF8String:[recipeName cStringUsingEncoding:NSUTF8StringEncoding]];
                      
                      id recipeAvatarName = [[rsArray objectAtIndex:i] valueForKey:@"Avatar"];
                      NSString *avatar = [NSString stringWithUTF8String:[recipeAvatarName cStringUsingEncoding:NSUTF8StringEncoding]];
                      
                      id recipeLikes = [[rsArray objectAtIndex:i] valueForKey:@"Like"];
                      
                      id recipesMainCate = [[rsArray objectAtIndex:i] valueForKey:@"TenLoaicongthuc"];
                      NSString *mainCate;
                      if (recipesMainCate) {
                          mainCate = [NSString stringWithUTF8String:[recipesMainCate cStringUsingEncoding:NSUTF8StringEncoding]];
                      } else {
                          mainCate = @"";
                      }
                      
                      mainScreenRecipe *recipeObject = [[mainScreenRecipe alloc] init]; //create an object of recipe to show
                      recipeObject.recipeID = recipeID;           //ID công thức    --  recipeID
                      recipeObject.recipeName = name;             //tên công thức   --  recipe name
                      recipeObject.recipeAvatar = avatar;         //tên ảnh công thức-- recipe avatar name
                      recipeObject.recipeLikes = recipeLikes;     //số likes của công thức  -- like number of recipe
                      recipeObject.recipeCate = mainCate;         //danh mục chính để hiển thị của công thức -- category of recipe
                      
                      NSString *userID = [[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0];
                      NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeObject.recipeID,@"CongthucID",userID,@"UserID", nil];
                      [manager POST:get_bookmark
                         parameters:parameters
                           progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               NSDictionary *jsonData = (NSDictionary *)responseObject;
                               int code = (int)[jsonData[@"code"] integerValue];
                               if (code == 1) {
                                   NSLog(@"%@",jsonData[@"message"]);
                                   recipeObject.bookmarkRecipe = [NSString stringWithFormat:@"yes"];
                               } else {
                                   NSLog(@"%@",jsonData[@"message"]);
                                   recipeObject.bookmarkRecipe = [NSString stringWithFormat:@"no"];
                               }
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               NSLog(@"Error:%@",error);
                           }];
                      
                      [manager POST:get_bookmark
                         parameters:parameters
                           progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               NSDictionary *jsonData = (NSDictionary *)responseObject;
                               int code = (int)[jsonData[@"code"] integerValue];
                               if (code == 1) {
                                   NSLog(@"%@",jsonData[@"message"]);
                                   recipeObject.bookmarkRecipe = [NSString stringWithFormat:@"yes"];
                               } else {
                                   NSLog(@"%@",jsonData[@"message"]);
                                   recipeObject.bookmarkRecipe = [NSString stringWithFormat:@"no"];
                               }
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               NSLog(@"Error:%@",error);
                           }];
                      [recipeObjects addObject:recipeObject];
                  }
                    [self.mainCollectionView reloadData];
                    NSLog(@"%@",[jsonData objectForKey:@"message"]);
              }
              else {
                  endOfData = TRUE;
                  NSLog(@"%@",[jsonData objectForKey:@"message"]);
              }
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSLog(@"get_congthuc_main Error: %@", error);
          }];

}

#pragma mark - checkLike
//check like numbers of recipe
- (void)didLikeRecipe:(mainScreenRecipe *)recipe {
    NSString *userID = [[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:userID,@"UserID",recipe.recipeID,@"CongthucID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_like
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             int code = (int)[jsonData[@"code"] integerValue];
             if (code == 1) {
                 NSLog(@"%@",jsonData[@"message"]);
                 recipe.likeRecipe = [NSString stringWithFormat:@"yes"];
                 
             } else {
                 NSLog(@"%@",jsonData[@"message"]);
                 recipe.likeRecipe = [NSString stringWithFormat:@"no"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];

}

#pragma mark - checkBookmark
//check did the recipe had bookmark already
-(void)didBookmarkRecipe:(mainScreenRecipe *)recipe {
    NSString *userID = [[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipe.recipeID,@"CongthucID",userID,@"UserID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_bookmark
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             int code = (int)[jsonData[@"code"] integerValue];
             if (code == 1) {
                 NSLog(@"%@",jsonData[@"message"]);
                 recipe.bookmarkRecipe = [NSString stringWithFormat:@"yes"];
             } else {
                 NSLog(@"%@",jsonData[@"message"]);
                 recipe.bookmarkRecipe = [NSString stringWithFormat:@"no"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];

}

#pragma mark - like (synchoronus)
//like the recipe (when click the like button)
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

#pragma mark - collectionview delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return [self.imageArr count];
    return recipeObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    mainCell *cell;
    
    //gọi lấy custom cell theo identifier
    if (indexPath.item % 2 == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nCell" forIndexPath:indexPath];
    }
    
    
    [cell.btnDetail addTarget:self action:@selector(presentDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLike addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnBookmark addTarget:self action:@selector(bookmarkClick:) forControlEvents:UIControlEventTouchUpInside];
    
    mainScreenRecipe *currentRecipe = [recipeObjects objectAtIndex:indexPath.item];
    
    cell.recipeName.text = [NSString stringWithFormat:@"%@",currentRecipe.recipeName];
    cell.category.text = [NSString stringWithFormat:@"%@",currentRecipe.recipeCate];
    cell.recipeLike.text = [NSString stringWithFormat:@"%@",currentRecipe.recipeLikes];
    
    //[self didLikeRecipe:currentRecipe];
    //[self didBookmarkRecipe:currentRecipe];
    //getImage asynchoronus
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",folder_congthuc,currentRecipe.recipeAvatar]];
    [cell.image setImageWithURL:url];
    //currentRecipe.recipeAvatarImg = [[UIImage alloc] init];
    //currentRecipe.recipeAvatarImg = cell.image.image;
    cell.image.contentMode = UIViewContentModeScaleAspectFill;
    //set button image
    [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
    
    [cell.btnBookmark setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [cell.btnBookmark setImage:[UIImage imageNamed:@"bookmarked"] forState:UIControlStateSelected];
    
    /*
     if (currentRecipe.likeRecipe == YES) {
     [cell.btnLike setSelected:YES];
     } else {
     [cell.btnLike setSelected:NO];
     }
     
     if (currentRecipe.bookmarkRecipe == YES) {
     [cell.btnBookmark setSelected:YES];
     } else {
     [cell.btnBookmark setSelected:NO];
     }*/
    if ([currentRecipe.likeRecipe isEqualToString:@"yes"]) {
        [cell.btnLike setSelected:YES];
    } else {
        [cell.btnLike setSelected:NO];
    }
    
    if ([currentRecipe.bookmarkRecipe isEqualToString:@"no"]) {
        [cell.btnBookmark setSelected:YES];
    } else {
        [cell.btnBookmark setSelected:NO];
    }
    
    //set tag for buttons
    //[cell.btnLike setTag:indexPath.item];
    //[cell.btnBookmark setTag:indexPath.item];
     
    //chỉnh cho border của cell
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [[UIColor clearColor] CGColor];
    cell.layer.cornerRadius = 7.0f;
    //cell.category.layer.cornerRadius = 2.0;
    
    return cell;
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maxOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maxOffset - currentOffset <= 10.0) {
        [self loadMore];
    }
}
*/

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float height = size.height;
    
    float reload_distance = 6;
    if (y > height + reload_distance) {
        [self loadMore];
    }
}*/

// ---------------------------------load more cell------------------------------------------------------------
/*
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    int lastItem = (int)([recipeObjects count] - 1);
    if ((int)indexPath.item == lastItem) {
        [self getRecipes];
        [UIView transitionWithView: self.mainCollectionView
                          duration: 0.4f
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations: ^(void)
         {
             [self.mainCollectionView reloadData];
         }
                        completion: nil];
        
    }
}*/
//-------------------------------------------------------------------------------------------------------------

#pragma mark - collectionview cell size config
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 2 == 1) {
        CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width /2.2;
        CGFloat cellHeight = cellWidth * 1.6;
        return CGSizeMake(cellWidth, cellHeight);
    } else {
        CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width /2.2;
        CGFloat cellHeight = cellWidth * 2;
        return CGSizeMake(cellWidth, cellHeight);
    }
}

#pragma mark - điều chỉnh khoảng cách giữa cell với nhau và với viền

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(5, 10, 80, 10);  //top left bottom right
    return sectionInset;
}

#pragma mark - prefetchDataSource protocol
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}
- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}

#pragma mark - button like action
- (void)likeClick:(UIButton *)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.mainCollectionView];
    NSIndexPath *indexPath = [self.mainCollectionView indexPathForItemAtPoint:touchPoint];
    mainScreenRecipe * thisRecipe = [recipeObjects objectAtIndex:indexPath.item];
    mainCell *thisCell = (mainCell *)sender.superview.superview;
    if ([sender isSelected]) {
        //thisCell.recipeLike.text = [NSString stringWithFormat:@"%ld",(long)([thisCell.recipeLike.text integerValue] - 1)];
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unlikeThisRecipe:thisRecipe.recipeID];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:thisRecipe.recipeID,@"CongthucID", nil];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //refresh the like number
        [manager POST:get_congthucLikes_withID
           parameters:parameters
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *jsonData = (NSDictionary *)responseObject;
                 NSArray *rsArray = [jsonData objectForKey:@"results"];
                 if ([jsonData[@"code"] integerValue] == 1) {
                     NSString *like = [[rsArray objectAtIndex:0] valueForKey:@"Like"];
                     thisCell.recipeLike.text = like;
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"Error:%@",error);
             }];
        [sender setSelected:NO];
        
        } else {
        //thisCell.recipeLike.text = [NSString stringWithFormat:@"%ld",(long)([thisCell.recipeLike.text integerValue] + 1)];
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] likeThisRecipe:thisRecipe.recipeID];
            //refresh the like number
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:thisRecipe.recipeID,@"CongthucID", nil];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:get_congthucLikes_withID
               parameters:parameters
                 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSDictionary *jsonData = (NSDictionary *)responseObject;
                     NSArray *rsArray = [jsonData objectForKey:@"results"];
                     if ([jsonData[@"code"] integerValue] == 1) {
                         NSString *like = [[rsArray objectAtIndex:0] valueForKey:@"Like"];
                         thisCell.recipeLike.text = like;
                     }
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"Error:%@",error);
                 }];

        [sender setSelected:YES];
        }
}

#pragma mark - button bookmark action
- (void)bookmarkClick:(UIButton *)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.mainCollectionView];
    NSIndexPath *indexPath = [self.mainCollectionView indexPathForItemAtPoint:touchPoint];
    mainScreenRecipe * thisRecipe = [recipeObjects objectAtIndex:indexPath.item];
    if ([sender isSelected]) {
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unbookmarkThisRecipe:thisRecipe.recipeID];
        [sender setSelected:NO];
    } else {
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] bookmarkThisRecipe:thisRecipe.recipeID];
        [sender setSelected:YES];
    }
}

#pragma mark - to recipecontent action
- (void)presentDetail:(UIButton *)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.mainCollectionView];
    NSIndexPath *indexPath = [self.mainCollectionView indexPathForItemAtPoint:touchPoint];
    if (recipeObjects) {
        mainScreenRecipe * thisRecipe = [recipeObjects objectAtIndex:indexPath.item];
        //self.currentRecipeAvatar = thisRecipe.recipeAvatarImg;
        self.currentRecipeID = thisRecipe.recipeID;
    }
    UICollectionViewCell *thisCell = [self.mainCollectionView cellForItemAtIndexPath:indexPath];
    mainCell *diesenCell = (mainCell *)thisCell;
    self.currentRecipeAvatar = diesenCell.image.image;
    [self performSegueWithIdentifier:@"recipeContent" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"recipeContent"]) {
        RecipeContentViewController *destVC = [segue destinationViewController];
        destVC.inputRecipeAvatar = self.currentRecipeAvatar;
        destVC.inputRecipeID = [NSString stringWithFormat:@"%@",self.currentRecipeID];
    } if ([segue.identifier isEqualToString:@""]) {
        
    }
}

@end
