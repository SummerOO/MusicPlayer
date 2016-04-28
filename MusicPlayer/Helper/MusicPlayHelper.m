//
//  MusicPlayHelper.m
//  音乐播放器
//
//  Created by zhang on 15/10/16.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import "MusicPlayHelper.h"
#import <AVFoundation/AVFoundation.h>
@interface MusicPlayHelper ()

@property (nonatomic, strong) AVPlayer *avPlayer;


@property (nonatomic, strong) NSTimer *timer;//定时器,用来将歌曲播放的时间,不断的传给播放列表页面,给timeSlider赋值


@end

@implementation MusicPlayHelper
static NSMutableDictionary *_audioPlayerDict;

#pragma mark --- 获取播放音乐的单例对象

+ (instancetype)sharedMusicPlayHelper{
    
    static MusicPlayHelper *helper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MusicPlayHelper alloc] init];
    });
    
    return helper;
    
}

+ (void)initialize {
    
    //设置音频回话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //类型:播放和录音
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //激活音频回话
    [session setActive:YES error:nil];
}



//使用懒加载创建avPlayer对象
//当用self.  的时候就创建了avPlayer
- (AVPlayer *)avPlayer
{
    
    if ( ! _avPlayer)
    {
        _avPlayer = [[AVPlayer alloc] init];
    }
    return _avPlayer;
}


#pragma mark ---- 根据传过来的mp3Url,来进行播放音乐
- (void)preparePlayingMusicWithUrlString:(NSString *)urlString{
    
    //根据ulrString创建,avplayer 要播放的Item
    
    AVPlayerItem *avPlayItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [self.avPlayer replaceCurrentItemWithPlayerItem:avPlayItem];
    
    //使用kvo观察avplayer有没有准备完毕
    [self.avPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
       
        [self play];
    }
    
}


#pragma mark-- 播放功能

- (void)play{
    
    if (_isPlaying == YES) {
        return;
    }
    
    [self.avPlayer play];
    _isPlaying = YES;
    
    //当定时器在的存在的时候不用开启定时器直接返回
    if (_timer != nil) {
        return;
    }
    
    //当歌曲开始播放时 创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playAction:) userInfo:nil repeats:YES];
    
    
    
}

- (void)playAction:(NSTimer *)sender{

    NSTimeInterval seconds = self.avPlayer.currentTime.value/self.avPlayer.currentTime.timescale;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(playingToTime:)]) {
        [_delegate playingToTime:seconds];
    }
    
}


#pragma mark-- 暂停功能

- (void)pause{
    
    if (_isPlaying == NO) {
        return;
    }
    
    [self.avPlayer pause];
    
    _isPlaying = NO;
    
    //停止定时器
    [self.timer invalidate];
    _timer = nil;
}

#pragma mark----根据指定的时间播放指定的歌曲
//NSTimeInterval 相当于double
- (void)seekToPlayWithTime:(NSTimeInterval)time{
    
    //先暂停
    //公式: value/timescale = seconds
    [self.avPlayer seekToTime:CMTimeMake(time * self.avPlayer.currentTime.timescale, self.avPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {
       
        
        
    }];
    [self.avPlayer seekToTime:CMTimeMake(self.avPlayer.currentTime.timescale * time, _avPlayer.currentTime.timescale)];
    
}

#pragma mark----设置音量,通过重写setter方法
- (void)setVolume:(float)volume{
    
    self.avPlayer.volume = volume;
    
}

#pragma mark--- 使用通知观察当前歌曲有没有播放完毕

- (instancetype)init{
    self = [super init];
    if (self) {
        //通知中心
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    return self;
}

- (void)playDidEnd{
    
    if (_delegate!= nil && [self.delegate respondsToSelector:@selector(playingDidEnd)]) {
        [self.delegate playingDidEnd];
    }
    
}

@end
