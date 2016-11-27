//
//  CreateViewController.h
//  YUMMY
//
//  Created by Đinh Quân on 10/30/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recipeStepViewController.h"
#import "recipeIngredientViewController.h"

@interface CreateViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, recipeContentDelegate,ingredientContentDelegate>
//array hold value
{
    //mảng để lưu giá trị
    NSMutableArray *cateArray;                      //mảng các category name sẽ lưu để gửi lên
    NSMutableArray *cateIDArray;                    //mảng các categoryID sẽ lưu để gửi lên
    
    //mảng để lấy giá trị từ json về để hiện trên phần lựa chọn
    NSMutableArray *cateArrayToGet;                 //mảng các category sẽ lấy trên server
    NSMutableArray *cateIDArrayToGet;               //mảng các category ID sẽ lấy trên server
    
}

//mảng để lưu giá trị
@property (nonatomic) NSMutableArray *ingredientArray;
@property (nonatomic) NSMutableArray *ingredientIDArray;          //mảng các ID nguyên liệu (thuôc tính ID của ingredient cell)
@property (nonatomic) NSMutableArray *ingredientUnitArray;
@property (nonatomic) NSMutableArray *ingredientNameArray;


@property (weak, nonatomic) IBOutlet UITableView *stepTableView;
@property (nonatomic) NSMutableArray *stepContentArr;
@property (nonatomic) NSMutableArray *stepImgArr;

@property (nonatomic) NSInteger currentStepToEdit;
@property (nonatomic) NSString *currentStepContentToEdit;

@end
