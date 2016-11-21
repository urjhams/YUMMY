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

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    userTableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:@"FUserCell" forIndexPath:indexPath];
    cell.name.text = [NSString stringWithFormat:@"%@", [userNameArr objectAtIndex:indexPath.row]];
    cell.image.image = [UIImage imageNamed:[userImgArr objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return userNameArr.count;
}

#pragma mark - action

- (IBAction)backVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
