//
//  LXSSocketManager.h
//  SockentDemo
//
//  Created by LPPZ-User01 on 2017/6/10.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXSSocketManager : NSObject

+ (instancetype)managerShare;

/**
 连接
 */
- (BOOL)connect;

/**
 断开连接
 */
- (void)disConnect;

/**
 发送消息

 @param msg 消息文本
 */
- (void)sendMsg:(NSString *)msg;

@end
