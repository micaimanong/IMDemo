//
//  DiscoverMainViewController.m
//  IMDemo
//
//  Created by iMac on 16/6/29.
//  Copyright © 2016年 迷彩码农. All rights reserved.
//

#import "DiscoverMainViewController.h"

@interface DiscoverMainViewController ()<UIGestureRecognizerDelegate>

@end

@implementation DiscoverMainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    
    
    
    
    
    
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.navigationController.navigationBar setTintColor:[UIColor purpleColor]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
