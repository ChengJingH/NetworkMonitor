//
//  ViewController.m
//  NetworkMonitor
//
//  Created by walen on 2019/10/4.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "ViewController.h"
#import <Network/Network.h>

#include <stdio.h>
#include <string.h>
#include <net/if.h>
#include <sys/ioctl.h>
#include <arpa/inet.h>
#include <errno.h>
#include <ifaddrs.h>

@interface ViewController ()
{
    float iSpeed;
    float oSpeed;
}
@property (nonatomic, strong)dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet UILabel *i_speed;
@property (weak, nonatomic) IBOutlet UILabel *o_speed;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //网络状态监控
    [self networkMonitor];
    
    //监控网络（网卡）速度
    [self newworkMonitorSpeed];
}

- (void)newworkMonitorSpeed
{
    static uint32_t i_vel = 0;
    static uint32_t o_vel = 0;
    __weak typeof (self)weakSelf = self;

    //创建计时器
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        struct ifaddrs *ifa = NULL, *ifList;
        
        int result = getifaddrs(&ifList);
        if (result < 0 ) {
            NSLog(@"获取接口信息失败");
        }
        
        uint32_t iBytes = 0;
        uint32_t oBytes = 0;
        for (ifa = ifList; ifa != NULL; ifa = ifa->ifa_next) {
            //AF_LINK 传输协议
            if (ifa->ifa_addr->sa_family != AF_LINK)
                continue;
            if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
                continue;
            if (ifa->ifa_data == 0)
                continue;
            
            if (strncmp(ifa->ifa_name, "lo", 2)) {
                struct if_data *if_data = (struct if_data *)ifa->ifa_data;
                iBytes += if_data->ifi_ibytes;
                oBytes += if_data->ifi_obytes;
            }
        }
        freeifaddrs(ifList);
        
        NSLog(@"iBytes ~ %u oBytes ~ %u",iBytes,oBytes);
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.i_speed.text = [NSString stringWithFormat:@"下载速度：%@",[self formatNetworkSpeed:iBytes - i_vel]];
            weakSelf.o_speed.text = [NSString stringWithFormat:@"发送速度：%@",[self formatNetworkSpeed:oBytes - o_vel]];
        });
        
        i_vel = iBytes;
        o_vel = oBytes;

    });
    dispatch_resume(_timer);
}

- (NSString *)formatNetworkSpeed:(uint32_t)flow
{
    NSString *speed = @"0.00 b/s";
    if (flow >= 1024 * 1024 * 1024) {
        speed = [NSString stringWithFormat:@"%.2f g/s",flow / (1024 * 1024 * 1024.0)];
    }else if (flow >= 1024 * 1024) {
        speed = [NSString stringWithFormat:@"%.2f m/s",flow / (1024 * 1024.0)];
    }else if (flow >= 1024){
        speed = [NSString stringWithFormat:@"%.2f k/s",flow / 1024.0];
    }else{
        speed = [NSString stringWithFormat:@"%.2f b/s",flow / 1.0];
    }
    return speed;
}


- (void)networkMonitor
{
    //创建系统所有类型接口监视器
    nw_path_monitor_t path_monitor_t = nw_path_monitor_create();
    
    //接口监视器取消回调
    nw_path_monitor_set_cancel_handler(path_monitor_t, ^{
        NSLog(@"cancel");
    });
    
    //接口监视器更新回调
    nw_path_monitor_set_update_handler(path_monitor_t, ^(nw_path_t  _Nonnull path) {
        NSLog(@"update");

        NSLog(@"status ~ %u",nw_path_get_status(path));
        
        //是否支持ipv4
        if (nw_path_has_ipv4(path)) {
            NSLog(@"path支持ipv4");
        }
        
        //是否支持ipv6
        if (nw_path_has_ipv6(path)) {
            NSLog(@"path支持ipv6");
        }
        
        //是否支持dns
        if (nw_path_has_dns(path)) {
            NSLog(@"path支持dns");
        }
        
        //本地端口
        nw_endpoint_t local_point = nw_path_copy_effective_local_endpoint(path);
        nw_endpoint_type_t local_type = nw_endpoint_get_type(local_point);
        if (local_type == nw_endpoint_type_address) {
            const struct sockaddr *address = nw_endpoint_get_address(local_point);
            NSLog(@"local_point IP ~ %s",address->sa_data);
        }
        if (local_type == nw_endpoint_type_host) {
            NSLog(@"local_point hostname ~ %s",nw_endpoint_get_hostname(local_point));
        }
        if (local_type == nw_endpoint_type_url) {
            NSLog(@"local_point url ~ %s",nw_endpoint_get_url(local_point));
        }
        
        //远端端口
        nw_endpoint_t remote_point = nw_path_copy_effective_remote_endpoint(path);
        nw_endpoint_type_t remote_type = nw_endpoint_get_type(remote_point);
        if (remote_type == nw_endpoint_type_address) {
            const struct sockaddr *address = nw_endpoint_get_address(remote_point);
            NSLog(@"remote_point IP ~ %s",address->sa_data);
        }
        if (remote_type == nw_endpoint_type_host) {
            NSLog(@"remote_point hostname ~ %s",nw_endpoint_get_hostname(remote_point));
        }
        if (remote_type == nw_endpoint_type_url) {
            NSLog(@"remote_point url ~ %s",nw_endpoint_get_url(remote_point));
        }

        
        //所有接口状态
        nw_path_enumerate_interfaces(path, ^bool(nw_interface_t  _Nonnull interface) {
            nw_interface_type_t interface_type_t = nw_interface_get_type(interface);
            if (interface_type_t == nw_interface_type_other) {
                NSLog(@"other");
            }else if (interface_type_t == nw_interface_type_wifi) {
                NSLog(@"wifi");
            }else if (interface_type_t == nw_interface_type_cellular) {
                NSLog(@"cellular");
            }else if (interface_type_t == nw_interface_type_wired) {
                NSLog(@"wired");
            }else if (interface_type_t == nw_interface_type_loopback) {
                NSLog(@"loopback");
            }
            
            NSLog(@"interface name ~ %s",nw_interface_get_name(interface));
            NSLog(@"interface type ~ %u",nw_interface_get_type(interface));
            
            return YES;
        });
    });
    
    //加入全局队列以防堵塞
    nw_path_monitor_set_queue(path_monitor_t, dispatch_get_global_queue(0, 0));
    
    //开始监控
    nw_path_monitor_start(path_monitor_t);
}


@end
