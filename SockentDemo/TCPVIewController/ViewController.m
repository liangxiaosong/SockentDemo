//
//  ViewController.m
//  SockentDemo
//
//  Created by LPPZ-User01 on 2017/6/8.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "ViewController.h"
#import "LXSSocketManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sendBtn];
    [sendBtn setTitle:@"发送数据" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.backgroundColor = [UIColor whiteColor];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sendBtn.frame = CGRectMake(100, 140, 100, 30);
    [sendBtn addTarget:self action:@selector(sendBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *disConnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:disConnectBtn];
    [disConnectBtn setTitle:@"断开连接" forState:UIControlStateNormal];
    [disConnectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    disConnectBtn.backgroundColor = [UIColor whiteColor];
    disConnectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    disConnectBtn.frame = CGRectMake(100, CGRectGetMaxY(sendBtn.frame) + 10, 100, 30);
    [disConnectBtn addTarget:self action:@selector(disConnectBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - activeBtn
- (void)connectBtn:(UIButton *)sender {
    [[LXSSocketManager managerShare] connect];
}

- (void)sendBtn:(UIButton *)sender {
    [[LXSSocketManager managerShare] sendMsg:@"发送数据"];
}

- (void)disConnectBtn:(UIButton *)sender {
    [[LXSSocketManager managerShare] disConnect];
}

@end
