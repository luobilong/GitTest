//
//  PathManager.m
//  labonline
//
//  Created by cocim01 on 15/4/14.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "PathManager.h"

@implementation PathManager


+ (NSString *)getCatePathWithType:(PathType)type
{
    NSArray *typeArr = @[@"MyOff-lineVidio",@"PDF",@"DataRequest"];
    NSString *basePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/UserCache"];
    NSString *path = [NSString stringWithFormat:@"%@/%@",basePath,[typeArr objectAtIndex:type]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isDirExist == NO)
    {
        if (![self createPathWithPath:path])
        {
            return nil;
        }
    }
    return path;
}

+ (BOOL)createPathWithPath:(NSString *)path
{
    BOOL bCreateDir = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if(!bCreateDir)
    {
        return NO;
    }
    return YES;
}


@end
