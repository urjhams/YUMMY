//
//  NotificationViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/30/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "NotificationViewController.h"
#import "notificationTableViewCell.h"

@interface NotificationViewController () {
    NSDictionary *notifications;
    NSMutableArray *newArray;
    NSMutableArray *newArrayImg;
    NSMutableArray *newArrayDesImg;
    NSMutableArray *newArrayContent;
    NSMutableArray *oldArray;
    NSMutableArray *oldArrayImg;
    NSMutableArray *oldArrayDesImg;
    NSMutableArray *oldArrayContent;
    NSArray *sectionTitle;
}
@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.notificationTableView.delegate = self;
    self.notificationTableView.dataSource = self;
    
    //remove line of cell
    self.notificationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //data
    newArrayImg = [NSMutableArray arrayWithObjects:@"avatar.jpg",@"avatar.jpg", nil];
    oldArrayImg = [NSMutableArray arrayWithObjects:@"avatar.jpg",@"avatar.jpg", nil];
    newArrayContent = [NSMutableArray arrayWithObjects:@"abc was like your xyz",@"abc was like your xyz", nil];
    oldArrayContent = [NSMutableArray arrayWithObjects:@"abc was like your xyz",@"abc was like your xyz", nil];
    newArrayDesImg = [NSMutableArray arrayWithObjects:@"avatar.jpg",@"avatar.jpg", nil];
    oldArrayDesImg = [NSMutableArray arrayWithObjects:@"avatar.jpg",@"avatar.jpg", nil];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSection = 0;
    if (!newArrayImg && !oldArrayImg) {
        UILabel *lblNoData = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.notificationTableView.bounds.size.width, self.notificationTableView.bounds.size.height)];
        lblNoData.text = @"Không có thông báo nào";
        [lblNoData setTextColor:[UIColor darkGrayColor]];
        [lblNoData setTextAlignment:NSTextAlignmentCenter];
        self.notificationTableView.backgroundView = lblNoData;
    } else if ((newArrayImg && !oldArrayImg) || (!newArrayImg && oldArrayImg)) {
        numberOfSection = 1;
    } else {
        numberOfSection = 2;
    }
    return numberOfSection;
}

//section header background color
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (newArrayImg && oldArrayImg) {
        if (section == 0) {
            return [NSString stringWithFormat:@"Hôm nay"];
        } else {
            return [NSString stringWithFormat:@"Cũ hơn"];
        }
    } else if (!newArrayImg && oldArrayImg) {
        return [NSString stringWithFormat:@"Thông báo"];
    } else {
        return [NSString stringWithFormat:@"Hôm nay"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (newArrayImg && oldArrayImg) {
        if (section == 0) {
            return [newArrayImg count];
        } else {
            return [oldArrayImg count];
        }
    } else if (!newArrayImg && oldArrayImg) {
        return [oldArrayImg count];
    } else {
        return [newArrayImg count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    notificationTableViewCell *cell = [self.notificationTableView dequeueReusableCellWithIdentifier:@"notiCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 7.5f;
    cell.clipsToBounds = YES;
    //configuration
    //uiimage hình tròn
    cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2;
    [cell.userImage setClipsToBounds:YES];
    
    //uiimage bo góc
    cell.destImage.layer.cornerRadius = 10.0f;
    [cell.destImage setClipsToBounds:YES];
    
    //content
    if (newArrayImg && oldArrayImg) {
        if (indexPath.section == 0) {
            cell.userImage.image = [UIImage imageNamed:[newArrayImg objectAtIndex:indexPath.row]];
            cell.destImage.image = [UIImage imageNamed:[newArrayDesImg objectAtIndex:indexPath.row]];
            cell.lblContent.text = [NSString stringWithFormat:@"%@",[newArrayContent objectAtIndex:indexPath.row]];
        } else {
            cell.userImage.image = [UIImage imageNamed:[oldArrayImg objectAtIndex:indexPath.row]];
            cell.destImage.image = [UIImage imageNamed:[oldArrayDesImg objectAtIndex:indexPath.row]];
            cell.lblContent.text = [NSString stringWithFormat:@"%@",[oldArrayContent objectAtIndex:indexPath.row]];
        }
    } else if (!newArrayImg && oldArrayImg) {
        cell.userImage.image = [UIImage imageNamed:[oldArrayImg objectAtIndex:indexPath.row]];
        cell.destImage.image = [UIImage imageNamed:[oldArrayDesImg objectAtIndex:indexPath.row]];
        cell.lblContent.text = [NSString stringWithFormat:@"%@",[oldArrayContent objectAtIndex:indexPath.row]];
    } else {
        cell.userImage.image = [UIImage imageNamed:[newArrayImg objectAtIndex:indexPath.row]];
        cell.destImage.image = [UIImage imageNamed:[newArrayDesImg objectAtIndex:indexPath.row]];
        cell.lblContent.text = [NSString stringWithFormat:@"%@",[newArrayContent objectAtIndex:indexPath.row]];
    }
    
    return cell;
}



@end
