//
//  MusicModel.h
//  音乐播放器
//
//  Created by lanou3g on 15/10/15.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
/*
<key>mp3Url</key>
<key>id</key>
<key>name</key>
<key>picUrl</key>
<key>blurPicUrl</key>
<key>album</key>
<key>singer</key>
<key>duration</key>
<key>artists_name</key>
<key>lyric</key>
*/
@property (nonatomic, copy) NSString *mp3Url;//歌曲网址
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;//歌曲名
@property (nonatomic, copy) NSString *picUrl;//图片
@property (nonatomic, copy) NSString *blurPicUrl;//
@property (nonatomic, copy) NSString *album;//
@property (nonatomic, copy) NSString *singer;//歌手名
@property (nonatomic, copy) NSString *duration;//时长
@property (nonatomic, copy) NSString *artists_name;//
@property (nonatomic, copy) NSString *lyric;//歌词


@end
