//
//  userInfosSingleton.m
//  YUMMY
//
//  Created by Đinh Quân on 11/29/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "userInfosSingleton.h"

//static userInfosSingleton *sharedUserInfos;

@implementation userInfosSingleton

@synthesize userInfos;
@synthesize userAvatar;
+(userInfosSingleton *)sharedUserInfos {
    static userInfosSingleton *sharedUserInfos = nil;
    if (!sharedUserInfos) {
        sharedUserInfos = [[userInfosSingleton alloc] init];
        sharedUserInfos.userInfos = [NSMutableArray new];
    }
    return sharedUserInfos;
}

+(userInfosSingleton *)sharedUserAvatar {
    static userInfosSingleton *sharedUserAvatar = nil;
    if (!sharedUserAvatar) {
        sharedUserAvatar = [[userInfosSingleton alloc] init];
        sharedUserAvatar.userAvatar = [NSData new];
    }
    return sharedUserAvatar;
}

-(id)init {
    self = [super init];
    if (self) {
        userInfos = [[NSMutableArray alloc] init];
        userAvatar = [[NSData alloc] init];
    }
    return self;
}

- (void)userInfoArrayIs:(NSMutableArray *)array {
    if (self.userInfos == nil) {
        self.userInfos = [[NSMutableArray alloc] initWithArray:array];
    } else {
        self.userInfos = array;
    }
}
- (NSMutableArray *)theUserInfosArray {
    //return [[userInfosSingleton sharedUserInfos] userInfos];
    return [self userInfos];
}

- (void)userAvatarIs:(NSData *)avatarData {
    if (self.userAvatar == nil) {
        self.userAvatar = [[NSData alloc] initWithData:avatarData];
    } else {
        self.userAvatar = avatarData;
    }
}

- (NSData *)theUserAvatar {
    return [self userAvatar];
}

@end
