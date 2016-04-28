//
//  lyricModel.m
//  音乐播放器
//
//  Created by zhang on 15/10/20.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import "lyricModel.h"

@implementation lyricModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
    
}

//自定义初始化方法
- (instancetype)initWithTime:(NSTimeInterval)time lyricString:(NSString *)lyricString{
    
    self = [super init];
    if (self) {
        
        self.lyricString = lyricString;
        self.time = time;
    }
    return self;
    
}


@end
