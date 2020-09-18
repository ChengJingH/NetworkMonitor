//
//  ViewController.m
//  NetworkMonitor
//
//  Created by walen on 2019/10/4.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "ViewController.h"
#import "NetworkMonitor.h"
#import "NetworkStatusView.h"

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
    
//    UIView *b = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    b.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:b];

//    //监控网络（网卡）速度
//    [[NetworkMonitor shareInstance] networkMonitorSpeed:^(NSString * _Nonnull inStream, NSString * _Nonnull outStream) {
//        weakSelf.i_speed.text = [NSString stringWithFormat:@"下载速度：%@",inStream];
//        weakSelf.o_speed.text = [NSString stringWithFormat:@"上传速度：%@",outStream];
//    }];
    
    //缓存大小
//    [[NetworkMonitor shareInstance] cacheSize];
}


//+ (void)commonWithApi:(NSString *)url parameters:(id)params responseBlock:(void(^)(id, NSString *, BOOL, BOOL))responseBlock {
//    //因为程序启动瞬间会有请求，而reachabilityManager来不及更新网络状态，因此修改无网判断如下
//    if ([NetworkEngine sharedClient].reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
//        if (responseBlock) responseBlock(nil, @"网络连接失败", NO, NO);
//        return;
//    }
//    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
//    if (params) [mutableDict addEntriesFromDictionary:params];
//    mutableDict = [NetworkEngine replaceEmptyFromNilInDictionary:mutableDict];
//
//#ifdef DEBUG
////    NSLog(@"%@ - 时长 - %f",url,[NetworkMonitor getUptimeInMilliseconds]);
//    [[NetworkMonitor shareInstance].dataSource setObject:[NSNumber numberWithFloat:[NetworkMonitor getUptimeInMilliseconds]] forKey:url];
//    [[NetworkMonitor shareInstance].statusSource setObject:@"0" forKey:url];
//    if ([[NetworkMonitor shareInstance].countSource objectForKey:url]) {
//        NSNumber *countUrl = [[NetworkMonitor shareInstance].countSource objectForKey:url];
//        [[NetworkMonitor shareInstance].countSource setObject:[NSNumber numberWithInt:countUrl.intValue+1] forKey:url];
//    }else{
//        [[NetworkMonitor shareInstance].countSource setObject:[NSNumber numberWithInt:1] forKey:url];
//    }
//
//#endif
//    [[NetworkEngine sharedClient] POST:url parameters:mutableDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        GUResponseStatus responseStatus = [NetworkEngine checkResponceObjectStatusCode:responseObject];
//#ifdef DEBUG
////        NSLog(@"\n ----- start ----- \n%s \n url = %@ \n responseObject = %@\n ---- end ---- \n", __func__,task.currentRequest.URL.absoluteString, [(NSDictionary *)responseObject mj_JSONString]);
//        NSNumber *countUrl = [[NetworkMonitor shareInstance].countSource objectForKey:url];
//        [[NetworkMonitor shareInstance].countSource setObject:[NSNumber numberWithInt:countUrl.intValue-1] forKey:url];
//        [[NetworkMonitor shareInstance].statusSource setObject:@"1" forKey:url];
//        if (countUrl.intValue-1 == 0) {
//            NSNumber *stime = [[NetworkMonitor shareInstance].dataSource objectForKey:url];
//            [[NetworkMonitor shareInstance].dataSource setObject:[NSNumber numberWithFloat:[NetworkMonitor getUptimeInMilliseconds]-stime.floatValue] forKey:url];
////            NSLog(@"%@ - 时长 - %f - %f",url,[NetworkMonitor getUptimeInMilliseconds],stime.floatValue);
//        }
//#endif
//        BOOL isSuccess = responseStatus == GUResponseStatusSuccess;
//        //处理token过期
//        if (responseStatus == GUResponseStatusTokenExpire) {
//            [GUAppDelegate refreshTokenResult:^(BOOL success) {
//                if (success) {
//                    [self commonWithApi:url parameters:params responseBlock:responseBlock];
//                } else {
//                    if (responseBlock) responseBlock(responseObject[ResponseCode], responseObject[ResponseMessage] ? : @"系统错误", isSuccess, NO);
//                }
//            }];
//        } else  {
//            if (isSuccess) {
//                if (responseBlock) responseBlock (responseObject[ResponseData], responseObject[ResponseMessage] ? : @"系统错误", isSuccess, NO);
//            } else {
//                if (responseBlock) responseBlock (responseObject[ResponseCode], responseObject[ResponseMessage] ? : @"系统错误", isSuccess, NO);
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        BLYLogError(@"%s url:%@, failed with error : %@", __func__, url, [error localizedDescription]);
//#ifdef DEBUG
//        NSLog(@"%s url:%@, failed with error : %@", __func__, url, [error localizedDescription]);
//        NSNumber *countUrl = [[NetworkMonitor shareInstance].countSource objectForKey:url];
//        [[NetworkMonitor shareInstance].countSource setObject:[NSNumber numberWithInt:countUrl.intValue-1] forKey:url];
//        if (countUrl.intValue-1 == 0) {
//            NSNumber *stime = [[NetworkMonitor shareInstance].dataSource objectForKey:url];
//            [[NetworkMonitor shareInstance].dataSource setObject:[NSNumber numberWithFloat:[NetworkMonitor getUptimeInMilliseconds]-stime.floatValue] forKey:url];
//        }
//#endif
//        if (responseBlock) responseBlock (nil, [error localizedDescription], NO, error.code == NSURLErrorCancelled);
//    }];
//}


@end
