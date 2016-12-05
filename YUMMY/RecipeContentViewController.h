//
//  RecipeContentViewController.h
//  YUMMY
//
//  Created by Đinh Quân on 11/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface RecipeContentViewController : ViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSString *inputRecipeID;
@property (nonatomic) UIImage *inputRecipeAvatar;
@property (nonatomic) BOOL liked;
@property (nonatomic) BOOL bookmarked;
@end
