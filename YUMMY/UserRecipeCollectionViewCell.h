//
//  UserRecipeCollectionViewCell.h
//  YUMMY
//
//  Created by Đinh Quân on 11/16/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "categoryLabel.h"

@interface UserRecipeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet categoryLabel *RecipeCate;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeName;

@end
