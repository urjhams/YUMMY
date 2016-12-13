//
//  recipeAvatarViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/21/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "recipeAvatarViewController.h"

@interface recipeAvatarViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imagePresent;
@property (weak, nonatomic) IBOutlet UIView *pickerView;

- (IBAction)backVC:(id)sender;
- (IBAction)saveImage:(id)sender;

@end

@implementation recipeAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imagePresent.contentMode = UIViewContentModeScaleAspectFill;
    [self.imagePresent setClipsToBounds:YES];
    /*
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.pickerView addSubview:picker.view];
    [picker viewWillAppear:YES];
    [picker viewDidAppear:YES];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backVC:(id)sender {
}

- (IBAction)saveImage:(id)sender {
}
@end
