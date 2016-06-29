//
//  MainViewController.m
//  IMDemo
//
//  Created by micaimanong on 16/6/4.
//  Copyright © 2016年 迷彩码农. All rights reserved.
//

#import "MainViewController.h"
#import "ChatMainViewController.h"
#import "FriendMainViewController.h"
#import "DiscoverMainViewController.h"
#import "MineMainViewController.h"

@interface MainViewController ()<UIGestureRecognizerDelegate>{
    UIToolbar *_toolbar;
    CGRect _initialRect;
    UIButton *_oldButton;
    UIView *_contentView;
    
    ChatMainViewController *_vc1;
    FriendMainViewController *_vc2;
    DiscoverMainViewController *_vc3;
    MineMainViewController *_vc4;
    
    UIViewController *_currentViewController;
    NSInteger _index;
 NSMutableArray *buttons ;
}

@end

@implementation MainViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.navigationController.navigationBar setTintColor:[UIColor purpleColor]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _vc1 = [[ChatMainViewController alloc] init];
    _vc2 = [[FriendMainViewController alloc]init];
    _vc3 = [[DiscoverMainViewController alloc]init];
    _vc4 = [[MineMainViewController alloc]init];
    
    
    [self addChildViewController:_vc1];
    [self addChildViewController:_vc2];
    [self addChildViewController:_vc3];
    [self addChildViewController:_vc4];
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)];
    [self.view addSubview:_contentView];
    
    UIViewController *viewController = (UIViewController *)self.childViewControllers[_index];
    [_contentView addSubview:viewController.view];
    _currentViewController = viewController;
    
    if (_index == 0) {
        self.title = @"微信";
    }else if (_index == 1){
        self.title = @"朋友";
    }else if (_index == 2){
        self.title = @"发现";
    }else{
        self.title = @"我的";
    }
    [self initToolBar];
    
    [self changeNavBar:1];
    
    // Do any additional setup after loading the view.
}

-(void)initToolBar{
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49-64,self.view.frame.size.width , 49)];
    NSArray *imageArr = [NSArray arrayWithObjects:@"tabbar01",@"ZT_fuwu",@"ZT_kefu",@"tabbar05", nil];
    NSArray *imageArrSel = [NSArray arrayWithObjects:@"tabbar01_select",@"ZT_kefu_sel",@"ZT_fuwu_sel",@"tabbar05_select", nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"微信",@"朋友",@"发现",@"我的", nil];
    [self.view addSubview:_toolbar];
    
    
   buttons = [NSMutableArray arrayWithCapacity:imageArr.count];
    
    for (int i=0; i <imageArr.count; i++) {
        UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
        buttom.frame = CGRectMake(i*self.view.frame.size.width/imageArr.count, 0, self.view.frame.size.width/imageArr.count, 49);
        buttom.tag = i+1;
        buttom.backgroundColor = [UIColor whiteColor];
        [buttom setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [buttom setImage:[UIImage imageNamed:imageArrSel[i]] forState:UIControlStateSelected];
        [buttom setImageEdgeInsets:UIEdgeInsetsMake(-5, 10, 5, -10)];
        
        
         buttom.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [buttom setTitle:titleArr[i] forState:UIControlStateNormal];
        [buttom setTitleEdgeInsets:UIEdgeInsetsMake(15, -11, -15, 11)];
        [buttom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttom setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        buttom.titleLabel.font = [UIFont systemFontOfSize:10];
        [buttom addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:buttom];
        [_toolbar addSubview:buttom];
        
    }
    UIButton *selectbtn = [buttons objectAtIndex:0];
    selectbtn.selected = YES;
    _oldButton = selectbtn;
}

-(void)action:(id)sender
{

    
    int index;
    if ([sender isKindOfClass:[UIButton class]]) {
        index = ((UIButton *)sender).tag;
    }else
    {
        index = (int)sender;
    }
    ChatMainViewController *firstViewController=[self.childViewControllers objectAtIndex:0];
    FriendMainViewController *secondViewController=[self.childViewControllers objectAtIndex:1];
    DiscoverMainViewController *thirdViewController=[self.childViewControllers objectAtIndex:2];
    MineMainViewController *fourViewController=[self.childViewControllers objectAtIndex:3];
    
    if ((_currentViewController==firstViewController&&index==1)||(_currentViewController==secondViewController&&index==2) ||(_currentViewController==thirdViewController&&index==3)||(_currentViewController==fourViewController&&index==4)) {
        return;
    }
    
    self.lastSelectIndex = index;

    switch (index) {
        case 1:
        {
            
            
            [self transitionFromViewController:_currentViewController toViewController:firstViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                _toolbar.frame = _initialRect;
                
            } completion:^(BOOL finished) {
                _currentViewController=firstViewController;
                [self changeNavBar:1];
                
            }];
        }
            break;
        case 2:
        {
            
            
            [self transitionFromViewController:_currentViewController toViewController:secondViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                _toolbar.frame = _initialRect;
                
            } completion:^(BOOL finished) {
                _currentViewController=secondViewController;
                [self changeNavBar:2];
                
            }];
        }
            break;
        case 3:
        {
            
            
            [self transitionFromViewController:_currentViewController toViewController:thirdViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                _toolbar.frame = _initialRect;
                
            } completion:^(BOOL finished) {
                _currentViewController=thirdViewController;
                [self changeNavBar:3];
                
            }];
        }
            break;
        case 4:
        {
            
            
            [self transitionFromViewController:_currentViewController toViewController:fourViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                
                _toolbar.frame = CGRectMake(_initialRect.origin.x, _initialRect.origin.y+64, _initialRect.size.width, _initialRect.size.height);
                
            } completion:^(BOOL finished) {
                _currentViewController=fourViewController;
                [self changeNavBar:4];
                
            }];
        }
            break;
            
            
        default:
            break;
    }
    UIButton *selectbtn;
    
    if ([sender isKindOfClass:[UIButton class]]) {
        
        selectbtn = sender;
        _oldButton.selected = NO;
        selectbtn.selected = YES;
        _oldButton = selectbtn;
        
        
    }else{
        
        [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if (idx == index) {
                
                ((UIButton *)obj).selected = YES;
                _oldButton.selected = NO;
            }
            
        }];
    }
    

    
    
    
    
}


-(void)changeNavBar:(int)index
{
    switch (index) {
        case 1:
        {
            self.title = @"微信";
        }
            
            break;
        case 2:
        {
            self.title = @"朋友";
        }
            break;
        case 3:
        {
            self.title = @"发现";
         }
            break;
        case 4:
        {
            self.title = @"个人中心";
        }
            break;
            
            
        default:
            break;
    }
}


-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
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
