//
//  AppDelegate.h
//  IMDemo
//
//  Created by micaimanong on 16/6/4.
//  Copyright © 2016年 迷彩码农. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPStreamManagementMemoryStorage.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate>{
    BOOL isOpen;
    NSString *password;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong)XMPPStream *xmppStream;

@property (nonatomic ,strong)XMPPReconnect *xmppReconnect;

@property (nonatomic ,strong)XMPPStreamManagementMemoryStorage *storage;

@property (nonatomic ,strong)XMPPStreamManagement *xmppStreamManagement;

@property (nonatomic ,strong)XMPPRosterMemoryStorage *xmppRosterMemoryStorage;

@property (nonatomic ,strong) XMPPRoster *xmppRoster;

@property (nonatomic ,strong)XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic ,strong)XMPPMessageArchiving *xmppMessageArchiving;
-(void)connect;
-(void)disConnect;
-(void)setupStream;
-(void)goOnLine;
-(void)goOffLine;


@end

