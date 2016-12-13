//
//  SearchResultViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/25/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "SearchResultViewController.h"
#import "mainCell.h"
#import "mainScreenRecipe.h"
#import "RecipeContentViewController.h"
#import "userInfosSingleton.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "baseUrl.h"

@interface SearchResultViewController () {
    NSMutableArray *objectsArray;
}
@property (nonatomic) NSString *currentRecipeID;
@property (nonatomic) UIImage *currentRecipeAvatar;
@property (nonatomic) BOOL *isLiked;
@property (nonatomic) BOOL *isBookmarked;

@property (weak, nonatomic) IBOutlet UINavigationBar *theNavigationBar;
- (IBAction)backVC:(id)sender;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionViewController.prefetchDataSource = self;
    self.collectionViewController.dataSource = self;
    self.collectionViewController.delegate = self;
    
    self.theNavigationBar.barTintColor = [UIColor whiteColor];
    self.theNavigationBar.backgroundColor = [UIColor whiteColor];
    [self.theNavigationBar setAlpha:0.95];
    //NSString *navigationBarTitle;
    switch (self.key) {
        case 1: //recipes from suggest (loai cong thuc)
            [self getRecipesFromType:self.inputValue];
            //navigationBarTitle = [NSString stringWithFormat:@""];
            self.theNavigationBar.topItem.title = self.inputValue;
            break;
        
        case 2: //recipes from search results
            [self getRecipeResultWithKey:self.inputValue];
            //navigationBarTitle = [NSString stringWithFormat:@""];
            self.theNavigationBar.topItem.title = @"Kết quả tìm kiếm";
            break;
            
        case 3: //myRecipe
            [self getCreatedRecipes];
            //navigationBarTitle = [NSString stringWithFormat:@""];
            self.theNavigationBar.topItem.title = @"Công thức đã tạo";
            break;
            
        case 4: //myBookmarked
            [self getBookmarkedRecipes];
            //navigationBarTitle = [NSString stringWithFormat:@""];
            self.theNavigationBar.topItem.title = @"Công thức đã đánh dấu";
            break;
            
        case 5: //myLiked
            [self getLikedRecipes];
            //navigationBarTitle = [NSString stringWithFormat:@""];
            self.theNavigationBar.topItem.title = @"Công thức đã yêu thích";
            break;
            
        default:
            break;
    }
    //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:navigationBarTitle];
    //[self.theNavigationBar pushNavigationItem:item animated:YES];
}

#pragma mark - getMyrecipe (Asynchoronus)
- (void)getCreatedRecipes {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0],@"UserID", nil];
    [manager POST:get_congthuc_created
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                
                //recipe Object
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
                
                if (!objectsArray) {
                    objectsArray = [[NSMutableArray alloc] initWithObjects:recipeObject, nil];
                } else {
                    [objectsArray addObject:recipeObject];
                }
            }
            [self.collectionViewController reloadData];
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        } else {
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}
#pragma mark - getMyBookmarked recipes (Asynchornonus)
-(void)getBookmarkedRecipes {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0],@"UserID", nil];
    [manager POST:get_congthuc_bookmarked parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                
                //recipe Object
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
                
                if (!objectsArray) {
                    objectsArray = [[NSMutableArray alloc] initWithObjects:recipeObject, nil];
                } else {
                    [objectsArray addObject:recipeObject];
                }
            }
            [self.collectionViewController reloadData];
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        } else {
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}
#pragma mark - getMyLiked recipes(Asynchoronous)
-(void)getLikedRecipes {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0],@"UserID", nil];
    [manager POST:get_congthuc_liked parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                
                //recipe Object
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
                
                if (!objectsArray) {
                    objectsArray = [[NSMutableArray alloc] initWithObjects:recipeObject, nil];
                } else {
                    [objectsArray addObject:recipeObject];
                }
            }
            [self.collectionViewController reloadData];
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        } else {
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}

#pragma mark - getSearch result

- (void) getRecipeResultWithKey:(NSString *)keyValue {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:keyValue forKey:@"tukhoa"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_congthuc_search_by_name parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        if ([[jsonData objectForKey:@"code"] integerValue] == 1) {
            NSArray *rsArray = (NSArray *)[jsonData objectForKey:@"results"];
            for (int i = 0; i < rsArray.count; i++) {
                //values
                id recipeID = [[rsArray objectAtIndex:i] valueForKey:@"CongthucID"];
                
                id recipeName = [[rsArray objectAtIndex:i] valueForKey:@"Tencongthuc"];
                NSString *name = [NSString stringWithUTF8String:[recipeName cStringUsingEncoding:NSUTF8StringEncoding]];
                
                id recipeAvatarName = [[rsArray objectAtIndex:i] valueForKey:@"Avatar"];
                NSString *avatar = [NSString stringWithUTF8String:[recipeAvatarName cStringUsingEncoding:NSUTF8StringEncoding]];
                
                //id recipeLikes = [[rsArray objectAtIndex:i] valueForKey:@"Like"];
                
                id recipesMainCate = [[rsArray objectAtIndex:i] valueForKey:@"TenLoaicongthuc"];
                NSString *mainCate;
                if (recipesMainCate) {
                    mainCate = [NSString stringWithUTF8String:[recipesMainCate cStringUsingEncoding:NSUTF8StringEncoding]];
                } else {
                    mainCate = @"";
                }
                
                //recipe Object
                mainScreenRecipe *recipeObject = [[mainScreenRecipe alloc] init];
                recipeObject.recipeID = recipeID;           //ID công thức
                recipeObject.recipeName = name;             //tên công thức
                recipeObject.recipeAvatar = avatar;         //tên ảnh công thức
                //recipeObject.recipeLikes = recipeLikes;     //số likes của công thức
                recipeObject.recipeLikes = @"";
                recipeObject.recipeCate = mainCate;         //danh mục chính để hiển thị của công thức
                
                //kiểm tra xem công thức đã được like chưa - có thì nút like sẽ ở state selected và ngược lại
                [recipeObject recipeLiked:recipeID
                                   byUser:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
                //kiểm tra xem công thức đã được bookmark chưa - có thì nút bookmark sẽ ở state selected và ngược lại
                [recipeObject recipeBookmarked:recipeID
                                        byUser:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
                
                if (!objectsArray) {
                    objectsArray = [[NSMutableArray alloc] initWithObjects:recipeObject, nil];
                } else {
                    [objectsArray addObject:recipeObject];
                }
                [self.collectionViewController reloadData];
            }
        } else {
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - getSuggest result
- (void) getRecipesFromType:(NSString *)type {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:type forKey:@"LoaicongthucID"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_congthuc_loaicongthuc parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        if ([[jsonData objectForKey:@"code"] integerValue] == 1) {
            NSArray *rsArray = (NSArray *)[jsonData objectForKey:@"results"];
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
                
                //recipe Object
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
                
                if (!objectsArray) {
                    objectsArray = [[NSMutableArray alloc] initWithObjects:recipeObject, nil];
                } else {
                    [objectsArray addObject:recipeObject];
                }
                [self.collectionViewController reloadData];
            }
        } else {
            NSLog(@"%@",[jsonData objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - collectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [objectsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    mainCell *cell;
    
    //gọi lấy custom cell theo identifier
    if (indexPath.item % 2 == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nCell" forIndexPath:indexPath];
    }
    
    mainScreenRecipe *currentRecipe = [objectsArray objectAtIndex:indexPath.item];
    
    cell.recipeName.text = [NSString stringWithFormat:@"%@",currentRecipe.recipeName];
    cell.category.text = [NSString stringWithFormat:@"%@",currentRecipe.recipeCate];
    cell.recipeLike.text = [NSString stringWithFormat:@"%@",currentRecipe.recipeLikes];
    //getImage asynchoronus
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",folder_congthuc,currentRecipe.recipeAvatar]];
    [cell.image setImageWithURL:url];
    [cell.image setContentMode:UIViewContentModeScaleAspectFill];
    [cell.image setClipsToBounds:YES];
    
    if ([currentRecipe.likeRecipe isEqualToString:@"yes"]) {
        [cell.btnLike setSelected:YES];
    } else {
        [cell.btnLike setSelected:NO];
    }
    
    if ([currentRecipe.bookmarkRecipe isEqualToString:@"yes"]) {
        [cell.btnBookmark setSelected:YES];
    } else {
        [cell.btnBookmark setSelected:NO];
    }
    
    [cell.btnDetail addTarget:self action:@selector(presentDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLike addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnBookmark addTarget:self action:@selector(bookmarkClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(65, 10, 55, 10);  //top left bottom right
    return sectionInset;
}

#pragma mark - UICollectionviewPrefetchDataSoruce protocol
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}
- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}

- (IBAction)backVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - button like action
- (void)likeClick:(UIButton *)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.collectionViewController];
    NSIndexPath *indexPath = [self.collectionViewController indexPathForItemAtPoint:touchPoint];
    mainScreenRecipe * thisRecipe = [objectsArray objectAtIndex:indexPath.item];
    mainCell *thisCell = (mainCell *)sender.superview.superview;
    if ([sender isSelected]) {
        //thisCell.recipeLike.text = [NSString stringWithFormat:@"%ld",(long)([thisCell.recipeLike.text integerValue] - 1)];
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unlikeThisRecipe:thisRecipe.recipeID];
        
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
        [sender setSelected:NO];
        
    } else {
        //thisCell.recipeLike.text = [NSString stringWithFormat:@"%ld",(long)([thisCell.recipeLike.text integerValue] + 1)];
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] likeThisRecipe:thisRecipe.recipeID];
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
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.collectionViewController];
    NSIndexPath *indexPath = [self.collectionViewController indexPathForItemAtPoint:touchPoint];
    mainScreenRecipe * thisRecipe = [objectsArray objectAtIndex:indexPath.item];
    if ([sender isSelected]) {
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unbookmarkThisRecipe:thisRecipe.recipeID];
        [sender setSelected:NO];
    } else {
        [self me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] bookmarkThisRecipe:thisRecipe.recipeID];
        [sender setSelected:YES];
    }
}

//----------------------------------------------------------
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

#pragma mark - to recipecontent action
- (void)presentDetail:(UIButton *)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.collectionViewController];
    NSIndexPath *indexPath = [self.collectionViewController indexPathForItemAtPoint:touchPoint];
    if (objectsArray) {
        mainScreenRecipe * thisRecipe = [objectsArray objectAtIndex:indexPath.item];
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
