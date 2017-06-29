//
//  LXSSocketManager.m
//  SockentDemo
//
//  Created by LPPZ-User01 on 2017/6/10.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSSocketManager.h"
//for tcp
#import "GCDAsyncSocket.h"

static  NSString * Khost = @"www.baidu.com";
static const uint16_t Kport = 80;

@interface LXSSocketManager ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket      *_gcdSocket;
}
@end

@implementation LXSSocketManager

+ (instancetype)managerShare {
    static dispatch_once_t onceToken;
    static LXSSocketManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[LXSSocketManager alloc] init];
        [instance initSocket];
        [instance connect];
    });
    return instance;
}

- (void)initSocket {
    _gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

/**
 连接

 @return 返回结果 成功或者失败
 */
- (BOOL)connect {
    return [_gcdSocket connectToHost:Khost onPort:Kport withTimeout:-1 error:nil];
}

- (void)disConnect {
    [_gcdSocket disconnect];
}

/**
 字典转json串

 @param dic 字典
 @return 字符串
 */
- (NSString *)dictionaryToJson:(NSDictionary *)dic {
     NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//发送消息
- (void)sendMsg:(NSString *)msg
{

    NSData *data  = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data textType:@"txt"];
}

- (void)sendData:(NSData *)data textType:(NSString *)type
{
    NSUInteger size = data.length;

    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    [headDic setObject:type forKey:@"type"];
    [headDic setObject:[NSString stringWithFormat:@"%ld",size] forKey:@"size"];
    NSString *jsonStr = [self dictionaryToJson:headDic];


    NSData *lengthData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];


    NSMutableData *mData = [NSMutableData dataWithData:lengthData];
    //分界
    [mData appendData:[GCDAsyncSocket CRLFData]];

    [mData appendData:data];
    BOOL NY = [self connect];
    NSLog(@"%d",NY);
    //第二个参数，请求超时时间
    [_gcdSocket writeData:mData withTimeout:-1 tag:110];

}

//监听最新的消息
- (void)pullTheMsg
{
    //貌似是分段读数据的方法
    //    [gcdSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:50000 tag:110];

    //监听读数据的代理，只能监听10秒，10秒过后调用代理方法  -1永远监听，不超时，但是只收一次消息，
    //所以每次接受到消息还得调用一次
    [_gcdSocket readDataWithTimeout:-1 tag:110];
    
}

#pragma mark - GCDAsyncSocketDelegate

/**
 连接成功

 @param sock GCDAsyncSocket 属性
 @param host ip
 @param port 端口
 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功,host:%@,port:%d",host,port);
    [self pullTheMsg];

    [sock startTLS:nil];
    //心跳写在这...
}

/**
 写入data完成会触发的回调。
 */
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"写的回调,tag:%ld",tag);
    //判断是否成功发送，如果没收到响应，则说明连接断了，则想办法重连
    [self pullTheMsg];
}

/**
 收到data后的call back
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

}

/**
 断线后的call back,这边可以做自动重新连线机制。
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"断开连接,host:%@,port:%d",sock.localHost,sock.localPort);
    //断线重连写在这...
//    [self connect];
}

/**
 这个call back 就是当收到不完整的packet (收到data, 但没有找到terminal data) 就会触发。

 @param partialLength 部分数据的长度
 */
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {

}


@end
