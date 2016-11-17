//
//  notificationTableViewCell.h
//  YUMMY
//
//  Created by Đinh Quân on 11/15/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end
