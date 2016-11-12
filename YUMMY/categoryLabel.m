//
//  categoryLabel.m
//  YUMMY
//
//  Created by Đinh Quân on 10/26/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "categoryLabel.h"

@implementation categoryLabel

//override

#pragma mark - hàm điều chỉnh margin giữa viền và content của label
- (CGSize)intrinsicContentSize {
    CGSize contentSize = [super intrinsicContentSize];  //lưu ý chỉnh algiment về center
    return CGSizeMake(contentSize.width + 10, contentSize.height);
    // trả về kích thước label bằng với độ rộng content + 10 và độ dài content
}

/*
 #pragma mark - hàm điều chỉnh margin giữa các cạnh của khung label với nội dung label
 - (void)drawTextInRect:(CGRect)rect {
 UIEdgeInsets inset = UIEdgeInsetsMake(0, 2, 0, 2);
 [super drawTextInRect:UIEdgeInsetsInsetRect(rect, inset)];
 }
 */
@end
