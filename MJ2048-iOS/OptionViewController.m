//
//  OptionViewController.m
//  MJ2048
//
//  Created by MJsaka on 15/10/2.
//  Copyright © 2015年 MJsaka. All rights reserved.
//

#import "OptionViewController.h"
#import "GameData.h"
#import "AppDelegate.h"

@interface OptionViewController ()
@property (assign,nonatomic) NSInteger newBlockNum;
@end

@implementation OptionViewController

@synthesize currentBlockNum;
@synthesize currentMusic;
@synthesize currentSound;
@synthesize soundSlider;
@synthesize musicSlider;
@synthesize blockNumSlider;
@synthesize mainViewController;
@synthesize gameData;

- (void)viewDidLoad {
    [super viewDidLoad];
    gameData = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).gameData;
    // Do any additional setup after loading the view.
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    currentSound = [userdefaults doubleForKey:@"currentSound"];
    currentMusic = [userdefaults doubleForKey:@"currentMusic"];
    currentBlockNum = [gameData blockNum];
    _newBlockNum = currentBlockNum;
    blockNumSlider.value = 0.2*(currentBlockNum-3);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)blockNumSliderValueChanged:(id)sender{
    _newBlockNum =  (int)((blockNumSlider.value + 0.1)/0.2) + 3;
    blockNumSlider.value = 0.2*(_newBlockNum-3);
}

- (IBAction)okClick:(id)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (currentSound != soundSlider.value) {
        [userDefaults setFloat:soundSlider.value forKey:@"currentSound"];
    }
    if (currentMusic != musicSlider.value) {
        [userDefaults setFloat:musicSlider.value forKey:@"currentMusic"];
    }
    if (_newBlockNum != currentBlockNum) {
        [userDefaults setInteger:_newBlockNum forKey:@"blockNum"];
        [gameData setBlockNum:_newBlockNum];
        mainViewController.isNewGame = true;
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
