//
//  IMBaseClient.m
//  IMDemo
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 迷彩码农. All rights reserved.
//

#import "IMBaseClient.h"
#import "DDLog.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@implementation IMBaseClient

-(instancetype)init{
    self = [super init];
    if (self) {
      _delegates = (GCDMulticastDelegate<IMClientDelegate> *)[[GCDMulticastDelegate alloc]init];
    }
    return self;
}
-(BOOL)loginWithUserID:(NSString *)userID passWord:(NSString *)passwd{
    if (userID == nil || passwd == nil)
        return NO;
    
    _userID = userID;
    _passwd = passwd;
    
    if (xmppStream != nil)
        [self teardownStream];
    [self setupStream];
    
    return [self connect];
    
}

/**
 *  初始化Xmpp流
 */

- (void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    xmppStream.enableBackgroundingOnSocket = YES;
#endif
    xmppReconnect = [[XMPPReconnect alloc] init];
    [xmppReconnect setAutoReconnect:YES];
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [xmppStream setHostName:_host];
    [xmppStream setHostPort:_port];
    
    
}
/**
 *  销毁Xmpp流
 */
- (void)teardownStream
{
    [xmppStream removeDelegate:self];
    [xmppReconnect removeDelegate:self];
    [xmppReconnect deactivate];
    [xmppStream disconnect];
    xmppStream = nil;
    xmppReconnect = nil;
    
}
/**
 *  登录
 */
-(BOOL)connect{
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (_userID == nil || _passwd == nil) {
        DDLogError(@"%@: userId or passwd is nil", THIS_METHOD);
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:_userID
                                       resource:@"iOS"]];
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        DDLogError(@"Error connecting: %@", error);
        
        return NO;
    }
    return YES;
}
/**
 *  断开连接
 */
-(void)disconnect{
    [self goOffline];
    [xmppStream disconnect];
}
/**
 *  发送在线状态
 */
-(void)goOnline{
    //发送在线通知给服务器，服务器才会将离线消息推送过来
    XMPPPresence *presence = [XMPPPresence presence]; // 默认"available"
    [xmppStream sendElement:presence];
}
/**
 *  发送下线状态
 */
-(void)goOffline{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
    [xmppStream disconnect];
}



#pragma mark - XmppDelegate 的实现
-(void)xmppStreamWillConnect:(XMPPStream *)sender{
    [self.delegates imClient:self stateChanged:_clientState];
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

}

//1.connect成功之后会依次调用XMPPStreamDelegate的方法，首先调用
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"我连上了");
}
//2.然后是    在该方法下面需要使用xmppStream 的authenticateWithPassword方法进行密码验证
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"验证密码的正确性");
    _passwd = @"111111";
    NSError *error = nil;
    [xmppStream authenticateWithPassword:_passwd error:&error];
}
//3.验证通过  登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"上线");
    [self goOnline];
    //启用流管理
    //    [_xmppStreamManagement enableStreamManagementWithResumption:YES maxTimeout:0];
}
//3.1 验证未通过  登陆失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%s",__func__);
}
//4.获取好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
}


@end
