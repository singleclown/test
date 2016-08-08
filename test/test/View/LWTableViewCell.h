//
//  LWTableViewCell.h
//  test
//
//  Created by sigmundliu on 16/8/5.
//  Copyright © 2016年 sigmundliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
@interface LWTableViewCell : UITableViewCell
@property (nonatomic,strong)  PersonModel*personModel;
@property (nonatomic,assign) CGFloat cellHeight;
@end
