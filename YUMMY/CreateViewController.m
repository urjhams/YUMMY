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
#import "userInfosSingleton.h"
#import "recipeAvatarViewController.h"
#import "recipeIngredientViewController.h"
#import "recipeStepViewController.h"
#import "TabBarController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "baseUrl.h"

@interface CreateViewController () {
    BOOL recipeCreated;
    stepCell *currentStepCell;
    int currentStepCellIndex;
    NSString *currentRecipeID;
}

//outlet
@property (weak, nonatomic) IBOutlet UIScrollView *thisScrollView;
@property (weak, nonatomic) IBOutlet UITextField *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UIButton *btnAddStep;

@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *cateCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cateCollectionViewHeight;

@property (weak, nonatomic) IBOutlet UITableView *ingredientTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingredientTablewViewHeight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepTableViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *btnDifficult;
@property (weak, nonatomic) IBOutlet UIButton *btnPerson;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;

@property (weak, nonatomic) IBOutlet UITextView *txtAbout;
@property (weak, nonatomic) IBOutlet UIImageView *recipeAvatar;

- (IBAction)CancelCreate:(id)sender;
- (IBAction)Create:(id)sender;
- (IBAction)addStep:(id)sender;
- (IBAction)editStepContent:(id)sender;
- (IBAction)adRecipeAvatar:(id)sender;


@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    recipeCreated = NO;
    [self.txtAbout setDelegate:self];
    [self.recipeName setDelegate:self];
    
    //init arrays
    if (!self.ingredientValueArray) {
        self.ingredientValueArray = [[NSMutableArray alloc] init];
    }
    if (!self.ingredientArray) {
        self.ingredientArray = [[NSMutableArray alloc] init];
    }
    if (!self.ingredientIDArray) {
        self.ingredientIDArray = [[NSMutableArray alloc] init];
    }
    if (!self.ingredientUnitArray) {
        self.ingredientUnitArray = [[NSMutableArray alloc] init];
    }
    if (!cateIDArray) {
        cateIDArray = [[NSMutableArray alloc] init];
    }
    if (!cateArray) {
        cateArray = [[NSMutableArray alloc] init];
    }
    if (!self.stepImgArr) {
        self.stepImgArr = [[NSMutableArray alloc] init];
    }
    if (!self.stepContentArr) {
        self.stepContentArr = [[NSMutableArray alloc] init];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];// update lại màu status bar
    
    //remove line of tableviewcell
    self.stepTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ingredientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //placeholder color config
    UIColor *placeholderColor = [UIColor lightGrayColor];
    [self.recipeName setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Tên công thức" attributes:@{NSForegroundColorAttributeName: placeholderColor}]];
    
    [self setNeedsStatusBarAppearanceUpdate];// update lại màu status bar
        
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
    
    self.lblUsername.text = [[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:1];
    //get all the category & category ID from server
    [self getCateAndCateID];
    
}

#pragma mark - get JSON Data - category (Asynchoronus)

- (void) getCateAndCateID {
    @try {
        NSURL *url = [NSURL URLWithString:get_all_loai_congthuc];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}


#pragma mark - chỉnh màu status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - tableView delegate & datasource (for step & ingredient)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.stepTableView) {
        stepCell *cell = [self.stepTableView dequeueReusableCellWithIdentifier:@"stepCell" forIndexPath:indexPath];
        
        cell.lblContent.text = [NSString stringWithFormat:@"%@",[self.stepContentArr objectAtIndex:indexPath.row]];
        
        
        cell.stepImage.image = [UIImage imageNamed:[self.stepImgArr objectAtIndex:indexPath.row]];
        cell.stepImage.contentMode = UIViewContentModeScaleAspectFit;
        [cell.btnAddImage addTarget:self action:@selector(editStepImage:) forControlEvents:UIControlEventTouchUpInside];
        //config
        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.stepTableViewHeight.constant = self.stepTableView.contentSize.height;  //resize
        
        return cell;
    }  else {
        UITableViewCell *cell = [self.ingredientTableView dequeueReusableCellWithIdentifier:@"ingredientCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.ingredientArray objectAtIndex:indexPath.row]];
        [cell.textLabel setTextColor:[UIColor lightTextColor]];
        self.ingredientTablewViewHeight.constant = self.ingredientTableView.contentSize.height; //resize
        
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row;
    if (tableView == self.stepTableView) {
        row = [self.stepContentArr count];
    } else if (tableView == self.ingredientTableView) {
        row = self.ingredientArray.count;
    }
    return row;
}

#pragma mark - collectionview delegate & datasource (for category)

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

#pragma mark - Image picker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (recipeCreated == NO) {
        UIImage *pickedOne = info[UIImagePickerControllerEditedImage];
        if (pickedOne) {
            self.recipeAvatar.image = pickedOne;
        } else {
            NSLog(@"cannot pick image");
        }
        self.recipeAvatar.contentMode = UIViewContentModeScaleAspectFill;
        [self.recipeAvatar setClipsToBounds:YES];
        self.recipeAvatar.layer.cornerRadius = self.recipeAvatar.frame.size.width / 2;
    } else {
        UIImage *pickedOne = info[UIImagePickerControllerEditedImage];
        if (pickedOne) {
            currentStepCell.imageView.image = pickedOne;
        } else {
            NSLog(@"cannot pick image");
        }
        [self.stepImgArr replaceObjectAtIndex:currentStepCellIndex withObject:pickedOne];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - action

- (IBAction)CancelCreate:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editStepImage:(UIButton *)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.stepTableView];
    NSIndexPath *indexPath = [self.stepTableView indexPathForRowAtPoint:touchPoint];
    currentStepCell = [self.stepTableView cellForRowAtIndexPath:indexPath];
    currentStepCellIndex = (int)indexPath.row;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)Create:(id)sender {
    if (recipeCreated == YES) {
        for (int i = 0; i < self.stepContentArr.count; i++) {
            UIImage *imageOfStep = [self.stepImgArr objectAtIndex:i];
            NSData *stepImg = UIImageJPEGRepresentation(imageOfStep, 90);
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:currentRecipeID forKey:@"CongthucID"];
            [parameters setObject:[self.stepContentArr objectAtIndex:i] forKey:@"Noidung"];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:create_step_recipe parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:stepImg name:@"fileToUpload" fileName:@"stepImg.jpeg" mimeType:@"image/jpeg"];
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *jsonData = (NSDictionary *)responseObject;
                NSLog(@"%@",[jsonData objectForKey:@"message"]);
                if ([[jsonData objectForKey:@"code"] integerValue] == 1) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tạo thành công" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:[jsonData objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:nil];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Create - %@",error);
            }];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Opps" message:@"bạn chưa lựa chọn hết các mục cần thiết trong công thức rồi!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    /*
    UIImage *imageToUpload = self.recipeAvatar.image;
    NSData *userAvatarData = UIImageJPEGRepresentation(imageToUpload, 90);
    NSDictionary *parameters = @{@"UserID":[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:1]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:upload_avatar parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:userAvatarData name:@"fileToUpload" fileName:@"myAvatar.jpeg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Uploaded avatar\n%@\n%@",task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"UploadFailed\n%@\n%@",task,error);
    }];*/
    
}

- (IBAction)addStep:(id)sender {
    if ((self.ingredientValueArray == nil) || (cateIDArray == nil) || (self.ingredientIDArray == nil)) {
        return;
    } else {
        if (recipeCreated == NO) {
            UIImage *imageToUpload = self.recipeAvatar.image;
            NSData *userAvatarData = UIImageJPEGRepresentation(imageToUpload, 90);
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[[[userInfosSingleton sharedUserInfos] theUserInfosArray] objectAtIndex:0] forKey:@"UserID"];
            [parameters setObject:self.recipeName.text forKey:@"Tencongthuc"];
            [parameters setObject:[NSString stringWithFormat:@"Nội dung công thức (not suport yet)"] forKey:@"Noidung"];
            [parameters setObject:self.btnDifficult.titleLabel.text forKey:@"Dokho"];
            [parameters setObject:self.btnPerson.titleLabel.text forKey:@"Songuoi"];
            [parameters setObject:self.btnTime.titleLabel.text forKey:@"Thoigian"];
            [parameters setObject:self.txtAbout.text forKey:@"Mota"];
            
            NSString *cateString = [[NSString alloc] init];
            for (int i = 0; i < cateIDArray.count; i++) {
                if (i == 0) {
                    cateString = [NSString stringWithFormat:@"%@",[cateIDArray objectAtIndex:i]];
                } else {
                    NSString *newString = [cateString stringByAppendingString:[NSString stringWithFormat:@"_%@",[cateIDArray objectAtIndex:i]]];
                    cateString = newString;
                }
            }
            [parameters setObject:cateString forKey:@"LoaicongthucID_arr"];
            
            NSMutableString *ingredientIDString;
            for (int i = 0; i < self.ingredientIDArray.count; i++) {
                if (i == 0) {
                    ingredientIDString = [NSMutableString stringWithFormat:@"%@",[self.ingredientIDArray objectAtIndex:i]];
                } else {
                    [ingredientIDString appendString:[NSString stringWithFormat:@"_%@",[self.ingredientIDArray objectAtIndex:i]]];
                }
            }
            [parameters setObject:ingredientIDString forKey:@"Nguyenlieu_arr"];
            
            NSMutableString *ingredientValueString;
            for (int i = 0; i < self.ingredientValueArray.count; i++) {
                if (i == 0) {
                    ingredientValueString = [NSMutableString stringWithFormat:@"%@",[self.ingredientValueArray objectAtIndex:i]];
                } else {
                    [ingredientValueString appendString:[NSString stringWithFormat:@"_%@",[self.ingredientValueArray objectAtIndex:i]]];
                }
            }
            [parameters setObject:ingredientValueString forKey:@"Dinhluong_arr"];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:create_recipe
               parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                   [formData appendPartWithFileData:userAvatarData name:@"fileToUpload" fileName:@"myAvatar.jpeg" mimeType:@"image/jpeg"];
               } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *jsonData = (NSDictionary *)responseObject;
                   NSLog(@"%@",[jsonData objectForKey:@"message"]);
                   if ([[jsonData objectForKey:@"code"] integerValue] == 1) {
                       currentRecipeID = [[[jsonData objectForKey:@"results"] objectAtIndex:0] objectForKey:@"CongthucID"];
                       recipeCreated = YES;
                       [self performSegueWithIdentifier:@"addStep" sender:self];
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSLog(@"addStep - %@",error);
               }];
        } else {
            [self performSegueWithIdentifier:@"addStep" sender:self];
        }

    }
}


- (IBAction)editStepContent:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.stepTableView];
    NSIndexPath *currentIndexPath = [self.stepTableView indexPathForRowAtPoint:buttonPosition];
    self.currentStepToEdit = currentIndexPath.row;
    self.currentStepContentToEdit = [self.stepContentArr objectAtIndex:currentIndexPath.row];
    [self performSegueWithIdentifier:@"editStep" sender:self];
}

- (IBAction)adRecipeAvatar:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
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

#pragma mark - delegate từ recipeStepVC để truyền ngược data về
- (void)sendRecipeConentBack:(NSString *)contentString {
    [self.stepContentArr addObject:contentString];
    [self.stepImgArr addObject:@"no-photo"];
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

-(void)sendRecipeConentBack:(NSString *)contentString withIndex:(NSInteger)index {
    [self.stepContentArr replaceObjectAtIndex:index withObject:contentString];
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

#pragma mark - delegate từ recipeIngredientVC để truyền ngược data về

- (void)sendBackContent:(NSString *)contentString {
    [self.ingredientArray addObject:contentString];
    [UIView transitionWithView:self.ingredientTableView
                      duration:0.4f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.ingredientTableView reloadData];
                    }
                    completion:nil];
}

- (void)sendBackIndex:(NSString *)index content:(NSString *)content unit:(NSString *)unit value:(NSString *)value {
    [self.ingredientIDArray addObject:index];
    [self.ingredientNameArray addObject:content];
    [self.ingredientUnitArray addObject:unit];
    [self.ingredientValueArray addObject:value];
}

#pragma mark - managing segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addIngredient"]) {
        recipeIngredientViewController *destinationController = [segue destinationViewController];
        destinationController.IngredientArrayIDAlreadyHave = self.ingredientIDArray;
        [destinationController setDelegate:self];
    }
    if ([segue.identifier isEqualToString:@"addStep"]) {
        recipeStepViewController *destinationController = [segue destinationViewController];
        destinationController.createNew = YES;
        [destinationController setDelegate:self];
    }
    if ([segue.identifier isEqualToString:@"editStep"]) {
        recipeStepViewController *destinationController = [segue destinationViewController];
        destinationController.currentStepIndex = self.currentStepToEdit;
        destinationController.contentToEdit = self.currentStepContentToEdit;
        destinationController.createNew = NO;
        [destinationController setDelegate:self];
    }
}


#pragma mark - ẩn keyboard khi chạm bên ngoài đối tượng textfield

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.thisScrollView endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}


#pragma mark - move view up when show keyboard

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];  //thời gian slide up view
    [self.view setFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
    [self.naviBar setHidden:YES];
    [self.recipeName setHidden:YES];
    [self.lblUsername setHidden:YES];
    [self.btnAddStep setHidden:YES];
    [UIView commitAnimations];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];  //thời gian slide up view
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    [self.naviBar setHidden:NO];
    [self.recipeName setHidden:NO];
    [self.lblUsername setHidden:NO];
    [self.btnAddStep setHidden:NO];
    [UIView commitAnimations];
}


@end
