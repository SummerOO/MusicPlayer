//
//  MusicDataHelper.h
//  音乐播放器
//
//  Created by lanou3g on 15/10/16.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
//NSMutableArray *  是想要传过去的参数类型
typedef void(^BLOCK)(NSMutableArray *array);

@interface MusicDataHelper : NSObject

//instancetype不可以作为参数类型,id可以

#pragma mark------ 获取单例对象
//当多个页面需要相同资源的适合用单例 将多个资源放在一个类里
+ (instancetype)shareMusicDataHelper;
#pragma mark----- 请求数据,并封装model对象
- (void)requestAllMusicModelsWithURLString:(NSString *)urlString
                                  didFinsh:(BLOCK)result;

#pragma mark-----获取model对象的个数
- (NSInteger)countOfAllMusicModels;


#pragma mark---根据indexPath获取数组中的某个model对象
- (MusicModel *)getMusicModelWithIndexPath:(NSIndexPath *)index;

@end
