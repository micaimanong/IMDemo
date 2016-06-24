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
#import <UIKit/UIKit.h>
@class GCDMulticastDelegate;
@protocol IMClientDelegate;

typedef NS_ENUM(NSInteger, IMClientState)
{
    IMClientStateDisconnected = 0,
    IMClientStateConnecting,
    IMClientStateConnected,
};

@interface IMBaseClient : NSObject<XMPPStreamDelegate>
{
    NSString *_userID;
    NSString *_passwd;
    NSString *_host;
    NSUInteger _port;
    
    IMClientState _clientState;
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
}
@property (nonatomic, readonly, strong) GCDMulticastDelegate <IMClientDelegate> *delegates;





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