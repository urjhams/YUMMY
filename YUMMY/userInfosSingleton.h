//
//  userInfosSingleton.h
//  YUMMY
//
//  Created by Đinh Quân on 11/29/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface userInfosSingleton : NSObject {
    NSMutableArray *userInfos;
    UIImage *userAvatar;
}
@property (nonatomic, retain) NSMutableArray *userInfos;
@property (nonatomic, retain) UIImage *userAvatar;
+(userInfosSingleton *)sharedUserInfos;
+(userInfosSingleton *)sharedUserAvatar;
- (void)userInfoArrayIs:(NSMutableArray *)array;
- (NSMutableArray *)theUserInfosArray;
- (void)userAvatarIs:(UIImage *)avatarImg;
- (UIImage *)theUserAvatar;
@end
