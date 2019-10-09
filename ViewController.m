//
//  ViewController.m
//  NetworkMonitor
//
//  Created by walen on 2019/10/4.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "ViewController.h"
#import "NetworkMonitor.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *i_speed;
@property (weak, nonatomic) IBOutlet UILabel *o_speed;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self)weakSelf = self;
    
    //网络状态监控
    [[NetworkMonitor shareInstance] networkTypeMonitor:^(NSString * _Nonnull networkType) {
        __block UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:networkType preferredStyle:UIAlertControllerStyleAlert];
        [weakSelf presentViewController:alertView animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    //监控网络（网卡）速度
    [[NetworkMonitor shareInstance] networkMonitorSpeed:^(NSString * _Nonnull inStream, NSString * _Nonnull outStream) {
        weakSelf.i_speed.text = [NSString stringWithFormat:@"下载速度：%@",inStream];
        weakSelf.o_speed.text = [NSString stringWithFormat:@"上传速度：%@",outStream];
    }];
    
}



@end
