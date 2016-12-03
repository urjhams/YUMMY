//
//  UserWhoFollowViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/18/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "UserWhoFollowViewController.h"
#import "userTableViewCell.h"

@interface UserWhoFollowViewController () {
    NSMutableArray *userImgArr;
    NSMutableArray *userNameArr;
    NSMutableArray *usersFollowMe;
}
@property (weak, nonatomic) IBOutlet UITableView *theTableView;

- (IBAction)backVC:(id)sender;

@end

@implementation UserWhoFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    
}

#pragma mark - getUser Follow (Asynchoronus)
-(void)getUsersWhoFollow {
    @try {
        NSURL *url = [NSURL URLWithString:@"http://yummy-quan.esy.es/get_user_follow.php"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *parameters = [[NSString alloc] initWithFormat:@"UserID=%@",self.myID];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *dataTask =[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&error];
                if ([jsonData[@"code"] integerValue] == 1) {
                    NSArray *rsArray = [jsonData objectForKey:@"results"];
                    for (int i = 0; i < rsArray.count; i++) {
                        NSString *userFollowID = (NSString *)[rsArray valueForKey:@"UserID"];
                        NSString *userFollowAcc = (NSString *)[rsArray valueForKey:@"UserName"];
                        NSString *userFollowAvatar = (NSString *)[rsArray valueForKey:@"Avatar"];
                        
                        NSDictionary *users = [[NSDictionary alloc] initWithObjectsAndKeys:@"userID",userFollowID,@"userAcc",userFollowAcc,@"userAvatar",userFollowAvatar, nil];
                        if (!usersFollowMe) {
                            usersFollowMe = [[NSMutableArray alloc] initWithObjects:users, nil];
                        } else {
                            [usersFollowMe addObject:users];
                        }
                    }
                    NSLog(@"%@",jsonData[@"message"]);
                } else {
                    NSLog(@"%@",jsonData[@"message"]);
                }
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

#pragma mark - delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    userTableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:@"FUserCell" forIndexPath:indexPath];
    
    cell.name.text = (NSString *)[[usersFollowMe objectAtIndex:indexPath.row] objectForKey:@"userAcc"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://yummy-quan.esy.es/avatar/%@",(NSString *)[[usersFollowMe objectAtIndex:indexPath.row] objectForKey:@"userAvatar"]]];
    
    NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    userTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    updateCell.image.image = image;
                });
            }
        }
    }];
    [dataTask resume];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return usersFollowMe.count;
}

#pragma mark - action

- (IBAction)backVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
