//
//  SearchResultViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/25/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "SearchResultViewController.h"
#import "mainCell.h"

@interface SearchResultViewController ()
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (strong, nonatomic) NSMutableArray *categoryArr;
@property (strong, nonatomic) NSMutableArray *nameArr;
@property (strong, nonatomic) NSMutableArray *likeArr;
@property (strong, nonatomic) NSMutableArray *selectedArr;
@property (weak, nonatomic) IBOutlet UINavigationBar *theNavigationBar;

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
    //[self.theNavigationBar setAlpha:0.7];
    
    //thay code lấy dữ liệu dưới đây
    self.imageArr = [NSMutableArray arrayWithObjects:@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png", nil];
    self.categoryArr = [NSMutableArray arrayWithObjects:@"Món Ý",@"Món Pháp",@"Món Xào",@"Low Carb",@"Món chay",@"Ăn kiêng", nil];
    self.nameArr = [NSMutableArray arrayWithObjects:@"Đùi gà nướng bơ",@"TacoBell sốt Mayone",@"Bánh mỳ quét mayone sốt cà chua",@"Đùi gà nướng bơ",@"TacoBell sốt Mayone",@"Bánh mỳ quét mayone sốt cà chua", nil];
    self.likeArr = [NSMutableArray arrayWithObjects:@"123",@"324",@"222",@"154",@"2004",@"353", nil];
    self.selectedArr = [NSMutableArray arrayWithObjects:@"yes",@"no",@"no",@"no",@"no",@"no", nil];
    
    
    //để cuối hàm!!!
    //self.tabBarController.selectedIndex = 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.imageArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    mainCell *cell;
    
    //gọi lấy custom cell theo identifier
    if (indexPath.item % 2 == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nCell" forIndexPath:indexPath];
    }
    
    //gán dữ liệu
    cell.image.image = [UIImage imageNamed:[self.imageArr objectAtIndex:indexPath.item]];
    cell.recipeName.text = [NSString stringWithFormat:@"%@",[self.nameArr objectAtIndex:indexPath.item]];
    cell.category.text = [NSString stringWithFormat:@"%@",[self.categoryArr objectAtIndex:indexPath.item]];
    cell.recipeLike.text = [NSString stringWithFormat:@"%@",[self.likeArr objectAtIndex:indexPath.item]];
    
    //gọi giá trị arr chứa các string yes no để làm cơ sở cho việc chọn selected của button
    //thay ở đây bằng 1 giá trị nào đó từ csdl để biết xem người dùng đã lựa chọn like hay bookmark chưa
    NSString *selectedString = [NSString stringWithFormat:@"%@",[self.selectedArr objectAtIndex:indexPath.item]];
    if ([selectedString isEqualToString:@"yes"]) {
        [cell.btnLike setSelected:YES];
        [cell.btnBookmark setSelected:YES];
    } else {
        [cell.btnLike setSelected:NO];
        [cell.btnBookmark setSelected:NO];
    }
    
    //set button image
    [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
    
    [cell.btnBookmark setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [cell.btnBookmark setImage:[UIImage imageNamed:@"bookmarked"] forState:UIControlStateSelected];
    
    //[cell.btnLike setAdjustsImageWhenHighlighted:NO];
    //[cell.btnBookmark setAdjustsImageWhenHighlighted:NO];
    
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
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(54, 10, 55, 10);  //top left bottom right
    return sectionInset;
}

#pragma mark - UICollectionviewPrefetchDataSoruce protocol
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}
- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}

- (IBAction)btnLikeClick:(id)sender {
    if ([sender isSelected]) {
        // thêm code thay đổi dữ liệu vào đây

        [sender setSelected:NO];
    } else {
        //[sender setHighlighted:NO];
        [sender setSelected:YES];
    }
}

- (IBAction)btnBookmarkClick:(id)sender {
    if ([sender isSelected]) {
        // thêm code thay đổi dữ liệu vào đây
        
        [sender setSelected:NO];
    } else {
        //[sender setHighlighted:NO];
        [sender setSelected:YES];
    }
}
@end
