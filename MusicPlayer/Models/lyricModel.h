//
//  lyricModel.h
//  音乐播放器
//
//  Created by lanou3g on 15/10/20.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lyricModel : NSObject

@property (nonatomic, assign) NSTimeInterval time;

@property (nonatomic, copy) NSString *lyricString;

//自定义初始化方法
- (instancetype)initWithTime:(NSTimeInterval)time
                 lyricString:(NSString *)lyricString;

@end
