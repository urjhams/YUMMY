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
#import "stepCell.h"
#import "recipeAvatarViewController.h"
#import "recipeIngredientViewController.h"


@interface CreateViewController ()
//array hold value
{
    int step;
    
    //mảng để lưu giá trị
    NSMutableArray *cateArray;                      //mảng các category name sẽ lưu để gửi lên
    NSMutableArray *cateIDArray;                    //mảng các categoryID sẽ lưu để gửi lên
    
    //mảng để lấy giá trị từ json về để hiện trên phần lựa chọn
    NSMutableArray *cateArrayToGet;                 //mảng các category sẽ lấy trên server
    NSMutableArray *cateIDArrayToGet;               //mảng các category ID sẽ lấy trên server
    
    //mảng để lưu giá trị
    NSMutableArray *ingredientArray;
    NSMutableArray *ingredientIDArray;          //mảng các ID nguyên liệu (thuôc tính ID của ingredient cell)
    NSMutableArray *ingredientUnitArray;
    
    
    NSMutableArray *stepArray;
    NSMutableArray *stepContentArr;
    NSMutableArray *stepImgArr;

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

@property (weak, nonatomic) IBOutlet UITextView *txtAbout;

@property (strong, nonatomic) UIImage *RecipeAvatar;

- (IBAction)CancelCreate:(id)sender;
- (IBAction)Create:(id)sender;
- (IBAction)addStep:(id)sender;
- (IBAction)addStepImage:(id)sender;
- (IBAction)aceptPickIngredient:(id)sender;
- (IBAction)cancelPickIngredient:(id)sender;


@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init arrays
    if (!ingredientArray) {
        ingredientArray = [[NSMutableArray alloc] init];
    }
    if (!ingredientIDArray) {
        ingredientIDArray = [[NSMutableArray alloc] init];
    }
    if (!ingredientUnitArray) {
        ingredientUnitArray = [[NSMutableArray alloc] init];
    }
    if (!cateIDArray) {
        cateIDArray = [[NSMutableArray alloc] init];
    }
    if (!cateArray) {
        cateArray = [[NSMutableArray alloc] init];
    }
    if (!stepArray) {
        stepArray = [[NSMutableArray alloc] init];
    }
    if (!stepImgArr) {
        stepImgArr = [[NSMutableArray alloc] init];
    }
    if (!stepContentArr) {
        stepContentArr = [[NSMutableArray alloc] init];
    }

    
    //remove line of tableviewcell
    self.stepTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ingredientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //placeholder color config
    UIColor *placeholderColor = [UIColor lightGrayColor];
    [self.recipeName setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Tên công thức" attributes:@{NSForegroundColorAttributeName: placeholderColor}]];
    
    [self setNeedsStatusBarAppearanceUpdate];// update lại màu status bar
    
    self.RecipeAvatar = [[UIImage alloc] init];
    
    //Background config
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
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
    
    //chưa có bước làm nào được tạo khi mở view
    step = 0;
    
    
    //get all the category & category ID from server
    [self getCateAndCateID];
    
}

#pragma mark - get JSON Data - category

- (void) getCateAndCateID {
    @try {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURL *url = [NSURL URLWithString:@"http://yummy-quan.esy.es/get_all_loai_congthuc.php"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                NSArray *rsArray = [jsonData objectForKey:@"results"];
                //NSString *firstValue = [[rsArray objectAtIndex:0] valueForKey:@"Ten"];
                //NSLog(@"%@",firstValue);
                //NSString *rightFirstValue = [NSString stringWithUTF8String:[firstValue cStringUsingEncoding:NSUTF8StringEncoding]];
                for (NSUInteger i = 0; i < rsArray.count; i++) {
                    id ten = [[rsArray objectAtIndex:i] valueForKey:@"Ten"];
                    NSString *correct = [NSString stringWithUTF8String:[ten cStringUsingEncoding:NSUTF8StringEncoding]];
                    if (!cateArrayToGet) {
                        cateArrayToGet = [[NSMutableArray alloc] initWithObjects:correct, nil];
                    } else {
                        [cateArrayToGet addObject:correct];
                    }
                }
                for (NSUInteger i = 0; i < rsArray.count; i++) {
                    id cateID = [[rsArray objectAtIndex:i] valueForKey:@"LoaicongthucID"];
                    if (!cateIDArrayToGet) {
                        cateIDArrayToGet = [[NSMutableArray alloc] initWithObjects:cateID, nil];
                    } else {
                        [cateIDArrayToGet addObject:cateID];
                    }
                }
                NSLog(@"%@",cateArrayToGet);
                NSLog(@"%@",cateIDArrayToGet);
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Có lỗi xảy ra"
                                                                       message:[NSString stringWithFormat:@"Lỗi: %@\nVui lòng kiểm tra lại kết nối mạng",exception]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alright = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:alright];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - chỉnh màu status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - tableView delegate & datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.stepTableView) {
        stepCell *cell = [self.stepTableView dequeueReusableCellWithIdentifier:@"stepCell" forIndexPath:indexPath];
        cell.stepImage.image = [UIImage imageNamed:[stepImgArr objectAtIndex:indexPath.row]];
        cell.lblContent.text = [NSString stringWithFormat:@"%@",[stepContentArr objectAtIndex:indexPath.row]];
        
        //config
        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
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
    /*
    step++;
    if (!stepArray) {
        stepArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",step], nil];
        [self.stepTableView reloadData];
    } else {
        [stepArray addObject:[NSString stringWithFormat:@"%d",step]];
        [UIView transitionWithView: self.stepTableView
                          duration: 0.4f
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations: ^(void)
         {
             [self.stepTableView reloadData];
             //[self.infoView resizeToFitSubviews];
         }
                        completion: nil];
    }*/
    /*
    if (!stepArray) {
        step ++;
        stepArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",step], nil];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Nhập nội dung bước làm" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Nội dung";
            textField.textColor = [UIColor darkGrayColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleNone;
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (!stepContentArr) {
                stepContentArr = [[NSMutableArray alloc] initWithObjects:(alert.textFields[0]).text, nil];
                [self.stepTableView reloadData];
            } else {
                [stepContentArr addObject:alert.textFields[0].text];
                [self.stepTableView reloadData];
            }
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        step++;
        [stepArray addObject:[NSString stringWithFormat:@"%d",step]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Nhập nội dung bước làm" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Nội dung";
            textField.textColor = [UIColor darkGrayColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleNone;
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (!stepContentArr) {
                stepContentArr = [[NSMutableArray alloc] initWithObjects:alert.textFields[0].text, nil];
                [UIView transitionWithView: self.stepTableView
                                  duration: 0.4f
                                   options: UIViewAnimationOptionTransitionCrossDissolve
                                animations: ^(void)
                 {
                     [self.stepTableView reloadData];
                     //[self.infoView resizeToFitSubviews];
                 }
                                completion: nil];
            } else {
                [stepContentArr addObject:alert.textFields[0].text];
                [UIView transitionWithView: self.stepTableView
                                  duration: 0.4f
                                   options: UIViewAnimationOptionTransitionCrossDissolve
                                animations: ^(void)
                 {
                     [self.stepTableView reloadData];
                     //[self.infoView resizeToFitSubviews];
                 }
                                completion: nil];
            }
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    */
}

- (IBAction)addStepImage:(id)sender {
}

- (IBAction)aceptPickIngredient:(id)sender {
}

- (IBAction)cancelPickIngredient:(id)sender {
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thêm danh mục" message:@"lựa chọn danh mục của công thức" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert setModalInPopover:YES];
    
    for (NSInteger i = 0; i < cateArrayToGet.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@",[cateArrayToGet objectAtIndex:i]] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //[cateIDArray addObject:[cateIDArrayToGet objectAtIndex:i]];
            [self addObjectToCateIDArrayWithObject:[cateIDArrayToGet objectAtIndex:i]];
            //[cateArray addObject:[cateArrayToGet objectAtIndex:i]];
            [self addObjectToCateArrayWithObject:[cateArrayToGet objectAtIndex:i]];

            [UIView transitionWithView: self.cateCollectionView
                              duration: 0.4f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void)
             {
                 [self.cateCollectionView reloadData];
             }
                            completion: nil];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) addObjectToCateIDArrayWithObject:(id)object {
    if (![cateIDArray containsObject:object]) {
        [cateIDArray addObject:object];
        NSLog(@"CateIDArray chưa có object, thêm");
    } else {
        NSLog(@"CateIDArray object có rồi, không thêm");
    }
}
- (void) addObjectToCateArrayWithObject:(id)object {
    if (![cateArray containsObject:object]) {
        [cateArray addObject:object];
        NSLog(@"CateArray chưa có object, thêm");
    } else {
        NSLog(@"CateArray có object rồi, không thêm");
    }
}

- (IBAction)addIngredient:(id)sender {
    [self performSegueWithIdentifier:@"addIngredient" sender:self];
    
    
}

#pragma mark - managing segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addIngredient"]) {
        recipeIngredientViewController *destinationController = [segue destinationViewController];
        destinationController.IngredientArrayIDAlreadyHave = ingredientIDArray;
    }
}

@end
