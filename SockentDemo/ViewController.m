//
//  ViewController.m
//  SockentDemo
//
//  Created by LPPZ-User01 on 2017/6/8.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP

@interface ViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket            *clientSockent;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clientSockent = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //创建几个按钮以供测试
    [self createUI];
}

#pragma mark - createUI
- (void)createUI {
    //连接服务器按钮
    UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:connectBtn];
    [connectBtn setTitle:@"链接服务器" forState:UIControlStateNormal];
    [connectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    connectBtn.backgroundColor = [UIColor whiteColor];
    connectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    connectBtn.frame = CGRectMake(100, 100, 100, 30);
    [connectBtn addTarget:self action:@selector(connectBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:receiveBtn];
    [receiveBtn setTitle:@"接受数据" forState:UIControlStateNormal];
    [receiveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    receiveBtn.backgroundColor = [UIColor whiteColor];
    receiveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    receiveBtn.frame = CGRectMake(100, 140, 100, 30);
    [receiveBtn addTarget:self action:@selector(receiveBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:readBtn];
    [readBtn setTitle:@"收到的数据" forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    readBtn.backgroundColor = [UIColor whiteColor];
    readBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    readBtn.frame = CGRectMake(100, 140, 100, 30);
    [readBtn addTarget:self action:@selector(readBtn:) forControlEvents:UIControlEventTouchUpInside];


}

#pragma mark - activeBtn
- (void)connectBtn:(UIButton *)sender {
    [self.clientSockent connectToHost:@"www.baidu.com" onPort:80 error:nil];
}

- (void)receiveBtn:(UIButton *)sender {
    NSString *str = @"www.lppz.com";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSockent writeData:data withTimeout:-1 tag:0];
}

- (void)readBtn {
    [self.clientSockent readDataWithTimeout:20 tag:0];
}

#pragma mark -GCDAsyncSocketDelegate
//链接后直接调用
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"%@ ===%zi",host,port);
}

//接受到的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dict);
    [self.clientSockent readDataWithTimeout:-1 tag:0];
}

//链接失败
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"错误信息%@",err);
}

@end
