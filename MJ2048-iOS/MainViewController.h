//
//  MainViewController.h
//  MJ2048
//
//  Created by MJsaka on 15/9/24.
//  Copyright © 2015年 MJsaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GameData.h"
#import "BlockAreaView.h"

@interface BlockAttributeIOS : NSObject

- (UIColor*)colorOfPower:(NSInteger)power;

@end

@interface MainViewController : UIViewController

@property (assign,nonatomic) NSInteger blockNum;
@property (assign,nonatomic) NSInteger margin;
@property (assign,nonatomic) NSInteger width;

@property (strong,nonatomic) BlockAttributeIOS *attr;
@property (strong,nonatomic) BlockAreaView *blockAreaView;
@property (strong,nonatomic) NSArray *block;

@property (weak,nonatomic) IBOutlet UILabel *power;
@property (weak,nonatomic) IBOutlet UILabel *bestTitle;
@property (weak,nonatomic) IBOutlet UILabel *best;
@property (weak,nonatomic) IBOutlet UILabel *scoreTitle;
@property (weak,nonatomic) IBOutlet UILabel *score;

@property (strong,nonatomic) UILabel *gameOverLabel;
@property (strong,nonatomic) UIButton *retryButton;
@property (strong,nonatomic) UIButton *shareToWeiXinButton;

@property (weak,nonatomic) AppDelegate *appDelegate;
@property (weak,nonatomic) GameData *gameData;

-(void)newGame;
- (void)changeBlockNum:(NSInteger)newBlockNum;
@end
