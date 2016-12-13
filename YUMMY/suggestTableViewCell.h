//
//  suggestTableViewCell.h
//  YUMMY
//
//  Created by Đinh Quân on 12/8/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface suggestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *loaiCongthucImg;
@property (weak, nonatomic) IBOutlet UILabel *loaiCongthucName;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@end
