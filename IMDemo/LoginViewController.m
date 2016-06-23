//
//  LoginViewController.m
//  IMDemo
//
//  Created by micaimanong on 16/6/4.
//  Copyright © 2016年 迷彩码农. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
 
    
    // Do any additional setup after loading the view from its nib.
}
-(void)makeUI{
    for (int i = 0; i<2; i++) {
        UITextField *textName = [[UITextField alloc]initWithFrame:CGRectMake(50,100 + i*100, 250, 50)];
        textName.tag = 1000+ i ;
        textName.delegate = self;
        textName.layer.borderWidth = 2;
        textName.layer.cornerRadius = 10;
        textName.layer.borderColor = [UIColor grayColor].CGColor;
        if (i== 0) {
            textName.placeholder = @"请输入账号";
        }else{
            textName.placeholder = @"请输入密码";
        }
        [self.view addSubview:textName];
  
    }
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(50 + i*150, 400, 100, 50);
        button.layer.borderWidth = 2;
        button.layer.cornerRadius = 10;
        button.layer.borderColor = [UIColor redColor].CGColor;
        [self.view addSubview:button];
        
        if (!i) {
            [button setTitle:@"登录" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button setTitle:@"注册" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(registerBtnDown) forControlEvents:UIControlEventTouchUpInside];
        }
       
  
    }
   
}
-(void)registerBtnDown{
    RegisterViewController *registView = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registView animated:YES];
}
-(void)buttonDown{
    
    AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [del connect];
        
//        MainViewController *mainView =[[MainViewController alloc] init];
//        [self.navigationController pushViewController:mainView animated:YES];
  
    
}
#pragma mark --------TextFileDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    UITextField *textname = (UITextField*)[self.view viewWithTag:1000];
    UITextField *textpass = (UITextField*)[self.view viewWithTag:1001];
    [textname resignFirstResponder];
    [textpass resignFirstResponder];
    return YES;
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
