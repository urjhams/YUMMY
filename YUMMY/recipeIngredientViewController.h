//
//  recipeIngredientViewController.h
//  YUMMY
//
//  Created by Đinh Quân on 11/26/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recipeIngredientViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic) NSMutableArray *IngredientArrayIDAlreadyHave;
@end
