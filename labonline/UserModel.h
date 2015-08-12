//
//  UserModel.h
//  labonline
//
//  Created by 引领科技 on 15/4/9.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *icon;


@end
