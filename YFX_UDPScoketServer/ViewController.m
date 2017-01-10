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
}
@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    serverSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()] ;
    
    NSError *bindError = nil;
    //绑定服务端端口号
    [serverSocket bindToPort:8099 error:&bindError];
    
    if (bindError) {
        
        NSLog(@"bindError = %@",bindError);
    }
    NSError *receiveError = nil;
    
    [serverSocket beginReceiving:&receiveError];
    
    if (receiveError) {
        
        NSLog(@"receiveError = %@",receiveError);
    }
    //172.20.10.1为当前作为服务端设备的IP地址
    [serverSocket joinMulticastGroup:@"172.20.10.1" error:nil];
}
//udpsocket的关键回调方法：接收到客户端socket发送的消息响应如下
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    
    NSLog(@"接收到客户端的消息 = %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [serverSocket sendData:data toAddress:address withTimeout:-1 tag:0];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSData *data = [@"我是服务端" dataUsingEncoding:NSUTF8StringEncoding];
    //发送数据给客户端  172.20.10.3和8000分别为客户端的IP地址和端口号
    [serverSocket sendData:data toHost:@"172.20.10.3" port:8000 withTimeout:-1 tag:0];
    
}

@end
