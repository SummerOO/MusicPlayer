//
//  MusicLyricHelper.h
//  音乐播放器
//
//  Created by zhang on 15/10/20.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lyricModel.h"
@interface MusicLyricHelper : NSObject

#pragma mark--获取单例对象  获取歌词工具对象
+ (instancetype)sharedMusicLyricHelper;
#pragma mark----解析歌词 并封装成model对象
- (void)parseLyricWithLyricString:(NSString *)lyricString;

//获取model对象个数 
@property (nonatomic, assign) NSInteger count;

#pragma mark----根据传过来的indexPath获取model对象
- (lyricModel *)lyricModelWithIndexPath:(NSIndexPath *)indexpath;

#pragma mark----根据时间获取下标
- (NSInteger)getIndexWithTime:(NSTimeInterval)time;

@end
