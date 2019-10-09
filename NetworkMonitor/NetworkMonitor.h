//
//  NetworkMonitor.h
//  NetworkMonitor
//
//  Created by walen on 2019/10/9.
//  Copyright © 2019 CJH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkMonitor : NSObject

/// 创建实例化对象
+ (instancetype)shareInstance;


/// 网速监听
- (void)networkMonitorSpeed:(void(^)(NSString *inStream, NSString *outStream))scheduleBlock;


/// 网络类型监听
- (void)networkTypeMonitor:(void(^)(NSString *networkType))networkTypeBlock;

@end

NS_ASSUME_NONNULL_END
