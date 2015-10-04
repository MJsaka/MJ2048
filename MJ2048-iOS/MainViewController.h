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
#import "BlockAttr.h"
#import "BlockAreaView.h"


@interface MainViewController : UIViewController

@property (assign,nonatomic) NSInteger blockNum;
@property (assign,nonatomic) NSInteger margin;
@property (assign,nonatomic) NSInteger width;

@property (strong,nonatomic) MacBlockAttribute *attr;
@property (strong,nonatomic) BlockAreaView *blockAreaView;
@property (strong,nonatomic) NSArray *block;

@property (weak,nonatomic) IBOutlet UILabel *power;
@property (weak,nonatomic) IBOutlet UILabel *bestTitle;
@property (weak,nonatomic) IBOutlet UILabel *best;
@property (weak,nonatomic) IBOutlet UILabel *scoreTitle;
@property (weak,nonatomic) IBOutlet UILabel *score;

@property (weak,nonatomic) AppDelegate *appDelegate;
@property (weak,nonatomic) GameData *gameData;

-(void)newGame;
@end
