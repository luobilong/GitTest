//
//  DeviceManager.h
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceManager : NSObject

//获取屏幕的高度
+ (NSInteger)currentScreenHeight;
+ (NSInteger)currentScreenWidth;

//判断操作系统是否为iOS7
+ (NSInteger)deviceVersion;

//获取设备的型号 返回的是一个字符串
+ (NSString *)currentDeviceModel;

@end
