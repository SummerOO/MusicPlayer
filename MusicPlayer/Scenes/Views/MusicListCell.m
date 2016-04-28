//
//  MusicListCell.m
//  音乐播放器
//
//  Created by zhang on 15/10/15.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import "MusicListCell.h"
#import "UIImageView+WebCache.h"
@implementation MusicListCell

//重写setter方法,给视图控件赋值

- (void)setMusic:(MusicModel *)music{
    
    self.songNameLabel.text = music.name;
    self.singerNameLabel.text = music.singer;
    [self.songImageView sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:[UIImage imageNamed:@"000"]];
    self.backgroundColor = [UIColor clearColor];
}



@end
