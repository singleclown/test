//
//  LWViewController.m
//  test
//
//  Created by sigmundliu on 16/8/5.
//  Copyright © 2016年 sigmundliu. All rights reserved.
//

#import "LWViewController.h"
#import "LWDiscoverController.h"
#import "LWInfoViewController.h"
/*** 颜色 ***/
#define LWColorA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define LWColor(r, g, b) LWColorA((r), (g), (b), 255)
#define LWRandomColor LWColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define LWGrayColor(v) LWColor((v), (v), (v))


@interface LWViewController ()

@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**** 添加所有子控制器 ****/
    [self setupAllChildViewControllers];
    
    /**** 设置所有UITabBarItem的文字属性 ****/
    [self setupItemTitleTextAttributes];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeItem:) name:@"changeItem" object:nil];
}
-(void)changeItem:(NSNotification*)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    
    self.selectedIndex = [userInfo[@"index"] integerValue]+1;
}
- (void)setupItemTitleTextAttributes
{
    /**** 设置所有UITabBarItem的文字属性 ****/
    UITabBarItem *item = [UITabBarItem appearance];
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11.0];
    normalAttrs[NSForegroundColorAttributeName] = LWGrayColor(197);
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = LWGrayColor(44);
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)setupAllChildViewControllers{
    /**** 添加子控制器 ****/
    [self setupOneChildViewController:[[UINavigationController alloc]initWithRootViewController:[[LWInfoViewController alloc]init]] image:@"me" selectedImage:@"me_click" title:@"信息"];
    [self setupOneChildViewController:[[UINavigationController alloc]initWithRootViewController:[[LWDiscoverController alloc]init]] image:@"home" selectedImage:@"home_click" title:@"发现"];
}
/**
 *  初始化一个子控制器
 */
- (void)setupOneChildViewController:(UIViewController *)vc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title{
    if (image.length) { // 如果图片名有值才赋值
        vc.tabBarItem.title = title;
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
        
    }
    [self addChildViewController:vc];
}






@end
