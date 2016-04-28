//
//  MusicPlayHelper.h
//  音乐播放器
//
//  Created by lanou3g on 15/10/16.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import <Foundation/Foundation.h>

//声明协议
@protocol MusicPlayHelperDelegate <NSObject>
//正在播放音乐
- (void)playingToTime:(NSTimeInterval)time;

//音乐播放结束
- (void)playingDidEnd;

@end

@interface MusicPlayHelper : NSObject

@property (nonatomic, assign) BOOL isPlaying;//存储播放状态

@property (nonatomic, strong) id<MusicPlayHelperDelegate>delegate;

#pragma mark --- 获取播放音乐的单例对象
+ (instancetype)sharedMusicPlayHelper;

#pragma mark ---- 根据传过来的mp3Url,来进行播放音乐
- (void)preparePlayingMusicWithUrlString:(NSString *)urlString;


#pragma mark-- 播放功能

- (void)play;


#pragma mark-- 暂停功能

- (void)pause;

#pragma mark----根据指定的时间播放指定的歌曲
//NSTimeInterval 相当于double
- (void)seekToPlayWithTime:(NSTimeInterval)time;

#pragma mark -- 设置音量
@property (nonatomic, assign)float volume;

@end
