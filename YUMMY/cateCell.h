//
//  cateCell.h
//  YUMMY
//
//  Created by Đinh Quân on 11/11/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "categoryLabel.h"

@interface cateCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet categoryLabel *category;
@property (nonatomic) NSString *cateID;
@end
