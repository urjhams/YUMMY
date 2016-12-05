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
#import "userInfosSingleton.h"

@interface SearchResultViewController () {
    NSMutableArray *objectsArray;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *theNavigationBar;
- (IBAction)backVC:(id)sender;

- (IBAction)btnLikeClick:(id)sender;
- (IBAction)btnBookmarkClick:(id)sender;
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
    
    switch (self.key) {
        case 1:
            
            break;
        
        case 2:
            
            break;
            
        case 3: //myRecipe
            [self getCreatedRecipes];
            break;
            
        case 4: //myBookmarked
            [self getBookmarkedRecipes];
            break;
            
        case 5: //myLiked
            [self getLikedRecipes];
            break;
            
        default:
            break;
    }
}

#pragma mark - getMyrecipe (Asynchoronus)
- (void)getCreatedRecipes {
    @try {
        NSURL *url = [NSURL URLWithString:@"http://yummy-quan.esy.es/get_congthuc_created.php"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *post = [[NSString alloc] initWithFormat:@"UserID=%@",[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLenght = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLenght forHTTPHeaderField:@"Content-lenght"];
        [urlRequest setHTTPBody:postData];
        //shareSession = asynchoronus task
        NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
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
                        NSString *mainCate = [NSString stringWithUTF8String:[recipesMainCate cStringUsingEncoding:NSUTF8StringEncoding]];
                        
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
                
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"Catch Exception: %@",exception);
    }
}
#pragma mark - getMyBookmarked recipes (Asynchornonus)
-(void)getBookmarkedRecipes {
    @try {
        NSURL *url = [NSURL URLWithString:@"http://yummy-quan.esy.es/get_congthuc_bookmarked.php"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *parameters = [NSString stringWithFormat:@"UserID=%@",(NSString *)[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        //shareSession = asynchoronus task
        NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
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
                        NSString *mainCate = [NSString stringWithUTF8String:[recipesMainCate cStringUsingEncoding:NSUTF8StringEncoding]];
                        
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
                
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"Catch Exception: %@",exception);
    }
}
#pragma mark - getMyLiked recipes(Asynchoronous)
-(void)getLikedRecipes {
    @try {
        NSURL *url = [NSURL URLWithString:@"http://yummy-quan.esy.es/get_congthuc_liked.php"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *parameters = [NSString stringWithFormat:@"UserID=%@",(NSString *)[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        //shareSession = asynchoronus task
        NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
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
                        NSString *mainCate = [NSString stringWithUTF8String:[recipesMainCate cStringUsingEncoding:NSUTF8StringEncoding]];
                        
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
                
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"Catch Exception: %@",exception);
    }
}
/*
#pragma mark - ẩn navigation bar
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

#pragma mark - hiện lại navigation bar khi sang view controller tiếp theo
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
*/
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://yummy-quan.esy.es/congthuc/%@",currentRecipe.recipeAvatar]];
    NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    mainCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                    updateCell.image.image = image;
                });
            }
        }
    }];
    [dataTask resume];
    
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
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(35, 10, 55, 10);  //top left bottom right
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

- (IBAction)btnLikeClick:(id)sender {
    UIButton *thisButton = (UIButton *)sender;
    NSIndexPath *index = [NSIndexPath indexPathForItem:thisButton.tag inSection:0];
    if (objectsArray) {
        mainScreenRecipe *thisRecipe = [objectsArray objectAtIndex:index.item];
        if ([sender isSelected]) {
            [thisRecipe me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unlikeThisRecipe:thisRecipe.recipeID];
            //reload cell
            switch (self.key) {
                case 1:
                    
                    break;
                    
                case 2:
                    
                    break;
                    
                case 3: //myRecipe
                    [self getCreatedRecipes];
                    break;
                    
                case 4: //myBookmarked
                    [self getBookmarkedRecipes];
                    break;
                    
                case 5: //myLiked
                    [self getLikedRecipes];
                    break;
                    
                default:
                    break;
            }
            [self.collectionViewController reloadItemsAtIndexPaths:[objectsArray objectAtIndex:index.item]];
        } else {
            [thisRecipe me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] likeThisRecipe:thisRecipe.recipeID];
            //reload cell
            switch (self.key) {
                case 1:
                    
                    break;
                    
                case 2:
                    
                    break;
                    
                case 3: //myRecipe
                    [self getCreatedRecipes];
                    break;
                    
                case 4: //myBookmarked
                    [self getBookmarkedRecipes];
                    break;
                    
                case 5: //myLiked
                    [self getLikedRecipes];
                    break;
                    
                default:
                    break;
            }
            [self.collectionViewController reloadItemsAtIndexPaths:[objectsArray objectAtIndex:index.item]];
        }
    }
}

- (IBAction)btnBookmarkClick:(id)sender {
    UIButton *thisButton = (UIButton *)sender;
    NSIndexPath *index = [NSIndexPath indexPathForItem:thisButton.tag inSection:0];
    if (objectsArray) {
        mainScreenRecipe *thisRecipe = [objectsArray objectAtIndex:index.item];
        if ([sender isSelected]) {
            [thisRecipe me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] unbookmarkThisRecipe:thisRecipe.recipeID];
            //reload cell
            switch (self.key) {
                case 1:
                    
                    break;
                    
                case 2:
                    
                    break;
                    
                case 3: //myRecipe
                    [self getCreatedRecipes];
                    break;
                    
                case 4: //myBookmarked
                    [self getBookmarkedRecipes];
                    break;
                    
                case 5: //myLiked
                    [self getLikedRecipes];
                    break;
                    
                default:
                    break;
            }
            [self.collectionViewController reloadItemsAtIndexPaths:[objectsArray objectAtIndex:index.item]];
            
        } else {
            [thisRecipe me:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] bookmarkThisRecipe:thisRecipe.recipeID];
            //reload cell
            switch (self.key) {
                case 1:
                    
                    break;
                    
                case 2:
                    
                    break;
                    
                case 3: //myRecipe
                    [self getCreatedRecipes];
                    break;
                    
                case 4: //myBookmarked
                    [self getBookmarkedRecipes];
                    break;
                    
                case 5: //myLiked
                    [self getLikedRecipes];
                    break;
                    
                default:
                    break;
            }
            [self.collectionViewController reloadItemsAtIndexPaths:[objectsArray objectAtIndex:index.item]];
        }
    }
}

@end
