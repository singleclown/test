//
//  PersonModel.m
//  test
//
//  Created by sigmundliu on 16/8/5.
//  Copyright © 2016年 sigmundliu. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel
- (id)initWithName:(NSString *)name withComtent:(NSString*)content withImages:(NSArray<NSData*>*)imagesData{
    if (self = [super init]) {
        //初始化的操作
        self.name = name;
        self.content = content;
        self.imagesData = imagesData;
    }
    return self;
}
#pragma mark --- NSCoding delegate
//对类中的属性进行编码操作触发的方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSLog(@"开始对属性进行编码");
    [aCoder encodeObject:self.name forKey:@"nameKey"];
    [aCoder encodeObject:self.content forKey:@"contentKey"];
     [aCoder encodeObject:self.imagesData forKey:@"imagesKey"];
}
//对类中的属性进行解码操作的触发方法
- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"对属性进行解码");
    if (self = [super init]) {
        //解码操作
        self.name = [aDecoder decodeObjectForKey:@"nameKey"];
        self.content = [aDecoder decodeObjectForKey:@"contentKey"];
        self.imagesData = [aDecoder decodeObjectForKey:@"imagesKey"];
    }
    return  self;
}
@end
