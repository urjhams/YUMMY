//
//  mainScreenRecipe.h
//  YUMMY
//
//  Created by Đinh Quân on 12/2/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface mainScreenRecipe : NSObject
@property (nonatomic) NSString *recipeID;
@property (nonatomic) NSString *recipeName;
@property (nonatomic) NSString *recipeAvatar;
@property (nonatomic) NSString *recipeCate;
@property (nonatomic) NSString *recipeLikes;
@property (nonatomic) BOOL likeRecipe;
@property (nonatomic) BOOL bookmarkRecipe;
@property (nonatomic) UIImage *recipeAvatarImg;

- (void) recipeLiked:(NSString *)recipeID byUser:(NSString *)userID;
- (void) recipeBookmarked:(NSString *)recipeID byUser:(NSString *)userID;
- (void) me:(NSString *)userID likeThisRecipe:(NSString *)recipeID;
- (void) me:(NSString *)userID unlikeThisRecipe:(NSString *)recipeID;
- (void) me:(NSString *)userID bookmarkThisRecipe:(NSString *)recipeID;
- (void) me:(NSString *)userID unbookmarkThisRecipe:(NSString *)recipeID;
- (void) getLikesOfRecipe:(NSString *)recipeID;
@end
