//
//  AppDelegate.m
//  IMDemo
//
//  Created by micaimanong on 16/6/4.
//  Copyright © 2016年 迷彩码农. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

#define JBXMPP_HOST @"imacdeimac-2.local"
#define JBXMPP_PORT 5222
#define JBXMPP_DOMAIN @"imacdeimac-2.local"


@interface AppDelegate ()

@end

@implementation AppDelegate



/**
 *  初始化Xmpp流
 */
-(void)setupStream{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        //初始化XMPPStream
        [self.xmppStream setHostName:JBXMPP_HOST]; //设置xmpp服务器地址
        [self.xmppStream setHostPort:JBXMPP_PORT]; //设置xmpp端口，默认5222
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self.xmppStream setKeepAliveInterval:30]; //心跳包时间
        self.xmppStream.enableBackgroundingOnSocket=YES;    //允许xmpp在后台运行

        //接入断线重连模块
        _xmppReconnect = [[XMPPReconnect alloc] init];
        [_xmppReconnect setAutoReconnect:YES];
        [_xmppReconnect activate:self.xmppStream];
        
        //接入流管理模块，用于流恢复跟消息确认，在移动端很重要
        _storage = [XMPPStreamManagementMemoryStorage new];
        _xmppStreamManagement = [[XMPPStreamManagement alloc] initWithStorage:_storage];
        _xmppStreamManagement.autoResume = YES;
        [_xmppStreamManagement addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppStreamManagement activate:self.xmppStream];
        
        //接入好友模块，可以获取好友列表
        _xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterMemoryStorage];
        [_xmppRoster activate:self.xmppStream];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //接入消息模块，将消息存储到本地
        _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 9)];
        [_xmppMessageArchiving activate:self.xmppStream];
        
        
    }
}
/**
 *  登录
 */
-(void)connect{
    [self setupStream];
    NSString *userId = @"111";
    XMPPJID *jid = [XMPPJID jidWithUser:userId domain:JBXMPP_DOMAIN resource:@"iOS"];
    [self.xmppStream setMyJID:jid];
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
}
/**
 *  断开连接
 */
-(void)disconnect{
    [self goOffline];
    [self.xmppStream disconnect];
}
/**
 *  发送在线状态
 */
-(void)goOnline{
    //发送在线通知给服务器，服务器才会将离线消息推送过来
    XMPPPresence *presence = [XMPPPresence presence]; // 默认"available"
    [[self xmppStream] sendElement:presence];
}
/**
 *  发送下线状态
 */
-(void)goOffline{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    [self.xmppStream disconnect];
}



#pragma mark - XmppDelegate 的实现
//1.connect成功之后会依次调用XMPPStreamDelegate的方法，首先调用
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"我连上了");
}
//2.然后是    在该方法下面需要使用xmppStream 的authenticateWithPassword方法进行密码验证
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"验证密码的正确性");
    password = @"111111";
    NSError *error = nil;
    [[self xmppStream] authenticateWithPassword:password error:&error];
}
//3.验证通过  登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"上线");
    [self goOnline];
    //启用流管理
    [_xmppStreamManagement enableStreamManagementWithResumption:YES maxTimeout:0];
}
//3.1 验证未通过  登陆失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%s",__func__);
}
//4.获取好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{

}

















- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window =[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    LoginViewController *logV = [[LoginViewController alloc]init];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:logV];
    self.window.rootViewController = nav;
    
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
