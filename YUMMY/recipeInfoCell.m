//
//  recipeInfoCell.m
//  YUMMY
//
//  Created by Đinh Quân on 11/6/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "recipeInfoCell.h"


@implementation recipeInfoCell


#pragma mark textView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [textView setText:@""];
    return YES;
}

#pragma mark - ẩn keyboard khi chạm bên ngoài đối tượng textfield
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.contentView endEditing:YES];
    [self.backgroundView endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
@end
