//
//  anotherUserViewController.h
//  YUMMY
//
//  Created by Đinh Quân on 11/19/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>

@interface anotherUserViewController : ViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic) NSString *thisUserID;
@property (nonatomic) NSString *thisUsername;
@property (nonatomic) UIImage *thisUserAvatar;
@end
