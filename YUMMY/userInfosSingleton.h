//
//  userInfosSingleton.h
//  YUMMY
//
//  Created by Đinh Quân on 11/29/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInfosSingleton : NSObject {
    NSMutableArray *userInfos;
    NSData *userAvatar;
}
@property (nonatomic, retain) NSMutableArray *userInfos;
@property (nonatomic, retain) NSData *userAvatar;
+(userInfosSingleton *)sharedUserInfos;
+(userInfosSingleton *)sharedUserAvatar;
- (void)userInfoArrayIs:(NSMutableArray *)array;
- (NSMutableArray *)theUserInfosArray;
- (void)userAvatarIs:(NSData *)avatarData;
- (NSData *)theUserAvatar;
@end
