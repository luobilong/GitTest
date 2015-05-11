//
//  HeaderFile.h
//  labonline
//
//  Created by cocim01 on 15/3/25.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#ifndef labonline_HeaderFile_h
#define labonline_HeaderFile_h

#import "DeviceManager.h"
#import "NavigationButton.h"

#define kScreenWidth  [DeviceManager currentScreenWidth]
#define kScreenHeight  [DeviceManager currentScreenHeight]

typedef enum
{
    MainPage = 0,
    WangQi,
    EJianTong,
    JiShuZhuanLan,
    PersonCenter,
    SettingCenter,
    LogIn,
    Register
}ResourceType;

typedef enum
{
    VidioPath = 0,
    PDFPath,
    DataPath
}PathType;

typedef enum
{
    UserName = 0,
    Telephone,
    EMail
}AlterType;

//#define kUserId @"E3874C4463734AC08E6084F3D09F3D47"
// 技术专栏主页
#define kJSZLUrlString @"http://123.57.155.106:8080/labonline/indexController/queryJszlList.do"
// 技术专栏更多
#define kJSZLMoreUrlString @"http://123.57.155.106:8080/labonline/zzwzController/queryJszlwzList.do?type_id=%@"

// 主页接口 无参数
// 阿里云 暂无e检通数据
//#define kMainUrlString @"http://123.57.155.106:8080/labonline/indexController/queryList.do"
// 153 有数据
#define kMainUrlString @"http://192.168.0.153:8181/labonline/indexController/queryList.do"

// 主页杂志的阅读接口 左侧杂志接口
#define kMainListUrlString @"http://123.57.155.106:8080/labonline/zzwzController/queryList.do"
// 评论界面接口 9185
#define kEvalueationURLString @"http://123.57.155.106:8080/labonline/hyController/queryWzplList.do"
// 提交评论接口 articleid userid text
#define kCommitEvaluationUrl @"http://123.57.155.106:8080/labonline/hyController/insertPl.do"
// 我的评论 参数 userid
#define kMyEvaluationUrl @"http://123.57.155.106:8080/labonline/hyController/queryPlList.do?userid=%@"

// 收藏接口 参数userid  articleid
//#define kCollectionUrl @"http://123.57.155.106:8080/labonline/hyController/insertWdsc.do"
#define kCollectionUrl @"http://192.168.0.153:8181/labonline/hyController/insertWdsc.do"

// 我的收藏接口 参数 userid http://192.168.0.153:8181
//#define kMyCollectionUrlString @"http://123.57.155.106:8080/labonline/hyController/queryWdscList.do"
#define kMyCollectionUrlString @"http://192.168.0.153:8181/labonline/hyController/queryWdscList.do"

// 删除收藏 参数userid  articleid
//#define kDeleteCollectionUrl @"http://123.57.155.106:8080/labonline/hyController/deleteWdsc.do"
#define kDeleteCollectionUrl @"http://192.168.0.153:8181/labonline/hyController/deleteWdsc.do"

// 修改昵称 参数 userid screenname
#define kAlterUserNameURL @"http://123.57.155.106:8080/labonline/hyController/updateNc.do"
// 修改电话 参数 userid tel
#define kAlterTelephoneURL @"http://123.57.155.106:8080/labonline/hyController/updateSjh.do"
// 修改邮箱 参数 userid email
#define kAlterEmailURL @"http://123.57.155.106:8080/labonline/hyController/updateYx.do"
// 修改头像 userid  usericon 字符串
#define kCommitImageUrl @"http://123.57.155.106:8080/labonline/hyController/updateTx.do"
// 增加阅读数
#define kAddReadCountsUrl @"http://123.57.155.106:8080/labonline/zzwzController/updateYdl.do?articleid=%@"

// 搜索展示标签接口
#define kSearchLableUrl @"http://123.57.155.106:8080/labonline/zzbqController/queryBqList.do"
// 搜索接口 参数 labelid  label
#define kSearchUrl @"http://123.57.155.106:8080/labonline/zzwzController/querySearchList.do"

// 系统升级
#define kSysUpdataUrl @"http://123.57.155.106:8080/labonline/hyController/queryBbList.do"
// 用户反馈
#define kUserCallBackUrl @"http://123.57.155.106:8080/labonline/hyController/insertFk.do"
// e检通产品分类接口 http://192.168.0.153:8181
#define kEJTCateUrl @"http://192.168.0.153:8181/labonline/ejtController/queryCpflList.do?versionCode=0"
// e检通产品列表接口 参数 classifyid
#define kEJTProductListUrl @"http://192.168.0.153:8181/labonline/ejtController/queryCpList.do"
// e检通增加阅读数
#define kAddProductReadCountsUrl @"http://192.168.0.153:8181/labonline/ejtController/updateLll.do?productid=%@"
// e检通产品收藏 参数 productid userid
#define kProductCollectionUrl @"http://192.168.0.153:8181/labonline/ejtController/insertWdsc.do"
// 阿里云  http://123.57.155.106:8080
//#define kProductCollectionUrl @"http://123.57.155.106:8080/labonline/ejtController/insertWdsc.do"


#define kOneFontSize 13
#define kTwoFontSize 12
#define kThreeFontSize 11
#define kFourFontSize 10
// 取消输出
//#define NSLog(...) {}

#endif
