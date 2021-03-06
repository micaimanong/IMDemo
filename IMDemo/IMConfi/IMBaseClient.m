//
//  IMBaseClient.m
//  IMDemo
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 迷彩码农. All rights reserved.
//

#import "IMBaseClient.h"
#import "DDLog.h"
#define JBXMPP_PORT 5222
#define JBXMPP_DOMAIN @"imacdeimac-2.local"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@implementation IMBaseClient

static id _instance = nil;

+(instancetype)sharedManager{
    return [[self alloc] init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
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
    if (!xmppStream) {
        xmppStream = [[XMPPStream alloc] init];
        [xmppStream setHostName:JBXMPP_DOMAIN]; //设置xmpp服务器地址
        [xmppStream setHostPort:JBXMPP_PORT]; //设置xmpp端口，默认5222
        [xmppStream setKeepAliveInterval:30]; //心跳包时间
        
#if !TARGET_IPHONE_SIMULATOR
        xmppStream.enableBackgroundingOnSocket = YES;
#endif
        
        
        //  XMPPReconnect模块会监控意外断开连接并自动重连
        xmppReconnect = [[XMPPReconnect alloc] init];
        [xmppReconnect setAutoReconnect:YES];
        
        
        // 配置花名册并配置本地花名册储存
        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        xmppRoster.autoFetchRoster = YES;
   
        // 配置vCard存储支持，vCard模块结合vCardTempModule可下载用户Avatar
        xmppvCardStorage = [[XMPPvCardCoreDataStorage alloc] init];
        xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
        xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
        // XMPP特性模块配置，用于处理复杂的哈希协议等
        xmppCapailitiesStorage = [[XMPPCapabilitiesCoreDataStorage alloc] init];
        xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapailitiesStorage];
        xmppCapabilities.autoFetchHashedCapabilities = YES;
        xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
        // 激活XMPP stream
        [xmppReconnect activate:xmppStream];
        [xmppRoster activate:xmppStream];
        [xmppvCardTempModule activate:xmppStream];
        [xmppvCardAvatarModule activate:xmppStream];
        [xmppCapabilities activate:xmppStream];
    
        // 消息相关
        xmppMessageStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
        xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageStorage];
        [xmppMessageArchiving setClientSideMessageArchivingOnly:YES];
        [xmppMessageArchiving activate:xmppStream];

        // 添加代理
        [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [xmppMessageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];


    }
}
/**
 *  销毁Xmpp流
 */
- (void)teardownStream
{
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    [xmppReconnect deactivate];
    [xmppRoster deactivate];
    [xmppvCardTempModule deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities deactivate];
    [xmppMessageArchiving deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppRoster = nil;
    xmppReconnect = nil;
    xmppRosterStorage = nil;
    xmppvCardAvatarModule = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppCapabilities = nil;
    xmppCapailitiesStorage = nil;
    xmppMessageStorage = nil;
    xmppMessageArchiving = nil;
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
    
     XMPPJID *jid = [XMPPJID jidWithUser:_userID domain:JBXMPP_DOMAIN resource:@"iOS"];
    [xmppStream setMyJID:jid];

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
//    [self.delegates imClient:self stateChanged:_clientState];
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

}

//1.connect成功之后会依次调用XMPPStreamDelegate的方法，首先调用
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"我连上了");
}
//2.然后是    在该方法下面需要使用xmppStream 的authenticateWithPassword方法进行密码验证
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"验证密码的正确性");
    NSError *error = nil;
    [xmppStream authenticateWithPassword:_passwd error:&error];
}
//3.验证通过  登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"上线");
    [self goOnline];
    //启用流管理
//    [xmppStreamManagement enableStreamManagementWithResumption:YES maxTimeout:0];
}
//3.1 验证未通过  登陆失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%s",__func__);
}
//4.获取好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Roster
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@", presence);
    [xmppRoster acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
}







@end
