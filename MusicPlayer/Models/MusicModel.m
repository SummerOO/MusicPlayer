//
//  MusicModel.m
//  音乐播放器
//
//  Created by lanou3g on 15/10/15.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    
}

- (NSString *)description
{
    
    return [NSString stringWithFormat:@"%@ %@",self.name,self.singer];
    
}

@end
