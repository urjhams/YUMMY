//
//  recipeIngredientViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/26/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "recipeIngredientViewController.h"
#import "recipeIngredient.h"

@interface recipeIngredientViewController () {
    //mảng để lấy giá trị từ json về để hiện trên phần lựa chọn
    NSMutableArray *ingredientArrayToGet;
    NSMutableArray *ingredientUnitArrayToGet;    //mảng chứa đơn vị của nguyên liệu sẽ hiện khi add
    NSMutableArray *ingredientIDArrayToGet;
    NSMutableArray *objectArray;
}

@property (weak, nonatomic) IBOutlet UIPickerView *ingredientPicker;
@property (weak, nonatomic) IBOutlet UITextField *txtValue;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (weak, nonatomic) IBOutlet UILabel *justALabel;

- (IBAction)dissmiss:(id)sender;
- (IBAction)add:(id)sender;

@end

@implementation recipeIngredientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ingredientPicker.delegate = self;
    self.ingredientPicker.dataSource = self;
    self.txtValue.delegate = self;
    // Do any additional setup after loading the view.
    //[self getIngredientAndID];
    
    [self getIngredientAndID];
}

#pragma mark - get from json
- (void) getIngredientAndID {
    @try {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURL *url = [NSURL URLWithString:@"http://yummy-quan.esy.es/get_all_nguyenlieu.php"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                NSArray *rsArray = [jsonData objectForKey:@"results"];
                for (NSInteger i = 0; i < rsArray.count; i++) {
                    //lấy giá trị ID
                    id ingredientID = [[rsArray objectAtIndex:i] valueForKey:@"NguyenlieuID"];
                    
                    //convert để decode chuỗi string UTF8
                    id Donvi = [[rsArray objectAtIndex:i] valueForKey:@"Donvi"];
                    NSString *donviCorrect = [NSString stringWithUTF8String:[Donvi cStringUsingEncoding:NSUTF8StringEncoding]];
                    id Ten = [[rsArray objectAtIndex:i] valueForKey:@"Ten"];
                    NSString *tenCorrect = [NSString stringWithUTF8String:[Ten cStringUsingEncoding:NSUTF8StringEncoding]];
                    
                    recipeIngredient *ingredientObject = [[recipeIngredient alloc] init];
                    ingredientObject.ingredientID = ingredientID;
                    ingredientObject.ingredientName = tenCorrect;
                    ingredientObject.ingredientUnit = donviCorrect;
                    
                    if (!objectArray) {
                        objectArray = [[NSMutableArray alloc] initWithObjects:ingredientObject, nil];
                    } else {
                        [objectArray addObject:ingredientObject];
                    }
                }
                [self.ingredientPicker reloadAllComponents];
            }
        }];
        [dataTask resume];
        
    } @catch (NSException *exception) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Có lỗi xảy ra"
                                                                       message:[NSString stringWithFormat:@"ỗi: %@\nVui lòng kiểm tra lại kết nối mạng",exception]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alright = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:alright];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - delegate & datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [objectArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    recipeIngredient *currentIngredient = [objectArray objectAtIndex:row];
    NSString *rowData = [NSString stringWithFormat:@"%@",currentIngredient.ingredientName];
    return rowData;
}
#pragma mark - action

- (IBAction)dissmiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)add:(id)sender {
    NSInteger row = [self.ingredientPicker selectedRowInComponent:0];
    recipeIngredient *selectedIngredient = [objectArray objectAtIndex:row];
    NSString *part1 = selectedIngredient.ingredientName;
    selectedIngredient.valueOfIngredient = self.txtValue.text;
    NSString *part2 = selectedIngredient.valueOfIngredient;
    NSString *part3 = selectedIngredient.ingredientUnit;
    NSString *part4 = selectedIngredient.ingredientID;
    NSString *finalString = [NSString stringWithFormat:@"%@ : %@ %@",part1,part2,part3];
    [self.delegate sendBackContent:finalString];
    [self.delegate sendBackIndex:part4 content:part1 unit:part3];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ẩn keyboard khi chạm bên ngoài đối tượng textfield

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];  //thời gian slide up view
    [self.view setFrame:CGRectMake(0, -80, self.view.frame.size.width, self.view.frame.size.height)];
    [self.naviBar setHidden:YES];
    [self.justALabel setHidden:YES];
    [UIView commitAnimations];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];  //thời gian slide up view
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    [self.naviBar setHidden:NO];
    [self.justALabel setHidden:NO];
    [UIView commitAnimations];
}



@end
