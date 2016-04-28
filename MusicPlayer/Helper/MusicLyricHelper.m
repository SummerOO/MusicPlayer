//
//  MusicLyricHelper.m
//  音乐播放器
//
//  Created by lanou3g on 15/10/20.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import "MusicLyricHelper.h"
#import "lyricModel.h"
#import <UIKit/UIKit.h>
@interface MusicLyricHelper ()
//存放所有歌词对象的数组
@property (nonatomic, strong) NSMutableArray *allLyricModelArray;

@end

@implementation MusicLyricHelper


#pragma mark--获取单例对象  获取歌词工具对象
+ (instancetype)sharedMusicLyricHelper{
    
    static MusicLyricHelper *helper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MusicLyricHelper alloc] init];
    });
    
    return helper;
    
}
#pragma mark----解析歌词 并封装成model对象
- (void)parseLyricWithLyricString:(NSString *)lyricString{
    
    //当切换新歌的时候,将数组中原来的歌词清空
    [self.allLyricModelArray removeAllObjects];
    
//    NSLog(@"%@",lyricString);
    NSArray *array = [lyricString componentsSeparatedByString:@"\n"];
//    NSLog(@"%@",array);
    
    for (NSString *string in array) {
        NSArray *timeStrAndLyricStr =  [string componentsSeparatedByString:@"]"];
//        NSLog(@"%@",timeStrAndLyricStr);
        
        if ([timeStrAndLyricStr.firstObject length] == 0) {
            continue;
        }
        
        NSString *str =  timeStrAndLyricStr.firstObject;
        NSString *timeStr = [str substringFromIndex:1];
        
        NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
//        NSLog(@"%@",timeArray);
        
        //计算秒数
        NSTimeInterval seconds = [timeArray.firstObject doubleValue] * 60 + [timeArray.lastObject doubleValue];
        //每一句歌词
        NSString *lyricString = [timeStrAndLyricStr lastObject];
        //封装model对象
        lyricModel *model = [[lyricModel alloc] initWithTime:seconds lyricString:lyricString];
        
        [self.allLyricModelArray addObject:model];
        
        
    }
    
    
    
}

//使用懒加载创建并初始化数组
- (NSMutableArray *)allLyricModelArray{
    
    if (! _allLyricModelArray) {
        _allLyricModelArray = [NSMutableArray array];
    }
    return _allLyricModelArray;
    
}

- (NSInteger)count{
    return _allLyricModelArray.count;
}

#pragma mark----根据传过来的indexPath获取model对象
- (lyricModel *)lyricModelWithIndexPath:(NSIndexPath *)indexpath{
    
    return _allLyricModelArray[indexpath.row];
    
}

#pragma mark----根据时间获取下标
- (NSInteger)getIndexWithTime:(NSTimeInterval)time{

    
    NSInteger index = 0;
    for (int i = 0; i < _allLyricModelArray.count; i++) {
        
        lyricModel *model = _allLyricModelArray[i];
        
        if (model.time > time) {
            //?
            index = (i-1 >0) ? i-1:0;
            break;
        }
    }
    return index;
    
}

@end
