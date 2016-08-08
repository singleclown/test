//
//  LWDiscoverController.m
//  test
//
//  Created by sigmundliu on 16/8/5.
//  Copyright © 2016年 sigmundliu. All rights reserved.
//

#import "LWDiscoverController.h"
#import "PersonModel.h"
#import "LWTableViewCell.h"
@interface LWDiscoverController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSString *archivingPath;
@property (nonatomic,strong) PersonModel *personModel;
@property (nonatomic,strong) LWTableViewCell *tableviewCell;
@property (nonatomic,strong) UITableView *tableview;
@end
static NSString *reuseCell = @"Cell";
@implementation LWDiscoverController
- (NSString *)archivingPath {
    if (!_archivingPath) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _archivingPath = [documentPath stringByAppendingPathComponent:@"archivingFile"];
    }
    return _archivingPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [_tableview registerClass:[LWTableViewCell class] forCellReuseIdentifier:reuseCell];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.archivingPath) {
        //反归档操作 (读)
        //从归档文件中读取数据NSData
        NSData *fileData = [NSData dataWithContentsOfFile:self.archivingPath];
        //创建反归档对象
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:fileData];
        //解码操作
        self.personModel = [unarchiver decodeObjectForKey:@"firstKey"];
        //完成解码动作
        [unarchiver finishDecoding];
        // 验证
        NSLog(@"name:%@, content:%@,image=", self.personModel.name, self.personModel.content);
    }
    [self.tableview reloadData];
}

#pragma mark - UITableViewDataSource
//问题1:告诉表格有几个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; //3个分区，默认是1
}
//问题2:告诉表格每个分区中 有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
//问题3:每一行显示什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell个数需要为动态才能取到
    //    LWTableViewCell*cell = (LWTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseCell forIndexPath:indexPath];
    //    cell.personModel = self.personModel;
    //    return cell;
    self.tableviewCell = [tableView dequeueReusableCellWithIdentifier:reuseCell forIndexPath:indexPath];
    self.tableviewCell.personModel = self.personModel;
    return self.tableviewCell;
}
//先计算cell高度，再显示cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    LWTableViewCell*cell = (LWTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    //    return cell.cellHeight;
    return self.tableviewCell.cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}



@end
