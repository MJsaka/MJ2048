//
//  AppDelegate.m
//  MJ2048-iOS
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize gameData;
@synthesize audioPlayer;
@synthesize soundPlayer;
@synthesize soundLevel;
@synthesize musicLevel;

- (void)playMusic{
    NSError *error = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"music" ofType:@"m4a"]] error:&error];
    audioPlayer.delegate = self;
    audioPlayer.volume = musicLevel;
    audioPlayer.numberOfLoops = -1;
    if(error) {
        NSLog(@"%@",[error description]);
    }
    [audioPlayer play];
}

- (void)stopMusic{
    [audioPlayer stop];
}

- (void)playSound{
    NSError *error = nil;
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"m4a"]] error:&error];
    soundPlayer.delegate = self;
    soundPlayer.volume = soundLevel;
    soundPlayer.numberOfLoops = 0;
    if(error) {
        NSLog(@"%@",[error description]);
    }
    [soundPlayer play];
}

- (void)stopSound{
    [soundPlayer stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放完成。");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"播放错误发生: %@", [error localizedDescription]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    gameData = [[GameData alloc]init];
    musicLevel = [[NSUserDefaults standardUserDefaults] doubleForKey:@"musicLevel"];
    soundLevel = [[NSUserDefaults standardUserDefaults] doubleForKey:@"musicLevel"];
    if (musicLevel > 0) {
        [self playMusic];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [gameData saveNSUserDefaults];
    [[NSUserDefaults standardUserDefaults] setDouble:musicLevel forKey:@"musicLevel"];
    [[NSUserDefaults standardUserDefaults] setDouble:soundLevel forKey:@"soundLevel"];
}

@end
