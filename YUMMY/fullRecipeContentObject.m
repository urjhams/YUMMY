//
//  fullRecipeContentObject.m
//  YUMMY
//
//  Created by Đinh Quân on 12/4/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "fullRecipeContentObject.h"
#import "baseUrl.h"

@implementation fullRecipeContentObject

#pragma mark - liked (Asynchoronus) - kiểm tra đã like công thức này hay chưa
- (void)recipeLiked:(NSString *)recipeID byUser:(NSString *)userID {
    @try {
        NSURL *url = [NSURL URLWithString:get_like];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@&UserID=%@",recipeID,userID];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                int code = (int)[jsonData[@"code"] integerValue];
                if (code == 1) {
                    NSLog(@"%@",jsonData[@"message"]);
                    self.liked = YES;
                } else {
                    NSLog(@"%@",jsonData[@"message"]);
                    self.liked = NO;
                }
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@",exception);
    }
}
#pragma mark - bookmarked (Asynchoronus) - kiểm tra đã bookmark công thức này hay chưa
- (void)recipeBookmarked:(NSString *)recipeID byUser:(NSString *)userID {
    @try {
        NSURL *url = [NSURL URLWithString:get_bookmark];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@&UserID=%@",recipeID,userID];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                int code = (int)[jsonData[@"code"] integerValue];
                if (code == 1) {
                    NSLog(@"%@",jsonData[@"message"]);
                    self.bookmarked = YES;
                } else {
                    NSLog(@"%@",jsonData[@"message"]);
                    self.bookmarked = NO;
                }
            }
        }];
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@",exception);
    }
}

#pragma mark - like (synchoronus)
- (void) me:(NSString *)userID likeThisRecipe:(NSString *)recipeID {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:like_congthuc];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@&UserID=%@",recipeID,userID];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if ([jsonData[@"code"] integerValue] == 1) {
                NSLog(@"%@",jsonData[@"message"]);
                self.liked = YES;
            } else {
                NSLog(@"%@",jsonData[@"message"]);
                self.liked = NO;
            }
        }
    }];
    [dataTask resume];
}
#pragma mark - unlike (synchoronus)
- (void) me:(NSString *)userID unlikeThisRecipe:(NSString *)recipeID {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:unlike_congthuc];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@&UserID=%@",recipeID,userID];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if ([jsonData[@"code"] integerValue] == 1) {
                NSLog(@"%@",jsonData[@"message"]);
                self.liked = NO;
            } else {
                NSLog(@"%@",jsonData[@"message"]);
                self.liked = YES;
            }
        }
    }];
    [dataTask resume];
}
#pragma mark - bookmark (synchoronus)
- (void) me:(NSString *)userID bookmarkThisRecipe:(NSString *)recipeID {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:bookmark_congthuc];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@&UserID=%@",recipeID,userID];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if ([jsonData[@"code"] integerValue] == 1) {
                NSLog(@"%@",jsonData[@"message"]);
                self.bookmarked = YES;
            } else {
                NSLog(@"%@",jsonData[@"message"]);
                self.bookmarked = NO;
            }
        }
    }];
    [dataTask resume];
}
#pragma mark - unbookmark (synchoronus)
- (void) me:(NSString *)userID unbookmarkThisRecipe:(NSString *)recipeID {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:unbookmark_congthuc];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = [NSString stringWithFormat:@"CongthucID=%@&UserID=%@",recipeID,userID];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if ([jsonData[@"code"] integerValue] == 1) {
                NSLog(@"%@",jsonData[@"message"]);
                self.bookmarked = NO;
            } else {
                NSLog(@"%@",jsonData[@"message"]);
                self.bookmarked = YES;
            }
        }
    }];
    [dataTask resume];
}



@end
