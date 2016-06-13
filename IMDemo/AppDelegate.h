//
//  AppDelegate.h
//  IMDemo
//
//  Created by micaimanong on 16/6/4.
//  Copyright © 2016年 迷彩码农. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate>{
    XMPPStream *xmppStream ;
    BOOL isOpen;
    NSString *password;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong)XMPPStream *xmppStream;


-(BOOL)connect;
-(void)disConnect;
-(void)setupStream;
-(void)goOnLine;
-(void)goOffLine;


@end

