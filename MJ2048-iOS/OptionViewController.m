//
//  OptionViewController.m
//  MJ2048
//
//  Created by MJsaka on 15/10/2.
//  Copyright © 2015年 MJsaka. All rights reserved.
//

#import "OptionViewController.h"


@interface OptionViewController ()
@property (assign,nonatomic) NSInteger newBlockNum;
@end

@implementation OptionViewController

@synthesize currentBlockNum;
@synthesize musicLevel;
@synthesize soundLevel;
@synthesize soundSlider;
@synthesize musicSlider;
@synthesize blockNumSlider;
@synthesize mainViewController;
@synthesize appDelegate;
@synthesize gameData;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    gameData = appDelegate.gameData;
    // Do any additional setup after loading the view.
    soundLevel = appDelegate.soundLevel;
    soundSlider.value = soundLevel;
    musicLevel = appDelegate.musicLevel;
    musicSlider.value = musicLevel;
    if (!appDelegate.audioPlayer.playing) {
        [appDelegate playMusic];
    }
    currentBlockNum = [gameData blockNum];
    _newBlockNum = currentBlockNum;
    blockNumSlider.value = 0.2*(currentBlockNum-3);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)soundSliderValueChanged:(id)sender{
    appDelegate.soundLevel = soundSlider.value;

}

- (IBAction)musicSliderValueChanged:(id)sender{
    appDelegate.audioPlayer.volume = musicSlider.value;
}

- (IBAction)blockNumSliderValueChanged:(id)sender{
    _newBlockNum =  (int)((blockNumSlider.value + 0.1)/0.2) + 3;
    blockNumSlider.value = 0.2*(_newBlockNum-3);
}

- (IBAction)okClick:(id)sender{
    if (soundLevel != soundSlider.value) {
        appDelegate.soundLevel = soundSlider.value;
    }
    if (musicLevel != musicSlider.value) {
        appDelegate.musicLevel = musicSlider.value;
        if (musicSlider.value == 0) {
            [appDelegate stopMusic];
        }
    }
    if (_newBlockNum != currentBlockNum) {
        [gameData setBlockNum:_newBlockNum];
        [mainViewController viewDidLoad];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
