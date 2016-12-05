//
//  stepTableViewCell.h
//  YUMMY
//
//  Created by Đinh Quân on 12/4/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface stepTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblStepNumber;
@property (weak, nonatomic) IBOutlet UIImageView *stepImg;
@property (weak, nonatomic) IBOutlet UILabel *stepContent;

@end
