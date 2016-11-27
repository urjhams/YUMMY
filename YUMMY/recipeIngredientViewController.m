//
//  recipeIngredientViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/26/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "recipeIngredientViewController.h"

@interface recipeIngredientViewController () {
    //mảng để lấy giá trị từ json về để hiện trên phần lựa chọn
    NSMutableArray *ingredientArrayToGet;
    NSMutableArray *ingredientUnitArrayToGet;    //mảng chứa đơn vị của nguyên liệu sẽ hiện khi add
    NSMutableArray *ingredientIDArrayToGet;
}

@property (weak, nonatomic) IBOutlet UIPickerView *ingredientPicker;
@property (weak, nonatomic) IBOutlet UITextField *txtValue;

- (IBAction)dissmiss:(id)sender;
- (IBAction)add:(id)sender;

@end

@implementation recipeIngredientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ingredientPicker.delegate = self;
    self.ingredientPicker.dataSource = self;
    // Do any additional setup after loading the view.
}

#pragma mark - get from json
- (void) getIngredientAndID {
    @try {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURL *url = [NSURL URLWithString:@""];
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
                    
                    //lấy chuỗi giá trị nguyên liệu ID sẽ hiện để lựa chọn
                    if (!ingredientIDArrayToGet) {
                        ingredientIDArrayToGet = [[NSMutableArray alloc] initWithObjects:ingredientID, nil];
                    } else {
                        [ingredientIDArrayToGet addObject:ingredientID];
                    }
                    
                    //lấy chuỗi giá trị tên nguyên liệu sẽ hiện để lựa chọn
                    if (!ingredientArrayToGet) {
                        ingredientArrayToGet = [[NSMutableArray alloc] initWithObjects:tenCorrect, nil];
                    } else {
                        [ingredientArrayToGet addObject:tenCorrect];
                    }
                    
                    //lấy chuỗi giá trị của đơn vị ứng với nguyên liệu sẽ hiện lên trên bảng lựa chọn
                    if (!ingredientUnitArrayToGet) {
                        ingredientUnitArrayToGet = [[NSMutableArray alloc] initWithObjects:donviCorrect, nil];
                    } else {
                        [ingredientUnitArrayToGet addObject:donviCorrect];
                    }
                }
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
    return [ingredientIDArrayToGet count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *rowData = [NSString stringWithFormat:@"%@ - Đơn vị: %@",ingredientArrayToGet[row],ingredientUnitArrayToGet[row]];
    return rowData;
}
#pragma mark - action

- (IBAction)dissmiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)add:(id)sender {
    NSInteger row = [self.ingredientPicker selectedRowInComponent:0];
    NSString *part1 = [ingredientArrayToGet objectAtIndex:row];
    NSString *part3 = [ingredientUnitArrayToGet objectAtIndex:row];
    NSString *part2 = self.txtValue.text;
    NSString *part4 = [ingredientIDArrayToGet objectAtIndex:row];
    NSString *finalString = [NSString stringWithFormat:@"%@ : %@ %@",part1,part2,part3];
    [self.delegate sendBackContent:finalString];
    [self.delegate sendBackIndex:part4 content:part1 unit:part3];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
