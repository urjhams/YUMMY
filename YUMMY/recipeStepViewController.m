//
//  recipeStepViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/27/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "recipeStepViewController.h"
#import "CreateViewController.h"

@interface recipeStepViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation recipeStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentHeight.constant = self.stepContent.contentSize.height;
    if (self.createNew == NO) {
        self.stepContent.text = self.contentToEdit;
    } else {
        self.stepContent.text = @"Nội dung bước làm...";
    }
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    if (self.createNew == YES) {
        if ([self.stepContent.text isEqualToString:@"Nội dung bước làm..."] || [self.stepContent.text isEqualToString:@""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Bạn phải nhập nội dung bước làm chứ?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self.delegate sendRecipeConentBack:self.stepContent.text];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self.delegate sendRecipeConentBack:self.stepContent.text withIndex:self.currentStepIndex];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

@end
