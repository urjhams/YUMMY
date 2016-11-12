//
//  CreateViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/30/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

//#import <QuartzCore/QuartzCore.h>
#import "CreateViewController.h"
#import "cateCell.h"


@interface CreateViewController ()
//array hold value
{
    NSMutableArray *cateArray;
    NSMutableArray *ingredientArray;
    NSMutableArray *stepArray;
}
//outlet
@property (weak, nonatomic) IBOutlet UITextField *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *cateCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cateCollectionViewHeight;

@property (weak, nonatomic) IBOutlet UITableView *ingredientTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingredientTablewViewHeight;

@property (weak, nonatomic) IBOutlet UITableView *stepTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepTableViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *btnDifficult;
@property (weak, nonatomic) IBOutlet UIButton *btnPerson;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UIButton *addAvatar;
@property (weak, nonatomic) IBOutlet UITextView *txtAbout;

- (IBAction)CancelCreate:(id)sender;
- (IBAction)Create:(id)sender;
- (IBAction)addStep:(id)sender;
- (IBAction)addStepImage:(id)sender;


@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Background
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.view.bounds];
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];
    
    
    [self.txtAbout sizeToFit];
    [self.txtAbout layoutIfNeeded];
    
    //transparent navigation bar
    [self.naviBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.naviBar setShadowImage:[UIImage new]];
    [self.naviBar setTranslucent:YES];
    
    
    [self.view bringSubviewToFront:self.naviBar];
    [self.view bringSubviewToFront:self.scrollView];
    
    //delegate & datasource
    self.stepTableView.dataSource = self;
    self.stepTableView.delegate = self;
    self.cateCollectionView.dataSource = self;
    self.cateCollectionView.delegate = self;
    self.ingredientTableView.delegate = self;
    self.ingredientTableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate & datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.stepTableView) {
        UITableViewCell *cell = [self.stepTableView dequeueReusableCellWithIdentifier:@"stepCell" forIndexPath:indexPath];
        
        
        self.stepTableViewHeight.constant = self.stepTableView.contentSize.height;  //resize
        
        return cell;
    }  else {
        UITableViewCell *cell = [self.ingredientTableView dequeueReusableCellWithIdentifier:@"ingredientCell" forIndexPath:indexPath];
        //cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.ingredientArray objectAtIndex:indexPath.row]];
        
        self.ingredientTablewViewHeight.constant = self.ingredientTableView.contentSize.height; //resize
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row;
    if (tableView == self.stepTableView) {
        row = [stepArray count];
    } else if (tableView == self.ingredientTableView) {
        row = ingredientArray.count;
    }
    return row;
}

#pragma mark - collectionview delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    cateCell *cell;
    cell = [self.cateCollectionView dequeueReusableCellWithReuseIdentifier:@"cateCell" forIndexPath:indexPath];
    cell.category.text = [NSString stringWithFormat:@"%@",[cateArray objectAtIndex:indexPath.item]];
    [cell.category intrinsicContentSize];
    self.cateCollectionViewHeight.constant = self.cateCollectionView.contentSize.height;    //resize
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize valuesize = [(NSString *)[cateArray objectAtIndex:indexPath.item] sizeWithAttributes:NULL];
    CGFloat cellWidth = valuesize.width + 8;
    CGFloat cellHeight = 15;
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - action

- (IBAction)CancelCreate:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Create:(id)sender {
    
}

- (IBAction)addStep:(id)sender {
    
}

- (IBAction)addStepImage:(id)sender {
}

- (IBAction)addPerson:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lựa chọn số suất ăn của công thức" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"2 người" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"2 người" forState:UIControlStateNormal];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"4 người" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"4 người" forState:UIControlStateNormal];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"6 người" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"6 người" forState:UIControlStateNormal];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"8 người" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"8 người" forState:UIControlStateNormal];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:action5];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)addTime:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lựa chọn thời gian hoàn thành công thức" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"15 phút" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"15 phút" forState:UIControlStateNormal];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"30 phút" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"30 phút" forState:UIControlStateNormal];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"60 phút" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"60 phút" forState:UIControlStateNormal];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"90 phút" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"90 phút" forState:UIControlStateNormal];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"2 tiếng" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"2 tiếng" forState:UIControlStateNormal];
    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:action5];
    [alert addAction:action6];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)addLevel:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lựa chọn độ khó của công thức" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Dễ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"Dễ" forState:UIControlStateNormal];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Trung bình" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"Trung bình" forState:UIControlStateNormal];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Khó" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"Khó" forState:UIControlStateNormal];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"Rất khó" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [sender setTitle:@"Rất khó" forState:UIControlStateNormal];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:action5];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)addCate:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thêm danh mục" message:@"lựa chọn danh mục của công thức" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!cateArray) {
            cateArray = [[NSMutableArray alloc] initWithObjects:@"Init", nil];
            [self.cateCollectionView reloadData];
        } else {
            [cateArray addObject:@"New Category"];
            [UIView transitionWithView: self.cateCollectionView
                              duration: 0.4f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void)
             {
                 [self.cateCollectionView reloadData];
             }
                            completion: nil];
        }
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)addIngredient:(id)sender {
    if (!ingredientArray) {
        ingredientArray = [[NSMutableArray alloc] initWithObjects:@"new ingredient", nil];
        [self.ingredientTableView reloadData];
    } else {
        [ingredientArray addObject:@"new ingredient"];
        [UIView transitionWithView: self.ingredientTableView
                          duration: 0.4f
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations: ^(void)
         {
             [self.ingredientTableView reloadData];
             //[self.infoView resizeToFitSubviews];
         }
                        completion: nil];
    }
}

- (IBAction)addAvatar:(id)sender {
    
}


@end
