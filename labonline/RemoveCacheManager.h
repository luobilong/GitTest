//
//  RemoveCacheManager.h
//  labonline
//
//  Created by cocim01 on 15/4/16.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoveCacheManager : NSObject

// 系统设置 清除缓存
+ (void)removeUserAllLocalCacheFile;
// 清除视频缓存记录
+ (void)removeVidioNSUserDefaults;
// 清除PDF记录
+ (void)removePDFNSUserDefaults;
// 根据类型清除相应文件夹 例如VidioPath,PDFPath,DataPath
+ (void)removeUserPersonCacheWithType:(PathType)pathType;
// 删除用户信息
+ (void)removeUserInfo;

@end
