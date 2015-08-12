//
//  VidioView.h
//  labonline
//
//  Created by cocim01 on 15/3/30.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>//该类库中封装了系统自带的视频播放器AVPlayer支持MP4、mov avi等基本视频类型，也支持流媒体视频(m3u8)的播放
//将视频的画面，渲染给UIView

@interface VidioView : UIView

//将视频播放器，传给View
- (void)setVideoViewWithPlayer:(AVPlayer *)player;

@end
