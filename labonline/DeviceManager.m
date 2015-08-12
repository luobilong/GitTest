//
//  DeviceManager.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "DeviceManager.h"
#import <UIKit/UIKit.h>

@implementation DeviceManager

//获取屏幕的高度
+ (NSInteger)currentScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (NSInteger)currentScreenWidth
{
  return [UIScreen mainScreen].bounds.size.width;
}

//判断操作系统是否为iOS7
+ (NSInteger)deviceVersion
{
    //获取到操作系统的版本号
    NSString *currentVersion = [UIDevice currentDevice].systemVersion;
    //hasPrefix 字符串的方法，判断版本号是否有7的前缀
    return [currentVersion integerValue];
}

//获取设备的型号 返回的是一个字符串
+ (NSString *)currentDeviceModel
{
    // UIDevice跟设备参数相关的类，设备的版本号、设备名称、设备型号、等参数通过此类获取
    //currentDevice 通过此方法获取到UIdevice单例
    return [UIDevice currentDevice].model;
}


@end
