//
//  mainScreenRecipe.m
//  YUMMY
//
//  Created by Đinh Quân on 12/2/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "baseUrl.h"
#import "mainScreenRecipe.h"
#import "AFNetworking.h"

@implementation mainScreenRecipe

#pragma mark - liked (Asynchoronus) - kiểm tra đã like công thức này hay chưa
- (void)recipeLiked:(NSString *)recipeID byUser:(NSString *)userID {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeID,@"CongthucID",userID,@"UserID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_like
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             int code = (int)[jsonData[@"code"] integerValue];
             if (code == 1) {
                 self.likeRecipe = [NSString stringWithFormat:@"yes"];
                 NSLog(@"%@",self.recipeName);
             } else {
                 self.likeRecipe = [NSString stringWithFormat:@"no"];
             }
             NSLog(@"%@",jsonData[@"message"]);

         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];
}
#pragma mark - bookmarked (Asynchoronus) - kiểm tra đã bookmark công thức này hay chưa
- (void)recipeBookmarked:(NSString *)recipeID byUser:(NSString *)userID {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:recipeID,@"CongthucID",userID,@"UserID", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:get_bookmark
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *jsonData = (NSDictionary *)responseObject;
             int code = (int)[jsonData[@"code"] integerValue];
             if (code == 1) {
                 self.likeRecipe = [NSString stringWithFormat:@"yes"];
                 NSLog(@"%@",self.recipeName);
             } else {
                 self.likeRecipe = [NSString stringWithFormat:@"no"];
             }
             NSLog(@"%@",jsonData[@"message"]);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
         }];
}

@end
