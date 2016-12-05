//
//  MainViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "MainViewController.h"
#import "userInfosSingleton.h"
#import "mainScreenRecipe.h"
#import "mainCell.h"
#import "RecipeContentViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface MainViewController () {
    NSMutableArray *recipeObjects;
    uint offset;
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
    
    offset = 0;
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
    
    [manager POST:@"http://yummy-quan.esy.es/get_cong_thuc_main.php"
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
                //kiểm tra xem công thức đã được like chưa - có thì nút like sẽ ở state selected và ngược lại
                [recipeObject recipeLiked:recipeID
                                   byUser:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
                //kiểm tra xem công thức đã được bookmark chưa - có thì nút bookmark sẽ ở state selected và ngược lại
                [recipeObject recipeBookmarked:recipeID
                                        byUser:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
                
                if (!recipeObjects) {
                    recipeObjects = [[NSMutableArray alloc] initWithObjects:recipeObject, nil];
                } else {
                    [recipeObjects addObject:recipeObject];
                }
            }
            [self.mainCollectionView reloadData];
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        } else {
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - like (synchoronus)
- (void) me:(NSString *)userID likeThisRecipe:(NSString *)recipeID {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeID,@"CongthucID",userID,@"UserID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://yummy-quan.esy.es/like_congthuc.php"
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
    [manager POST:@"http://yummy-quan.esy.es/unlike_congthuc.php"
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
    [manager POST:@"http://yummy-quan.esy.es/bookmark_congthuc.php"
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
    [manager POST:@"http://yummy-quan.esy.es/unbookmark_congthuc.php"
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
    
    cell.btnDetail.tag = indexPath.item;
    cell.btnLike.tag = indexPath.item;
    cell.btnBookmark.tag = indexPath.item;
    
    [cell.btnDetail addTarget:self action:@selector(presentDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLike addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnBookmark addTarget:self action:@selector(bookmarkClick:) forControlEvents:UIControlEventTouchUpInside];
    
    mainScreenRecipe *currentRecipe = [recipeObjects objectAtIndex:indexPath.item];
    
    cell.recipeName.text = [NSString stringWithFormat:@"%@",currentRecipe.recipeName];
    cell.category.text = [NSString stringWithFormat:@"%@",currentRecipe.recipeCate];
    cell.recipeLike.text = [NSString stringWithFormat:@"%@",currentRecipe.recipeLikes];
    //getImage asynchoronus
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://yummy-quan.esy.es/congthuc/%@",currentRecipe.recipeAvatar]];
    [cell.image setImageWithURL:url];
    currentRecipe.recipeAvatarImg = cell.image.image;
    //UIImageView *imaged;
    //[imaged setImageWithURL:url];
    //cell.image.image = imaged.image;
    //currentRecipe.recipeAvatarImg = imaged.image;
    /*
    NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.image.image = image;
                    currentRecipe.recipeAvatarImg = image;
                });
            }
        }
    }];
    [dataTask resume];*/
    cell.image.contentMode = UIViewContentModeScaleAspectFill;
    
    //cell.recipeID = currentRecipe.recipeID;


    if (currentRecipe.likeRecipe == YES) {
        [cell.btnLike setSelected:YES];
    } else {
        [cell.btnLike setSelected:NO];
    }
    
    if (currentRecipe.bookmarkRecipe == YES) {
        [cell.btnBookmark setSelected:YES];
    } else {
        [cell.btnBookmark setSelected:NO];
    }
    
    //set button image
    [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
    
    [cell.btnBookmark setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [cell.btnBookmark setImage:[UIImage imageNamed:@"bookmarked"] forState:UIControlStateSelected];
    
    
    //set tag for buttons
    [cell.btnLike setTag:indexPath.item];
    [cell.btnBookmark setTag:indexPath.item];
    
    //điều chỉnh size của label tăng lên khi dữ liệu hiển thị dài hơn
    //[cell.recipeName sizeToFit];
    //[cell.category sizeToFit];
     
    //chỉnh cho border của cell
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [[UIColor clearColor] CGColor];
    cell.layer.cornerRadius = 7.0f;
    //cell.category.layer.cornerRadius = 2.0;
    
    
    return cell;
}

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

#pragma mark = button like action
- (void)likeClick:(UIButton *)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.mainCollectionView];
    NSIndexPath *indexPath = [self.mainCollectionView indexPathForItemAtPoint:touchPoint];
    mainScreenRecipe * thisRecipe = [recipeObjects objectAtIndex:indexPath.item];
    mainCell *thisCell = (mainCell *)sender.superview.superview;
    if ([sender isSelected]) {
        //thisCell.recipeLike.text = [NSString stringWithFormat:@"%ld",(long)([thisCell.recipeLike.text integerValue] - 1)];
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unlikeThisRecipe:thisRecipe.recipeID];
        [sender setSelected:NO];
        
        } else {
        //thisCell.recipeLike.text = [NSString stringWithFormat:@"%ld",(long)([thisCell.recipeLike.text integerValue] + 1)];
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] likeThisRecipe:thisRecipe.recipeID];
        [sender setSelected:YES];
        }
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:thisRecipe.recipeID,@"CongthucID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://yummy-quan.esy.es/get_congthucLikes_withID.php"
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
        self.currentRecipeAvatar = thisRecipe.recipeAvatarImg;
        self.currentRecipeID = thisRecipe.recipeID;
    }
    [self performSegueWithIdentifier:@"recipeContent" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"recipeContent"]) {
        RecipeContentViewController *destVC = [segue destinationViewController];
        destVC.inputRecipeID = [NSString stringWithFormat:@"%@",self.currentRecipeID];
        destVC.inputRecipeAvatar = self.currentRecipeAvatar;
    }
}

@end
