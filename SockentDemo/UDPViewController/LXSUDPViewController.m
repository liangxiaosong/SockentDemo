//
//  LXSUDPViewController.m
//  SockentDemo
//
//  Created by LPPZ-User01 on 2017/6/29.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSUDPViewController.h"
#import "GCDAsyncUdpSocket.h" // for UDP
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface LXSUDPViewController ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket * udpSocket;

@end
#define udpPort 2345
@implementation LXSUDPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [_udpSocket bindToPort:udpPort error:&error];
    if (error) {
        NSLog(@"error %@",error);
    }else {
        [_udpSocket beginReceiving:&error];
    }
    NSData *data = [@"hahha" dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:[self deviceIPAdress] port:udpPort withTimeout:-1 tag:0];



}

- (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    success = getifaddrs(&interfaces);

    if (success == 0) { // 0 表示获取成功

        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }

            temp_addr = temp_addr->ifa_next;
        }
    }

    freeifaddrs(interfaces);
    return address;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GCDAsyncUdpSocket delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送信息成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"发送信息失败");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{

    NSLog(@"接收到%@的消息",address);
    NSString * sendMessage = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"udpSocket关闭");
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
