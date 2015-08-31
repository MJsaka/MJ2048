//
//  InterfaceControl.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "InterfaceControl.h"
#import "BlockView.h"
#import "BlockAttribute.h"
#import <QuartzCore/QuartzCore.h>

@implementation InterfaceControl{
    NSMutableArray *moveAnimationArray;
    NSMutableArray *mergeAnimationArray;
    NSMutableArray *generateAnimationArray;
    BlockView *block[4][4];
}


- (IBAction)newGame:(id)sender{
    [gameData newGame];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            block[i][j].alphaValue = 1.0 ;
            [block[i][j] setNeedsDisplay:YES];
        }
    }
    gameView.currentScore = [gameData currentScore];
    gameView.highScore = [gameData highScore];
    gameView.topPower = [gameData topPower];
    gameView.isDeath = [gameData isDeath];
    [gameView setNeedsDisplay:YES];
}

- (void)keyboardControl:(dirEnumType)dir{
    if([gameData move:dir sender:self]){
        //绘制Block
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                block[i][j].data = [gameData dataAtRow:i col:j];
                block[i][j].power = [gameData powerAtRow:i col:j];
                [block[i][j] setNeedsDisplay:YES];
            }
        }
        gameView.currentScore = [gameData currentScore];
        if ([gameData isDeath]) {
            gameView.highScore = [gameData highScore];
            gameView.topPower = [gameData topPower];
            gameView.isDeath = [gameData isDeath];
            gameView.isNewScore = [gameData isNewScoreRecord];
            gameView.isNewPower = [gameData isNewPowerRecord];
            //隐藏Block
            for (int i = 0; i < 4; ++i) {
                for (int j = 0; j < 4; ++j) {
                    block[i][j].data = [gameData dataAtRow:i col:j];
                    block[i][j].power = [gameData powerAtRow:i col:j];
                    block[i][j].alphaValue = 0 ;
                }
            }
        }
        [gameView setNeedsDisplay:YES];
    }
}

- (void)startAnimation{
    NSViewAnimation *mergeAnimation = [[NSViewAnimation alloc] initWithViewAnimations:mergeAnimationArray];
    mergeAnimation.delegate = nil;
    mergeAnimation.duration = 1;
    [mergeAnimation setAnimationBlockingMode:NSAnimationNonblocking];
    [mergeAnimation startAnimation];
    mergeAnimationArray = [NSMutableArray array];
    
    double delayInSeconds = mergeAnimation.duration ;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [gameView setNeedsDisplay:YES];
        //        for (int i = 0; i < 4; ++i) {
        //            for (int j = 0; j < 4; ++j) {
        //                block[i][j].data = [gameData dataAtRow:i col:j];
        //                block[i][j].power = [gameData powerAtRow:i col:j];
        //                [block[i][j] setNeedsDisplay:YES];
        //            }
        //        }
        NSViewAnimation *moveAnimation = [[NSViewAnimation alloc] initWithViewAnimations:moveAnimationArray];
        moveAnimation.delegate = nil;
        moveAnimation.duration = 1;
        [moveAnimation setAnimationBlockingMode:NSAnimationNonblocking];
        [moveAnimation startAnimation];
        moveAnimationArray = [NSMutableArray array];
        
        double delayInSeconds = moveAnimation.duration ;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [gameView setNeedsDisplay:YES];
            for (int i = 0; i < 4; ++i) {
                for (int j = 0; j < 4; ++j) {
                    block[i][j].data = [gameData dataAtRow:i col:j];
                    block[i][j].power = [gameData powerAtRow:i col:j];
                    [block[i][j] setNeedsDisplay:YES];
                }
            }
        });
        
    });
    
    
}
- (void)addMoveAnimationFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ{
    
    id animationTarget = block[fromI][fromJ];
    id toTarget = block[toI][toJ];
    
    NSRect startFrame = [animationTarget frame];
    NSRect endFrame = [toTarget frame];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                animationTarget,NSViewAnimationTargetKey,
                                NSViewAnimationFadeInEffect,NSViewAnimationEffectKey,
                                [NSValue valueWithRect:startFrame],NSViewAnimationStartFrameKey,
                                [NSValue valueWithRect:endFrame],NSViewAnimationEndFrameKey, nil];
    [moveAnimationArray addObject:dictionary];
}

- (void)addMergeAnimationFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ{
    
    id animationTarget = block[fromI][fromJ];
    id toTarget = block[toI][toJ];
    
    NSRect startFrame = [animationTarget frame];
    NSRect endFrame = [toTarget frame];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                animationTarget,NSViewAnimationTargetKey,
                                NSViewAnimationFadeInEffect,NSViewAnimationEffectKey,
                                [NSValue valueWithRect:startFrame],NSViewAnimationStartFrameKey,
                                [NSValue valueWithRect:endFrame],NSViewAnimationEndFrameKey, nil];
    [mergeAnimationArray addObject:dictionary];
}
- (void)addGenerateAnimationForI:(NSInteger)i forj:(NSInteger)j{
    
}
- (void)awakeFromNib{
    
    moveAnimationArray = [NSMutableArray array];
    mergeAnimationArray = [NSMutableArray array];
    generateAnimationArray = [NSMutableArray array];
    

    gameView.currentScore = [gameData currentScore];
    gameView.highScore = [gameData highScore];
    gameView.topPower = [gameData topPower];
    gameView.isDeath = [gameData isDeath];
    BlockAttribute *attr = [[BlockAttribute alloc]init];
    
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            block[i][j] = [[BlockView alloc] init];
            [gameView addSubview:block[i][j]];
            [block[i][j] setFrame:NSMakeRect(242 + i * 138, 30 + j * 138, 128, 128)];
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            block[i][j].i = i;
            block[i][j].j = j;
            block[i][j].blockAttr = attr;
            [block[i][j].layer setAnchorPoint:NSMakePoint(0, 0)];
        }
    }
}
@end
