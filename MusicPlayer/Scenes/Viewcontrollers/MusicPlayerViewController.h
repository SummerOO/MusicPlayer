//
//  MusicPlayerViewController.h
//  音乐播放器
//
//  Created by zhang on 15/10/16.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayerViewController : UIViewController

//接收列表页面传过来的下标
@property (nonatomic, assign) NSInteger index;

#pragma mark--------创建单例对象,获取播放页面的视图控制器
+ (instancetype)sharedMusicPlayerVC;


@end
