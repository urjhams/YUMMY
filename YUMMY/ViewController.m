//
//  ViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/18/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "TabBarController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtAcc;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;

- (IBAction)loginClicked:(id)sender;
- (IBAction)forgotClicked:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self setNeedsStatusBarAppearanceUpdate];// update lại màu status bar
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ẩn keyboard sau khi eddit xong

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - chỉnh màu status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - button action
- (IBAction)loginClicked:(id)sender {
    if ([self.txtAcc.text isEqualToString:@""] || [self.txtPwd.text isEqualToString:@""]) {
        UIAlertController *alertFill = [UIAlertController alertControllerWithTitle:@"Cảnh báo" message:@"Vui lòng nhập đầy đủ tài khoản và mật khẩu" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
        [alertFill addAction:action];
        [self presentViewController:alertFill animated:YES completion:nil];
    } else {
        
        //Xử lý gửi thông tin tài khoản lên server để xác thực
        /*
        @try {
            if ([response statusCode] >= 200 && [response statusCode] < 300)
                {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
         
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData
                                                        options:NSJSONReadingMutableContainers
                                                        error:&error];
         
                success = [jsonData[@"success"] integerValue];
                NSString *username = jsonData[@"username"];
         
                if(success == 1)
                    {
                    [self performSegueWithIdentifier:@"loginSuccess" sender:[NSString stringWithFormat:@"%s",jsonData[@"username"]];
                    } else {
                        NSString *error_msg = (NSString *) jsonData[@"error_message"];
                        [self alertStatus:error_msg :@"Sign in Failed!" :0];
                    }
                }
            }
         @catch (NSException *e) {
            NSLog(@"Exception: %@",e);
            [self alertStatus:@"Đăng nhập thất bại" :@"Có lỗi xảy ra!" :0];
         }
         
        */
        //khi thành công thì:
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];  //thay self bằng [NSString stringWithFormat:@"%s",jsonData[@"username"]];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *userAcc = self.txtAcc.text;
    if ([segue.identifier isEqualToString:@"loginSuccess"]) {
        TabBarController *destinationController = [segue destinationViewController];
        destinationController.userName = userAcc;
        NSLog(@"Username la: %@",userAcc);
    }
}


- (IBAction)forgotClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lấy lại mật khẩu" message:@"Vui lòng nhập email đăng ký của bạn, chúng tôi sẽ gửi mật khẩu tới địa chỉ email mà bạn đã đăng ký" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil];
    [alert setModalInPopover:YES];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField.placeholder isEqualToString:@"Email đã đăng ký"];
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        //textField.secureTextEntry = YES;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Gửi" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray *textFields = alert.textFields;
        UITextField *emailField = textFields[0];
        NSLog(@"%@",emailField.text);
    }]];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
