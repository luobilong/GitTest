//
//  NetManager.m
//  labonline
//
//  Created by cocim01 on 15/4/10.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "NetManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@implementation NetManager
{
//    AFHTTPRequestOperation *operation;
    NSOperationQueue *queue;
    BOOL _userStop;
}

static NetManager *netmanager = nil;
+ (NetManager*)getShareManager
{
    if (netmanager == nil)
    {
        netmanager = [[NetManager alloc]init];
    }
    return netmanager;
}


- (void)requestDataWithUrlString:(NSString *)urlString
{
    _userStop = NO;
//    NSLog(@"~~~~~~~~~~requestDataWithUrlString");
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
//         NSLog(@"AFHttpRequestOperation成功");
         // save Data
         self.downLoadData = operation.responseData;
         // 回调
         [self callBack];
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
//         NSLog(@"AFHttpRequestOperation错误");
         if (!_userStop)
         {
             _failError = error;
             [self callBack];
         }
    }];
    if (queue == nil)
    {
        queue = [[NSOperationQueue alloc] init];
    }
    [queue addOperation:operation];
}

- (void)cancelRequestOperation
{
    _userStop = YES;
    [queue cancelAllOperations];
}

- (void)callBack
{
    if (_delegate && [self.delegate respondsToSelector:self.action])
    {
        [_delegate performSelector:_action withObject:self afterDelay:NO];
    }
}

@end
