//
//  ViewController.m
//  YFX_UDPScoketServer
//
//  Created by fangxue on 2017/1/10.
//  Copyright © 2017年 fangxue. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"
@interface ViewController ()<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *serverSocket;
    NSString *host1;
    uint16_t port1;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    serverSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()] ;
    
    NSError *bindError = nil;
    
    [serverSocket bindToPort:8099 error:&bindError];
    
    [serverSocket enableBroadcast:YES error:&bindError];//允许广播 必须 否则后面无法发送组播和广播
    
    NSError *receiveError = nil;
    
    [serverSocket joinMulticastGroup:@"224.0.0.1" error:nil];
    
    [serverSocket beginReceiving:&receiveError];//开始接收数据，一定要否则后面无法接收数据 不接收数据时调用pauseReceiving
    
}
//udpsocket的关键回调方法：接收到客户端socket发送的消息响应如下
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *host = nil;
    uint16_t port = 0;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    host1 = host;
    port1 = port;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [serverSocket sendData:[@"123" dataUsingEncoding:NSUTF8StringEncoding] toHost:host1 port:port1 withTimeout:-1 tag:0];
}
@end
