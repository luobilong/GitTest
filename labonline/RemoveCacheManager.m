//
//  RemoveCacheManager.m
//  labonline
//
//  Created by cocim01 on 15/4/16.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "RemoveCacheManager.h"
#import "PathManager.h"


@implementation RemoveCacheManager

// 系统设置 清除缓存
+ (void)removeUserAllLocalCacheFile
{
    [self removeUserInfo];
    [self removeVidioNSUserDefaults];
    [self removePDFNSUserDefaults];
    [self removeUserPersonCacheWithType:VidioPath];
    [self removeUserPersonCacheWithType:PDFPath];
//    [self removeUserPersonCacheWithType:DataPath];
}

// 清除视频缓存记录
+ (void)removeVidioNSUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"VidioList"];
    [defaults synchronize];
}

// 清除PDF记录
+ (void)removePDFNSUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"PDFArray"];
    [defaults synchronize];
}

// 根据类型清除相应文件夹 例如VidioPath,PDFPath,DataPath
+ (void)removeUserPersonCacheWithType:(PathType)pathType
{
    NSString *path = [PathManager getCatePathWithType:pathType];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
    }
}

// 删除用户信息
+ (void)removeUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userName"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"id"];
    [userDefaults removeObjectForKey:@"nickname"];
    [userDefaults removeObjectForKey:@"phone"];
    [userDefaults removeObjectForKey:@"email"];
    [userDefaults removeObjectForKey:@"icon"];
    [userDefaults synchronize];
}

@end
