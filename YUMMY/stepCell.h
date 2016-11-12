//
//  stepCell.h
//  YUMMY
//
//  Created by Đinh Quân on 11/11/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface stepCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stepImage;
@property (weak, nonatomic) IBOutlet UITextView *step;
@property (weak, nonatomic) IBOutlet UIButton *btnAddImage;

@end
