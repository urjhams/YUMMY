//
//  fullRecipeContentObject.h
//  YUMMY
//
//  Created by Đinh Quân on 12/4/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fullRecipeContentObject : NSObject

@property (nonatomic) NSString *congthucid;
@property (nonatomic) NSString *tencongthuc;
@property (nonatomic) NSString *noidung;
@property (nonatomic) NSString *dokho;
@property (nonatomic) NSString *songuoi;
@property (nonatomic) NSString *thoigian;
@property (nonatomic) NSString *mota;
@property (nonatomic) NSString *ngaytao;
@property (nonatomic) NSString *ngaysua;
@property (nonatomic) NSString *avatar;
@property (nonatomic) NSString *userid;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *useravatar;
@property (nonatomic) BOOL liked;
@property (nonatomic) BOOL bookmarked;

- (void) recipeLiked:(NSString *)recipeID byUser:(NSString *)userID;
- (void) recipeBookmarked:(NSString *)recipeID byUser:(NSString *)userID;
- (void) me:(NSString *)userID likeThisRecipe:(NSString *)recipeID;
- (void) me:(NSString *)userID unlikeThisRecipe:(NSString *)recipeID;
- (void) me:(NSString *)userID bookmarkThisRecipe:(NSString *)recipeID;
- (void) me:(NSString *)userID unbookmarkThisRecipe:(NSString *)recipeID;
@end
