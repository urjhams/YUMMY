//
//  stepCell.m
//  YUMMY
//
//  Created by Đinh Quân on 11/11/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "stepCell.h"

@implementation stepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 3;
    frame.size.height -= 2 * 3;
    [super setFrame:frame];
}

@end
