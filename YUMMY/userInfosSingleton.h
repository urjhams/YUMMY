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
}
@property (nonatomic, retain) NSMutableArray *userInfos;

+(userInfosSingleton *)sharedUserInfos;

- (void)userInfoArrayIs:(NSMutableArray *)array;
- (NSMutableArray *)theUserInfosArray;

@end
