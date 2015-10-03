//
//  AppDelegate.h
//  MJ2048-iOS
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameData.h"
#include <AVFoundation/AVFoundation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) GameData* gameData;

@property (strong,nonatomic) AVAudioPlayer *audioPlayer;
@property (strong,nonatomic) AVAudioPlayer *soundPlayer;

@property (assign,nonatomic) double musicLevel;
@property (assign,nonatomic) double soundLevel;

- (void)playMusic;
- (void)stopMusic;
- (void)playSound;
- (void)stopSound;
@end

