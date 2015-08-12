//
//  VidioView.m
//  labonline
//
//  Created by cocim01 on 15/3/30.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "VidioView.h"

@implementation VidioView


//调用self.layer 会自动触发此方法，重写此方法，保证给到view的是AVPlayerLayer,而不是普通的CALayer
+(Class)layerClass
{
    return [AVPlayerLayer class];
}

//将视频播放器，传给View
- (void)setVideoViewWithPlayer:(AVPlayer *)player{
    //AVPlayerLayer 视频播放器进行视频播放对应的层
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    //将播放器赋值给层，视频播放的画面会通过播放器渲染到view的层上
    [playerLayer setPlayer:player];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
