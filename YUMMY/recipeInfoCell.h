//
//  recipeInfoCell.h
//  YUMMY
//
//  Created by Đinh Quân on 11/6/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recipeInfoCell : UICollectionViewCell <UITextViewDelegate>
@property (weak, nonatomic) NSMutableArray *cateData;
@property (weak, nonatomic) NSMutableArray *ingredientData;

@property (weak, nonatomic) IBOutlet UIButton *btnPerson;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;
@property (weak, nonatomic) IBOutlet UIButton *btnLevel;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UITextView *txtAbout;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

//- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
