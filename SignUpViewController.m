//
//  SignUpViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "SignUpViewController.h"
#import "ViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UITextField *txtMail;
@property (weak, nonatomic) IBOutlet UILabel *lblCreate;
@property (weak, nonatomic) IBOutlet UITextField *txtAcc;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtPwdAgain;

- (IBAction)SignUpClicked:(id)sender;

- (void)anKeyboard;
- (void)hienKeyboard;
- (void)setViewMoveUp:(BOOL)moveUp;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - làm UIImageview trở nên blur
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.background.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.background.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.background addSubview:blurEffectView];
    } else {
        self.background.backgroundColor = [UIColor blackColor];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];// update lại màu status bar
}

#pragma mark - chỉnh màu status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SignUpClicked:(id)sender {
    if ([self.txtAcc.text isEqualToString:@""]||[self.txtPwd.text isEqualToString:@""]||[self.txtPwdAgain.text isEqualToString:@""]||[self.txtMail.text isEqualToString:@""]) {
        UIAlertController *alertMiss = [UIAlertController alertControllerWithTitle:@"Cảnh báo" message:@"Vui lòng nhập đầy đủ thông tin" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *acept = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
        [alertMiss addAction:acept];
        [self presentViewController:alertMiss animated:YES completion:nil];
    } else {
        if (self.txtPwd.text != self.txtPwdAgain.text) {
            UIAlertController *alertPwd = [UIAlertController alertControllerWithTitle:@"Cảnh báo" message:@"Mật khẩu gõ lại không khớp với mật khẩu đã nhập" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *acept = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
            [alertPwd addAction:acept];
            [self presentViewController:alertPwd animated:YES completion:nil];
        } else {
            
            
            //code xử lý gửi form đi và nhận kết quả đăng ký trả về
            
            
        }
    }
}

#pragma mark - ẩn keyboard khi chạm bên ngoài đối tượng textfield

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    if (self.view.frame.origin.y < 0) {
        [self setViewMoveUp:NO];
    }
}


#pragma mark - move view up when show keyboard

#define OFFSET_4_KEYBOARD 50.0

// delegates từ UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.txtMail]) {
        if (self.view.frame.origin.y >= 0) {
            [self setViewMoveUp:YES];
        }
    }
    return YES;
}

- (void)setViewMoveUp:(BOOL)moveUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];  //thời gian slide up view
    CGRect rect = self.view.frame;
    
    if (moveUp) {
        rect.origin.y -= OFFSET_4_KEYBOARD;
        rect.size.height += OFFSET_4_KEYBOARD;
        [self.lblCreate setHidden:true];
    } else {
        rect.origin.y += OFFSET_4_KEYBOARD;
        rect.size.height -= OFFSET_4_KEYBOARD;
        [self.lblCreate setHidden:false];
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


// 2 hàm dưới hỗ trợ cho việc đăng ký recive notification
// giúp nhận phản hồi về vị trí của view

- (void)hienKeyboard {
    int limit = 0 - OFFSET_4_KEYBOARD;
    CGFloat yValue = self.view.frame.origin.y;
    if (yValue >= 0) {
        [self setViewMoveUp:YES];
    } else if (yValue < 0 && yValue > limit) {
        [self setViewMoveUp:NO];
    }
}


- (void)anKeyboard {
    int limit = 0 - OFFSET_4_KEYBOARD;
    if (self.view.frame.origin.y >= 0) {
        [self setViewMoveUp:YES];
    } else if (self.view.frame.origin.y < 0 && self.view.frame.origin.y > limit) {
        [self setViewMoveUp:NO];
    }
}

#pragma mark - đăng ký notification của keyboard để phản hồi
- (void)viewWillAppear:(BOOL)animated {
    //[super viewWillAppear:animated];
    
    //Đăng ký để nhận phản hồi khi keyboard hiện lên
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hienKeyboard)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(anKeyboard)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[super viewWillDisappear:animated];
    
    //Đăng ký để nhận phản hồi khi keyboard Disapear
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}



@end