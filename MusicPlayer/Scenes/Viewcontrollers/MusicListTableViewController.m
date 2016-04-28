//
//  MusicListTableViewController.m
//  音乐播放器
//
//  Created by zhang on 15/10/15.
//  Copyright (c) 2015年 zr. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "Urls.h"
#import "MusicModel.h"
#import "MusicListCell.h"
#import "MusicDataHelper.h"
#import "MusicPlayerViewController.h"

#define kMusicDataHelper [MusicDataHelper shareMusicDataHelper]

//#define kRandom()%

@interface MusicListTableViewController ()

- (IBAction)didClickPlayingBarButton:(UIBarButtonItem *)sender;


@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123.jpg"]];
    imageView.frame = [[self view] bounds];
    self.tableView.backgroundView = imageView;
    
    __weak typeof(self) pSelf = self;
    //网络请求,封装model
    [kMusicDataHelper requestAllMusicModelsWithURLString:kMusicListUrl didFinsh:^(NSMutableArray *array) {
       
        [pSelf.tableView reloadData];
        
    }];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return _allMusicModelArray.count;
    return [kMusicDataHelper countOfAllMusicModels];

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicCell" forIndexPath:indexPath];
   
//    UIImageView *bacgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2016"]];
//    
//    cell.backgroundView = bacgImage;
//    cell.backgroundColor = [UIColor clearColor];
//
//    
    

    
//    cell.backgroundColor = [UIColor colorWithRed:98.82 green:-12.55 blue:33.63 alpha:0.1];
    //根据indexPath获取musicModel对象
//    MusicModel *model = self.allMusicModelArray[indexPath.row];
    
//    cell.textLabel.text = model.singer;
    
//    cell.music = model;

    cell.music = [kMusicDataHelper getMusicModelWithIndexPath:indexPath];
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MusicPlayerViewController *playVC = [MusicPlayerViewController sharedMusicPlayerVC];
    
    playVC.index = indexPath.row;
    
    [self.navigationController showViewController:playVC sender:self];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    MusicPlayerViewController *playVC = segue.sourceViewController;
    
}


- (IBAction)didClickPlayingBarButton:(UIBarButtonItem *)sender {
    
    MusicPlayerViewController *playVC = [MusicPlayerViewController sharedMusicPlayerVC];
    [self.navigationController showViewController:playVC sender:self];
    
}
@end
