//
//  IMBaseClient.h
//  IMDemo
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 迷彩码农. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPP.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import <UIKit/UIKit.h>
@class GCDMulticastDelegate;
@protocol IMClientDelegate;

typedef NS_ENUM(NSInteger, IMClientState)
{
    IMClientStateDisconnected = 0,
    IMClientStateConnecting,
    IMClientStateConnected,
};

@interface IMBaseClient : NSObject<XMPPStreamDelegate,XMPPRosterDelegate>
{
    NSString *_userID;
    NSString *_passwd;
    NSString *_host;
    NSUInteger _port;
    
    IMClientState _clientState;
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    
    
    //好友管理
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPRoster *xmppRoster;
    XMPPvCardCoreDataStorage *xmppvCardStorage ;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilitiesCoreDataStorage *xmppCapailitiesStorage;
    XMPPCapabilities *xmppCapabilities;
    XMPPMessageArchivingCoreDataStorage *xmppMessageStorage;
    XMPPMessageArchiving *xmppMessageArchiving;
    
}
// 收到好友请求执行的方法-(void)xmppRoster:(XMPPRoster )sender didReceivePresenceSubscriptionRequest:(XMPPPresence )presence{ self.fromJid = presence.from; UIAlertView alert = [[UIAlertView alloc]initWithTitle:@"提示:有人添加你" message:presence.from.user  delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"OK", nil]; [alert show];}
@property (nonatomic, readonly, strong) GCDMulticastDelegate <IMClientDelegate> *delegates;


+ (id)sharedManager;

-(BOOL)connect;
-(void)logout;

-(void)goOnLine;
-(void)goOffLine;

-(BOOL)loginWithUserID:(NSString*)userID passWord:(NSString*)passwd;
-(void)initWithHost:(NSString*)host port:(NSString*)port;

@end


@protocol IMClientDelegate <NSObject>

@optional
- (void)imClient:(IMBaseClient *)client stateChanged:(IMClientState)state;


@end