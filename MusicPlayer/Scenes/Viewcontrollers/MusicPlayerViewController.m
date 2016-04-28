//
//  MusicPlayerViewController.m
//  音乐播放器
//
//  Created by zhang on 15/10/16.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "MusicDataHelper.h"
#import "MusicModel.h"
#import "MusicPlayHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "MusicLyricHelper.h"
#define kMusicDataHelper [MusicDataHelper shareMusicDataHelper]

#define kMusicPlayHelper [MusicPlayHelper sharedMusicPlayHelper]

#define kMusicLyricHelper [MusicLyricHelper sharedMusicLyricHelper]

@interface MusicPlayerViewController ()<MusicPlayHelperDelegate,UITableViewDataSource,UITableViewDelegate>

- (IBAction)didClickPreviousButton:(id)sender;
- (IBAction)didClickPalyOrPauseButton:(id)sender;

- (IBAction)didClickNextButton:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *senderButton;


@property (strong, nonatomic) IBOutlet UIImageView *songImageView;

@property (strong, nonatomic) IBOutlet UITableView *lyricTableView;

@property (strong, nonatomic) IBOutlet UISlider *timeSlider;
- (IBAction)didClickTimeSlider:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
- (IBAction)didClickVolumeSlider:(UISlider *)sender;

@property (nonatomic, assign) NSInteger currentIndex;//临时存储上一个(旧的)音乐下标

@end

@implementation MusicPlayerViewController

#pragma mark--------创建单例对象,获取播放页面的视图控制器
+ (instancetype)sharedMusicPlayerVC{
    
    static MusicPlayerViewController *playVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        //获取工程当中的main.storyboard
        UIStoryboard *mainStoryBoard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        playVC =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"playVC"];
    });
    
    return playVC;
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_index == _currentIndex) {
        return;
    }
    
    if ([kMusicPlayHelper isPlaying] == YES && _index == _currentIndex) {
        //        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [_senderButton setImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
        [kMusicPlayHelper pause];
    }else{
        //        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [_senderButton setImage:[UIImage imageNamed:@"iconfont-iconbofangzanting"] forState:UIControlStateNormal];
        [kMusicPlayHelper play];
    }
    
    [self prepareForPlaying];
    
    
}

- (void)prepareForPlaying{
    
    _currentIndex = _index;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    
    //根据indexpath获取要播放那首歌曲对象
    MusicModel *model =  [kMusicDataHelper getMusicModelWithIndexPath:indexPath];
//    NSLog(@"%@",model.duration);
    
    //设置timeSlider 的最大值
    self.timeSlider.maximumValue = [model.duration floatValue]/1000;
    //设置currentTimeLabel 和remainTimeLabel的起始值
    self.remainTimeLabel.text = [self setFormatWithTime:[model.duration floatValue]/ 1000];
    self.currentTimeLabel.text = [self setFormatWithTime:0.0];
    [self.songImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.navigationItem.title = model.name;
#pragma mark --- 准备播放
    
    [kMusicPlayHelper preparePlayingMusicWithUrlString:model.mp3Url];
   
    
#pragma mark--- 准备歌词
//    NSLog(@"________%@",model.lyric);
    [kMusicLyricHelper parseLyricWithLyricString:model.lyric];
    
    //刷新歌词表视图
    [self.lyricTableView reloadData];
}

- (NSString *)setFormatWithTime:(NSTimeInterval)time{
    
    //分钟
    int minute = time / 60;
    //秒数
    int seconds = (int)time % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minute,seconds];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //当使用storyboard,绘制圆之前,强迫让布局提前执
    [self.view layoutIfNeeded];
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"iconfont-iconfontshuangyuanduihao1"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"iconfont-icoyuan"] forState:UIControlStateNormal];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.navigationController.navigationBar.translucent = NO;
    kMusicPlayHelper.delegate = self;
    
    //将songImageView设置圆角
    self.songImageView.layer.masksToBounds = YES;
    self.songImageView.layer.cornerRadius = CGRectGetHeight(_songImageView.frame) /2;
    
    _currentIndex = -1;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(zhuanzhuan) userInfo:nil repeats:YES];
    
    self.lyricTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    
    //设置tableView代理
    self.lyricTableView.dataSource = self;
    self.lyricTableView.delegate = self;
    
}

- (void)zhuanzhuan{
    
    __weak typeof(self) pSelf = self;
    [UIView animateWithDuration:0.1f animations:^{
       
        pSelf.songImageView.transform = CGAffineTransformRotate(pSelf.songImageView.transform, M_PI / 100);
        
    }];
    
}

- (void)dealloc{
    
    kMusicPlayHelper.delegate = nil;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}



//上一首
- (IBAction)didClickPreviousButton:(id)sender {
    
    _index--;
    
    if (_index == -1) {
        _index = [kMusicDataHelper countOfAllMusicModels]- 1;
    }
    
    
    if ([kMusicPlayHelper isPlaying] == YES) {
        //        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [_senderButton setImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
        [kMusicPlayHelper pause];
    }else{
        //        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [_senderButton setImage:[UIImage imageNamed:@"iconfont-iconbofangzanting"] forState:UIControlStateNormal];
        [kMusicPlayHelper play];
    }

    [self prepareForPlaying];
    self.timeSlider.value = 0;
}

- (IBAction)didClickPalyOrPauseButton:(id)sender {
    
    if ([kMusicPlayHelper isPlaying] == YES) {
//        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
        [kMusicPlayHelper pause];
    }else{
//        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"iconfont-iconbofangzanting"] forState:UIControlStateNormal];
        [kMusicPlayHelper play];
    }
}

- (IBAction)didClickNextButton:(id)sender {
    
    
    _index++;
    if (_index == [kMusicDataHelper countOfAllMusicModels]) {
        _index = 0;
    }
    
    if ([kMusicPlayHelper isPlaying] == YES) {
        //        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [_senderButton setImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
        [kMusicPlayHelper pause];
    }else{
        //        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [_senderButton setImage:[UIImage imageNamed:@"iconfont-iconbofangzanting"] forState:UIControlStateNormal];
        [kMusicPlayHelper play];
    }

    [self prepareForPlaying];
    self.timeSlider.value = 0;
}
- (IBAction)didClickTimeSlider:(UISlider *)sender {
    
//    NSLog(@"%f",self.timeSlider.value);
    
    [kMusicPlayHelper seekToPlayWithTime:_timeSlider.value];
    
}
- (IBAction)didClickVolumeSlider:(UISlider *)sender {
    
    kMusicPlayHelper.volume = sender.value;
    
}

#pragma mark---实现MusicPlayerHelperDelegate代理协议
- (void)playingToTime:(NSTimeInterval)time{
    self.timeSlider.value = time;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_index inSection:0];
    //根据indexpath获取要播放那首歌曲对象
    MusicModel *model =  [kMusicDataHelper getMusicModelWithIndexPath:indexPath];
    //设置currentTimeLabel 和remainTimeLabel的起始值
    self.remainTimeLabel.text = [self setFormatWithTime:[model.duration floatValue]/ 1000 - time];
    self.currentTimeLabel.text = [self setFormatWithTime:time];
    
    
    //根据下标显示哪一行的歌词
    
    NSInteger index = [kMusicLyricHelper getIndexWithTime:time];
    //选中哪一行
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:index inSection:0];
    [self.lyricTableView selectRowAtIndexPath:indexPath1 animated:YES scrollPosition:UITableViewScrollPositionMiddle];

}

- (void)playingDidEnd{
    
    [kMusicPlayHelper pause];
    _index++;
    if (_index == [kMusicDataHelper countOfAllMusicModels]) {
        _index = 0;
    }
    [self prepareForPlaying];
    [kMusicPlayHelper play];
    
}
#pragma mark----实现tableview协议中的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //获取了model中数组的个数
    return [kMusicLyricHelper count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lyricCell" forIndexPath:indexPath];
    cell.textLabel.text = [kMusicLyricHelper lyricModelWithIndexPath:indexPath].lyricString;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:183.0/255.0 green:246.0/255.0 blue:179.0/255.0 alpha:1];
    cell.selectedBackgroundView = [[UIView alloc] init];
    
//      [self.lyricTableView reloadData];
    return cell;
}
@end
