//
//  PersonView.m
//  test
//
//  Created by sigmundliu on 16/8/5.
//  Copyright © 2016年 sigmundliu. All rights reserved.
//

#import "PersonView.h"

@implementation PersonView

- (IBAction)photoClick:(UIButton *)sender {
//     [self chooseImageFromImagePickerController];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"btnclick" object:self userInfo:nil];
}


@end
