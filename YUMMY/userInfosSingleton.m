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

+(userInfosSingleton *)sharedUserInfos {
    static userInfosSingleton *sharedUserInfos = nil;
    if (!sharedUserInfos) {
        sharedUserInfos = [[userInfosSingleton alloc] init];
        sharedUserInfos.userInfos = [NSMutableArray new];
    }
    return sharedUserInfos;
}

-(id)init {
    self = [super init];
    if (self) {
        userInfos = [[NSMutableArray alloc] init];
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
@end
