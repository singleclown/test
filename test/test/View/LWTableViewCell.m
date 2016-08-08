//
//  LWTableViewCell.m
//  test
//
//  Created by sigmundliu on 16/8/5.
//  Copyright © 2016年 sigmundliu. All rights reserved.
//

#import "LWTableViewCell.h"
#import "LxGridViewFlowLayout.h"
#import "LWTestCell.h"
#import "UIView+Layout.h"
@interface LWTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}
@property (nonatomic,strong) UICollectionView *collectionview;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *contentlabel;
@property (nonatomic,assign) CGRect nameframe;
@property (nonatomic,assign) CGRect contentframe;
@property (nonatomic,assign) CGFloat collectionViewWidth;
@property (nonatomic,assign) CGFloat collectionViewHeight;
@end
@implementation LWTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //1.添加子控件
        self.nameLabel = [UILabel new];
        self.nameLabel.numberOfLines = 0;
        self.contentlabel.numberOfLines = 0;
        self.contentlabel = [UILabel new];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.contentlabel];
        self.nameLabel.numberOfLines = 0;
        self.contentlabel.numberOfLines = 0;
    }
    return self;
}

//-(CGFloat)cellHeight{
////    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * 20;
////    CGSize textSize = [self.nameLabel.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
////    CGSize textSize1 = [self.contentlabel.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
////    self.nameframe = CGRectMake(20, 10, textMaxW, textSize.height);
//////    self.nameLabel.frame =self.nameframe;
////  self.contentframe = CGRectMake(20, 10+textSize.height+10, textMaxW, textSize1.height);
//////    self.contentlabel.frame =self.contentframe;
////    // cell的总高度
////    _cellHeight = textSize.height + textSize1.height + 4 * 10 +self.collectionview.tz_height;
////    NSLog(@"%f",self.collectionview.tz_height);
//    return _cellHeight;
//}
-(void)setPersonModel:(PersonModel *)personModel{
    //3.子控件赋值数据
    _personModel = personModel;
    if (self.nameLabel) {
         self.nameLabel.text = personModel.name;
    }
    if (self.contentlabel) {
         self.contentlabel.text = personModel.content;
    }
        CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * 20;
        CGSize textSize = [self.nameLabel.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
        CGSize textSize1 = [self.contentlabel.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
        self.nameframe = CGRectMake(20, 10, textMaxW, textSize.height);
    //    self.nameLabel.frame =self.nameframe;
      self.contentframe = CGRectMake(20, 10+textSize.height+10, textMaxW, textSize1.height);
    //    self.contentlabel.frame =self.contentframe;
        // cell的总高度
    
        NSLog(@"%f",self.collectionview.tz_height);
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.contentView.tz_width - 30-30 - 4*_margin) / 3 ;
//    if(personModel.imagesData.count%3 == 0){
//       self.collectionViewWidth = (personModel.imagesData.count%3+3)*(_margin+_itemWH)+_margin;
//        self.collectionViewHeight = (personModel.imagesData.count/3)*(_margin+_itemWH)+_margin;
//    }else{
//    self.collectionViewWidth = (personModel.imagesData.count%3)*(_margin+_itemWH)+_margin;
//        self.collectionViewHeight = (personModel.imagesData.count/3+1)*(_margin+_itemWH)+_margin;
//    }
    if (personModel.imagesData.count>=3) {
         self.collectionViewWidth = 3*(_margin+_itemWH)+_margin;
    }else{
    self.collectionViewWidth = (personModel.imagesData.count%3)*(_margin+_itemWH)+_margin;
    }
    if(personModel.imagesData.count%3 == 0){
                self.collectionViewHeight = (personModel.imagesData.count/3)*(_margin+_itemWH)+_margin;
            }else{
                self.collectionViewHeight = (personModel.imagesData.count/3+1)*(_margin+_itemWH)+_margin;
            }

    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    //可以先给个全部的cell宽高，后期再重新设置子控件高宽
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(20, self.contentframe.origin.y+10+self.contentframe.size.height, [UIScreen mainScreen].bounds.size.width-60, self.collectionViewHeight) collectionViewLayout:_layout];
    // NSLog(@"%f",self.collectionViewHeight-140);
    CGFloat rgb = 244 / 255.0;
    _collectionview.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionview.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    _collectionview.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionview.dataSource = self;
    _collectionview.delegate = self;
    [self.contentView addSubview:_collectionview];
    [self.collectionview registerClass:[LWTestCell class] forCellWithReuseIdentifier:@"LWTestCell"];
    _cellHeight = textSize.height + textSize1.height + 4 * 10 +self.collectionview.tz_height;
    //[self configCollectionView:(PersonModel *)personModel];
}
//- (void)configCollectionView:(PersonModel *)personModel {NSLog(@"personModel.imagesData.count =%lu",(unsigned long)personModel.imagesData.count);
//    if (!personModel.imagesData) {
//        return;
//    }
//    _layout = [[LxGridViewFlowLayout alloc] init];
//    _margin = 4;
//    _itemWH = (self.contentView.tz_width - 30-30 - 4*_margin) / 3 ;
//    CGFloat collectionViewHeight = (personModel.imagesData.count/3+1)*(_margin+_itemWH)+_margin;
//    CGFloat collectionViewWidth = personModel.imagesData.count%3*(_margin+_itemWH)+_margin;
//    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
//    _layout.minimumInteritemSpacing = _margin;
//    _layout.minimumLineSpacing = _margin;
//    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 60, collectionViewWidth, collectionViewHeight) collectionViewLayout:_layout];
//    CGFloat rgb = 244 / 255.0;
//    _collectionview.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
//    _collectionview.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
//    _collectionview.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
//    _collectionview.dataSource = self;
//    _collectionview.delegate = self;
//    [self.contentView addSubview:_collectionview];
//    [self.collectionview registerClass:[LWTestCell class] forCellWithReuseIdentifier:@"LWTestCell"];
//}
//
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel setFrame:self.nameframe];
    [self.contentlabel setFrame:self.contentframe];
    self.collectionview.tz_width = self.collectionViewWidth;
    self.collectionview.tz_height = self.collectionViewHeight;
    [self.collectionview setFrame:self.collectionview.frame];
}
#pragma mark <UICollectionViewDataSource>
//几个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每个分区几个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"%zd",self.personModel.imagesData.count);
    return self.personModel.imagesData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LWTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWTestCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithData:self.personModel.imagesData[indexPath.row]];
    return cell;
}

@end
