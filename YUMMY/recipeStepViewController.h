//
//  recipeStepViewController.h
//  YUMMY
//
//  Created by Đinh Quân on 11/27/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol recipeContentDelegate <NSObject>

-(void)sendRecipeConentBack:(NSString *)contentString;
-(void)sendRecipeConentBack:(NSString *)contentString withIndex:(NSInteger)index;

@end

@interface recipeStepViewController : UIViewController
@property (nonatomic) BOOL createNew;
@property (nonatomic) NSInteger currentStepIndex;
@property (nonatomic) NSString *contentToEdit;
@property (weak, nonatomic) id<recipeContentDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextView *stepContent;

@end
