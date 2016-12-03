//
//  mainCell.h
//  YUMMY
//
//  Created by Đinh Quân on 10/23/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *recipeLike;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnBookmark;
//@property (nonatomic) NSString *recipeID;
@end
