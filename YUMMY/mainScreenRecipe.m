//
//  mainScreenRecipe.m
//  YUMMY
//
//  Created by Đinh Quân on 12/2/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "mainScreenRecipe.h"

@implementation mainScreenRecipe

#pragma mark - liked (Synchoronus)
- (void)recipeLiked:(NSString *)recipeID byUser:(NSString *)userID {
    @try {
        
        NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration
                                                                     delegate:nil
                                                                delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURL *url = [NSURL URLWithString:@""];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@&UserID=%@",recipeID,userID];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                int code = (int)[jsonData[@"code"] integerValue];
                if (code == 1) {
                    NSLog(@"%@",jsonData[@"message"]);
                    int liked = (int)[jsonData[@"results"] integerValue];
                    if (liked == 1) {
                        self.likeRecipe = YES;
                    } else {
                        self.likeRecipe = NO;
                    }
                } else {
                    NSLog(@"%@",jsonData[@"message"]);
                    self.likeRecipe = NO;
                }
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@",exception);
        self.likeRecipe = NO;
    }
}
#pragma mark - bookmarked (Synchoronus)
- (void)recipeBookmarked:(NSString *)recipeID byUser:(NSString *)userID {
    @try {
        
        NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration
                                                                     delegate:nil
                                                                delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURL *url = [NSURL URLWithString:@""];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@&UserID=%@",recipeID,userID];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                int code = (int)[jsonData[@"code"] integerValue];
                if (code == 1) {
                    NSLog(@"%@",jsonData[@"message"]);
                    int bookmarked = (int)[jsonData[@"results"] integerValue];
                    if (bookmarked == 1) {
                        self.bookmarkRecipe = YES;
                    } else {
                        self.bookmarkRecipe = NO;
                    }
                } else {
                    NSLog(@"%@",jsonData[@"message"]);
                    self.bookmarkRecipe = NO;
                }
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@",exception);
        self.bookmarkRecipe = NO;
    }
}

#pragma mark - like
- (void) me:(NSString *)userID likeThisRecipe:(NSString *)recipeID {
    
}
#pragma mark - unlike
- (void) me:(NSString *)userID unlikeThisRecipe:(NSString *)recipeID {
    
}
#pragma mark - bookmark
- (void) me:(NSString *)userID bookmarkThisRecipe:(NSString *)recipeID {
    
}
#pragma mark - unbookmark
- (void) me:(NSString *)userID unbookmarkThisRecipe:(NSString *)recipeID {
    
}


@end
