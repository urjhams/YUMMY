//
//  SearchResultViewController.h
//  YUMMY
//
//  Created by Đinh Quân on 10/25/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

@interface SearchResultViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSourcePrefetching>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewController;
@property (nonatomic) int key;
@end
