    //
//  InterfaceControl.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "InterfaceControl.h"
#import "BlockLayer.h"
#import "BlockAttribute.h"
#import <QuartzCore/QuartzCore.h>

@implementation InterfaceControl{
    BlockLayer *block[4][4];
    NSInteger moveRelativeI[4][4];
    NSInteger moveRelativeJ[4][4];
    Boolean mergeBlock[4][4];
    Boolean generateBlock[4][4];
}


- (IBAction)newGame:(id)sender{
    [gameData newGame];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            moveRelativeI[i][j] = 0;
            moveRelativeJ[i][j] = 0;
            mergeBlock[i][j] = false;
            generateBlock[i][j] = false;
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            [block[i][j] setNeedsDisplay];
            [block[i][j] setHidden:NO];
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
                    [block[i][j] setHidden:YES];
                }
            }
        }
        [gameView setNeedsDisplay:YES];
    }
}

- (void)startMoveAnimation{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            if (moveRelativeI[i][j] != 0 || moveRelativeJ[i][j] != 0) {
                CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                moveAnimation.duration = 0.25;
                moveAnimation.autoreverses = NO;
                moveAnimation.repeatCount = 0;
                moveAnimation.removedOnCompletion = NO;
                moveAnimation.fillMode = kCAFillModeForwards;
                moveAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
                moveAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, moveRelativeI[i][j]*138 , moveRelativeJ[i][j] * 138, 0)];
                [block[i][j] addAnimation:moveAnimation forKey:@"transform"];
            }
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:0.24 target:self selector:@selector(blockRefresh) userInfo:nil repeats:NO];
}
    
- (void)startMoveAnimationAfterMerge{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            if (moveRelativeI[i][j] != 0 || moveRelativeJ[i][j] != 0) {
                CABasicAnimation *moveAnimationAfterMerge = [CABasicAnimation animationWithKeyPath:@"transform"];
                moveAnimationAfterMerge.duration = 0.25;
                moveAnimationAfterMerge.autoreverses = NO;
                moveAnimationAfterMerge.repeatCount = 0;
                moveAnimationAfterMerge.removedOnCompletion = NO;
                moveAnimationAfterMerge.fillMode = kCAFillModeForwards;
                moveAnimationAfterMerge.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
                moveAnimationAfterMerge.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, moveRelativeI[i][j]*138 , moveRelativeJ[i][j] * 138, 0)];
                [block[i][j] addAnimation:moveAnimationAfterMerge forKey:@"transform"];
            }
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:0.24 target:self selector:@selector(blockRefresh) userInfo:nil repeats:NO];
}
- (void)startMergeAnimation{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            if (mergeBlock[i][j]) {
                CABasicAnimation *mergeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                mergeAnimation.duration = 0.2;
                mergeAnimation.autoreverses = NO;
                mergeAnimation.repeatCount = 0;
                mergeAnimation.removedOnCompletion = NO;
                mergeAnimation.fillMode = kCAFillModeBackwards;
                mergeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
                mergeAnimation.toValue = [NSNumber numberWithFloat:1.2];
                [block[i][j] addAnimation:mergeAnimation forKey:@"transform"];
                mergeBlock[i][j] = false;
            }
            if (generateBlock[i][j]) {
                CABasicAnimation *generateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                generateAnimation.duration = 0.2;
                generateAnimation.autoreverses = NO;
                generateAnimation.repeatCount = 0;
                generateAnimation.removedOnCompletion = NO;
                generateAnimation.fillMode = kCAFillModeBackwards;
                generateAnimation.fromValue = [NSNumber numberWithFloat:0.5];
                generateAnimation.toValue = [NSNumber numberWithFloat:1.0];
                [block[i][j] addAnimation:generateAnimation forKey:@"transform"];
                generateBlock[i][j] = false;
            }
        }
    }
//    [NSTimer scheduledTimerWithTimeInterval:0.24 target:self selector:@selector(blockRefresh) userInfo:nil repeats:NO];
}
-(void)blockRefresh{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            moveRelativeI[i][j] = 0;
            moveRelativeJ[i][j] = 0;
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            [block[i][j] setNeedsDisplay];
            [block[i][j] removeAllAnimations];
        }
    }
}
- (void)addMoveAnimationFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ{
    moveRelativeI[fromI][fromJ] = toI - fromI;
    moveRelativeJ[fromI][fromJ] = toJ -fromJ;
}

- (void)addMoveAnimationAfterMergeFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ{
    moveRelativeI[fromI][fromJ] = toI - fromI;
    moveRelativeJ[fromI][fromJ] = toJ -fromJ;
}

- (void)addMergeAnimationForI:(NSInteger)forI forJ:(NSInteger)forJ{
    mergeBlock[forI][forJ] = true;
}
- (void)addGenerateAnimationForI:(NSInteger)forI forJ:(NSInteger)forJ{
    generateBlock[forI][forJ] = true;
}
- (void)awakeFromNib{

    gameView.currentScore = [gameData currentScore];
    gameView.highScore = [gameData highScore];
    gameView.topPower = [gameData topPower];
    gameView.isDeath = [gameData isDeath];
    
    BlockAttribute *attr = [[BlockAttribute alloc]init];
    
    [gameView setWantsLayer:YES];
    
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            block[i][j] = [BlockLayer layer];
            [[gameView layer] addSublayer:block[i][j]];
            
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            block[i][j].posI = i;
            block[i][j].posJ = j;
            block[i][j].blockAttr = attr;
            
            [block[i][j] setBounds:NSMakeRect(0, 0, 128, 128)];
            [block[i][j] setPosition:CGPointMake(306 + i * 138, 94 + j * 138)];
            [block[i][j] setAnchorPoint:NSMakePoint(0.5, 0.5)];
            [block[i][j] setNeedsDisplay];
            
            moveRelativeI[i][j] = 0;
            moveRelativeJ[i][j] = 0;
            mergeBlock[i][j] = false;
            generateBlock[i][j] = false;
        }
    }
}
@end
