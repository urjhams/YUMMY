//
//  commentTableViewCell.h
//  YUMMY
//
//  Created by Đinh Quân on 12/4/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckUserOfComment;
@end
