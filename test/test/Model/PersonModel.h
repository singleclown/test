//
//  PersonModel.h
//  test
//
//  Created by sigmundliu on 16/8/5.
//  Copyright © 2016年 sigmundliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject<NSCoding>
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSArray<NSData*>*imagesData;
- (id)initWithName:(NSString *)name withComtent:(NSString*)content withImages:(NSArray<NSData*>*)imagesData;
@end
