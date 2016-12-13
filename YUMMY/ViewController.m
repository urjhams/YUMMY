//
//  ViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/18/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "baseUrl.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "TabBarController.h"
#import "userInfosSingleton.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController () {
    NSInteger success;
}

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
    }
    else {
        success = 0;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:self.txtAcc.text forKey:@"username"];
        [parameters setValue:self.txtPwd.text forKey:@"password"];
        [manager POST:yummy_login
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"JSON: %@", responseObject);
                 NSDictionary *jsonData = (NSDictionary *)responseObject;
                 success = [jsonData[@"code"] integerValue];
                 if (success == 1) {
                     NSString *message = (NSString *) jsonData[@"message"];
                     //NSString *userID = (NSString *) [jsonData[@"results"] objectForKey:@"UserID"];
                     
                     NSArray *rsArray = [jsonData objectForKey:@"results"];
                     NSDictionary *userInfoDict = [rsArray objectAtIndex:0];
                     NSString *userID = [userInfoDict objectForKey:@"UserID"];
                     NSString *userName = [userInfoDict objectForKey:@"Username"];
                     NSString *email = [userInfoDict objectForKey:@"Email"];
                     NSString *ngaytao = [userInfoDict objectForKey:@"Ngaytao"];
                     NSString *mota = [userInfoDict objectForKey:@"Mota"];
                     NSString *avatar = [userInfoDict objectForKey:@"Avatar"];
                     
                     userInfoArr = [[NSMutableArray alloc] initWithObjects: userID, userName, email, ngaytao, mota, avatar, nil];
                     [[userInfosSingleton sharedUserInfos] userInfoArrayIs:userInfoArr];
                     
                     
                     NSLog(@"%@",message);
                     [self performSegueWithIdentifier:@"loginSuccess" sender:self];
                 } else {
                     NSString *message = (NSString *) jsonData[@"message"];
                     NSLog(@"%@",message);
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Đăng nhập thất bại"
                                                                                    message:message
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *alright = [UIAlertAction actionWithTitle:@"Thử lại" style:UIAlertActionStyleCancel handler:nil];
                     [alert addAction:alright];
                     [self presentViewController:alert animated:YES completion:nil];
                 }

        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}


#pragma mark - get avatar from url
- (NSData *)getUserAvatarFromUrl:(NSURL *)avatarUrl {
    NSData *avatar = [[NSData alloc] initWithContentsOfURL:avatarUrl];
    return avatar;
}
-(NSData *)asynchoronusGetUserAvatarFromUrl:(NSURL *)url {
    NSData *avatar = [[NSData alloc] initWithContentsOfURL:url];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (avatar == nil) {
            return ;
        }
    });
    return avatar;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginSuccess"]) {
        __unused TabBarController *destinationController = [segue destinationViewController];
        
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
