//
//  recipeIngredientViewController.h
//  YUMMY
//
//  Created by Đinh Quân on 11/26/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ingredientContentDelegate <NSObject>

- (void)sendBackContent:(NSString *)contentString;
- (void)sendBackIndex:(NSString *)index content:(NSString *)content unit:(NSString *)unit;

@end

@interface recipeIngredientViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate>

@property (weak,nonatomic) id<ingredientContentDelegate>delegate;

@property (nonatomic) NSMutableArray *IngredientArrayIDAlreadyHave;

@end
