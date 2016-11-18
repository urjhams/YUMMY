//
//  notificationTableViewCell.m
//  YUMMY
//
//  Created by Đinh Quân on 11/15/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "notificationTableViewCell.h"

@implementation notificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.size.height -= 2 * 5;
    
    frame.origin.x += 5;
    frame.size.width -= 2 * 5;
    
    [super setFrame:frame];
}

@end
