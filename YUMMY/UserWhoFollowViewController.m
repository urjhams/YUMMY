//
//  UserWhoFollowViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 11/18/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "UserWhoFollowViewController.h"
#import "userTableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "baseUrl.h"
#import "userFollowMe.h"

@interface UserWhoFollowViewController () {
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

    self.theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setNeedsStatusBarAppearanceUpdate];// update lại màu status bar
    
    [self getUsersWhoFollow];

}

#pragma mark - chỉnh màu status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - getUser Follow (Asynchoronus)
-(void)getUsersWhoFollow {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.myID forKey:@"UserID"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_user_follow parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        if ([jsonData[@"code"] integerValue] == 1) {
            NSArray *rsArray = [jsonData objectForKey:@"results"];
            for (int i = 0; i < rsArray.count; i++) {
                userFollowMe *thisUser = [[userFollowMe alloc] init];
                thisUser.userID = [[rsArray objectAtIndex:i] objectForKey:@"UserID"];
                thisUser.userName = [[rsArray objectAtIndex:i] objectForKey:@"Username"];
                thisUser.userAvatar = [[rsArray objectAtIndex:i] objectForKey:@"Avatar"];
                
                if (!usersFollowMe) {
                    usersFollowMe = [[NSMutableArray alloc] initWithObjects:thisUser, nil];
                } else {
                    [usersFollowMe addObject:thisUser];
                }
            }
            [self.theTableView reloadData];
            NSLog(@"%@",jsonData[@"message"]);
        } else {
            NSLog(@"%@",jsonData[@"message"]);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    userTableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:@"FUserCell" forIndexPath:indexPath];
    userFollowMe *thisuser = [usersFollowMe objectAtIndex:indexPath.row];
    cell.name.text = thisuser.userName;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",folder_avatar,thisuser.userAvatar]];
    [cell.image setImageWithURL:url];
    cell.image.layer.cornerRadius = cell.image.frame.size.width / 2;
    [cell.image setClipsToBounds:YES];
    [cell.image setContentMode:UIViewContentModeScaleAspectFit];
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
