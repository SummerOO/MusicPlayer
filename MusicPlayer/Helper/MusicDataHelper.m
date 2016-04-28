//
//  MusicDataHelper.m
//  音乐播放器
//
//  Created by zhang on 15/10/16.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import "MusicDataHelper.h"
#import "MusicModel.h"
#import <UIKit/UIKit.h>
//延展
@interface MusicDataHelper ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MusicDataHelper

+ (instancetype)shareMusicDataHelper{
    
    static MusicDataHelper *helper = nil;
    
    //这个任务只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [[MusicDataHelper alloc] init];
        
    });
    
    return helper;
    
}

#pragma mark----- 请求数据,并封装model对象
- (void)requestAllMusicModelsWithURLString:(NSString *)urlString didFinsh:(BLOCK)result{
    
    //网络请求,封装model
    
    //1.网络请求
    
    //防止block块循环引用
    __weak MusicDataHelper *dataHelper = self;
    
    //创建串行队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //同步请求数据
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSArray *array = [NSArray arrayWithContentsOfURL:url];
        
//        NSLog(@"%@",array);
        
        dataHelper.dataArray = [NSMutableArray array];
        
        //遍历数组,将有效信息封装成model对象
        for (NSDictionary *dic in array) {
            //使用KVC封装model对象
            MusicModel *model = [[MusicModel alloc] init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [dataHelper.dataArray addObject:model];
            
            
        }
//        NSLog(@"%@",_dataArray);
        //刷新表视图由主线程来做
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //block调用
            
            result(dataHelper.dataArray);
            
            
        });
        
        
        
    });
    
    

    
    
}

#pragma mark-----获取model对象的个数
- (NSInteger)countOfAllMusicModels{
    
    return self.dataArray.count;
    
}

#pragma mark---根据indexPath获取数组中的某个model对象
- (MusicModel *)getMusicModelWithIndexPath:(NSIndexPath *)index{
    
    return self.dataArray[index.row];
}

@end
