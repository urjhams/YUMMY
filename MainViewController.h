//
//  MainViewController.h
//  YUMMY
//
//  Created by Đinh Quân on 10/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

@interface MainViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSourcePrefetching>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewController;
@end
