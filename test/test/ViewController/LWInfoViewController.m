//
//  LWInfoViewController.m
//  test
//
//  Created by sigmundliu on 16/8/5.
//  Copyright © 2016年 sigmundliu. All rights reserved.
//

#import "LWInfoViewController.h"
#import "PersonView.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "PersonModel.h"
#define screenWidth     [UIScreen mainScreen].bounds.size.width
#define screenHeight    [UIScreen mainScreen].bounds.size.height

@interface LWInfoViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,strong) PersonView *personview;
@property (nonatomic,strong) PersonModel *personModel;
@property (nonatomic, strong) NSString *archivingPath;
@property (strong, nonatomic)NSMutableArray *backImgs;
@property (assign) CGPoint panBeginPoint;
@property (assign) CGPoint panEndPoint;
@property (strong, nonatomic)UIImageView *backView;
@end

@implementation LWInfoViewController
- (NSString *)archivingPath {
    if (!_archivingPath) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _archivingPath = [documentPath stringByAppendingPathComponent:@"archivingFile"];
    }
    return _archivingPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage) name:@"btnclick" object:nil];
    self.personview = [[[NSBundle mainBundle]loadNibNamed:@"PersonView" owner:nil options:nil]lastObject];
    [self.view addSubview:self.personview];
    self.personview.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self configCollectionView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.personModel = [PersonModel new];
      UIButton *saveButton = (UIButton*)[self.personview viewWithTag:101];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.backImgs = [NSMutableArray array];
    
    CGFloat scale;
    //截图
    if (screenWidth > 375) {
        
        scale = 2.0;
        
    }else{
        
        scale = 3.0;
        
    }
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, scale);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    [self.backImgs addObject:img];
}
- (void)configCollectionView {
    _layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 3 * _margin - 40-30) / 3  ;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    UIView *greenview = [self.personview viewWithTag:100];
   _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.tz_width - 30-40, 320) collectionViewLayout:_layout];
    CGFloat rgb = 244 / 255.0;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    //滚动条的内边距
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [greenview addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

//personview按钮被点击
-(void)receiveMessage{
    [self chooseImageFromImagePickerController];
}

//保存按钮点击，写入沙盒
-(void)save{
   
    if (self.personModel.name&&self.personModel.content&&self.personModel.imagesData) {
        NSLog(@"13989864513=%@",self.personModel.name);
        //归档操作
        //可变Data
        NSMutableData *data = [NSMutableData data];
        //NSKeyedArchiving对象
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        //对Person对象进行编码 (自动地调用encodeWithCoder)
        [archiver encodeObject:self.personModel forKey:@"firstKey"];
        //执行完成编码操作
        [archiver finishEncoding];
        //写入文件
        [data writeToFile:self.archivingPath atomically:YES];
        return;
    }
    NSLog(@"数据未填全");
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)chooseImageFromImagePickerController{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * chooseAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // UIImagePickerController : 可以从系统自带的App(照片\相机)中获得图片
        // 判断相册是否可以打开
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
        [self pickPhotoButtonClick :nil];
    }];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
        // 判断相机是否可以打开
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
        // 打开照相机
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
//        ipc.allowsEditing = YES; // 可编辑
        [self presentViewController:ipc animated:YES completion:nil];
    }];
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [cameraAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [chooseAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alertVC addAction:cancelAction];
    [alertVC addAction:cameraAction];
    [alertVC addAction:chooseAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        [self pickPhotoButtonClick:nil];
    } else { // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        // imagePickerVc.allowPickingOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            _layout.itemCount = _selectedPhotos.count;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_collectionView reloadData];
    }
}
- (void)pickPhotoButtonClick:(UIButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self)myself = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray <NSData*>*assets, BOOL isSelectOriginalPhoto) {
        NSMutableArray *mutablearray = [NSMutableArray arrayWithCapacity:20];
        for (UIImage *image in photos) {
             NSData *imageData = UIImagePNGRepresentation(image);
            [mutablearray addObject:imageData];
        }
        myself.personModel.imagesData = mutablearray;
        UITextField *textfieldName = (UITextField*)[myself.personview viewWithTag:103];
        UITextField *textfieldContent = (UITextField*)[myself.personview viewWithTag:102];
        myself.personModel.name = textfieldName.text;
        myself.personModel.content = textfieldContent.text;
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _layout.itemCount = _selectedPhotos.count;
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}
@end
