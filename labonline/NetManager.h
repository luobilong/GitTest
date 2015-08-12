//
//  NetManager.h
//  labonline
//
//  Created by cocim01 on 15/4/10.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject
- (void)requestDataWithUrlString:(NSString *)urlString;
@property (nonatomic,strong) NSData *downLoadData;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) SEL action;
@property (nonatomic,strong) NSError *failError;

+ (NetManager*)getShareManager;
- (void)cancelRequestOperation;

@end
