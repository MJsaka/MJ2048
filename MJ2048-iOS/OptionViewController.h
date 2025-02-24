//
//  OptionViewController.h
//  MJ2048
//
//  Created by MJsaka on 15/10/2.
//  Copyright © 2015年 MJsaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "GameData.h"
#import "AppDelegate.h"

@interface OptionViewController : UIViewController

@property (assign,nonatomic) double soundLevel;
@property (assign,nonatomic) double musicLevel;
@property (assign,nonatomic) NSInteger currentBlockNum;

@property (weak) IBOutlet UISlider* soundSlider;
@property (weak) IBOutlet UISlider* musicSlider;
@property (weak) IBOutlet UISlider* blockNumSlider;

@property (weak,nonatomic) AppDelegate* appDelegate;
@property (weak,nonatomic) MainViewController* mainViewController;
@end
