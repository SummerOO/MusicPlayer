//
//  MusicListCell.h
//  音乐播放器
//
//  Created by zhang on 15/10/15.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@interface MusicListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *songNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *singerNameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *songImageView;

//用来接收传过来的music对象
@property (nonatomic, strong) MusicModel *music;


@end
