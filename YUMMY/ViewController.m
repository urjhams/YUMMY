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

@interface ViewController () {
    NSInteger success;
}
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
    }
    else {
        @try {
            success = 0;
            NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
            NSURL *url = [NSURL URLWithString:@"http://yummy-quan.esy.es/login.php"];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
            NSString *parameters = [[NSString alloc] initWithFormat:@"username=%@&password=%@",self.txtAcc.text,self.txtPwd.text];
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error == nil) {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    success = [jsonData[@"code"] integerValue];
                    if (success == 1) {
                        NSString *message = (NSString *) jsonData[@"message"];
                        //NSString *userID = (NSString *) [jsonData[@"results"] objectForKey:@"UserID"];
                        NSArray *rsArray = [jsonData objectForKey:@"results"];
                        NSDictionary *userInfoDict = [rsArray objectAtIndex:0];
                        NSString *userID = [userInfoDict objectForKey:@"UserID"];
                        NSLog(@"%@",message);
                        NSLog(@"UserID la %@",userID);
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
                }
            }];
            [dataTask resume];
        } @catch(NSException *exception) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Có lỗi xảy ra"
                                                                           message:[NSString stringWithFormat:@"Lỗi: %@\nVui lòng kiểm tra lại kết nối mạng",exception]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alright = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:alright];
            [self presentViewController:alert animated:YES completion:nil];
        }
        /*
        NSInteger success = 2;
        @try {
            NSString *post = [[NSString alloc] initWithFormat:@"username=%@&password=%@",self.txtAcc.text,self.txtPwd.text];
            NSLog(@"PostData: %@",post);
            
            NSURL *url = [NSURL URLWithString:@"http://localhost/yummy/login.php"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            //NSString *postLenght = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:postData];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if ([response statusCode] >= 200 && [response statusCode] < 300) {
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&error];
                success = [jsonData[@"code"] integerValue];
                
                if (success == 1) {
                    NSString *message = (NSString *) jsonData[@"message"];
                    [self performSegueWithIdentifier:@"loginSuccess" sender:self];
                    NSLog(@"%@",message);
                } else {
                    NSString *message = (NSString *) jsonData[@"message"];
                    NSLog(@"%@",message);
                }
            } else {
                //NSString *message = (NSString *) jsonData[@"message"];
                NSLog(@"Failed");
            }
        }
        @catch (NSException *e) {
            NSLog(@"%@",e);
        }*/
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
