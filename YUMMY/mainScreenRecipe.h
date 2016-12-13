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
@property (nonatomic) NSString *likeRecipe;
@property (nonatomic) NSString *bookmarkRecipe;
@property (nonatomic) UIImage *recipeAvatarImg;

- (void) recipeLiked:(NSString *)recipeID byUser:(NSString *)userID;
- (void) recipeBookmarked:(NSString *)recipeID byUser:(NSString *)userID;
@end
