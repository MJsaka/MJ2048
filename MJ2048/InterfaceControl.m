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

typedef struct move{
    NSInteger fromI;
    NSInteger fromJ;
    NSInteger toI;
    NSInteger toJ;
    NSInteger i;
    NSInteger j;
}moveType;

@implementation InterfaceControl{
    BlockLayer *block[4][4];
    moveType *moveTable[4][4];
    Boolean mergeBlock[4][4];
    Boolean generateBlock[4][4];
}


- (IBAction)newGame:(id)sender{
    [gameData newGame];
    gameView.currentScore = [gameData currentScore];
    gameView.highScore = [gameData highScore];
    gameView.topPower = [gameData topPower];
    gameView.isDeath = [gameData isDeath];
    [gameView setNeedsDisplay:YES];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            moveTable[i][j]->fromI = -1;
            moveTable[i][j]->fromJ = -1;
            moveTable[i][j]->toI = -1;
            moveTable[i][j]->toJ = -1;
            moveTable[i][j]->i = i;
            moveTable[i][j]->j = j;
            mergeBlock[i][j] = false;
            generateBlock[i][j] = false;
            
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            [block[i][j] setNeedsDisplay];
            [block[i][j] setHidden:NO];
        }
    }
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
                    [block[i][j] setOpacity:0];
                }
            }
        }
        [gameView setNeedsDisplay:YES];
        [self startMoveAnimation];
    }
}

- (void)startMoveAnimation{
    Boolean hasMove = false;
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            NSInteger toI = moveTable[i][j]->toI;
            NSInteger toJ = moveTable[i][j]->toJ;
            if (toI != -1 || toJ != -1) {
                CGPoint toPoint = CGPointMake(306 + toI * 138, 94 + toJ * 138);
                [CATransaction begin];
                [CATransaction setValue:[NSNumber numberWithFloat:0.3f] forKey: kCATransactionAnimationDuration];
                [block[i][j] setPosition:toPoint];
                [CATransaction commit];
                hasMove = true;
            }
        }
    }
    if (hasMove) {
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startMergeAnimation) userInfo:nil repeats:NO];
        [self adjustBlock];
    } else {
        [self startMergeAnimation];
    }
    
}
- (void)adjustBlock{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            moveType *c = moveTable[i][j];
            if (c->toI == -1 && c->fromI != -1) {
                //找到没有出，只有进的block
                //f指向当前block的进入block
                //c指向当前block
                moveType *f;
                do{
                    f = moveTable[c->fromI][c->fromJ];
                    CGPoint fromPoint = CGPointMake(306 + f->i * 138, 94 + f->j * 138);
                    
                    [CATransaction begin];
                    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey: kCATransactionDisableActions];
                    [block[c->i][c->j] setPosition:fromPoint];
                    [CATransaction commit];
                    
                    BlockLayer * bl = block[c->i][c->j];
                    block[c->i][c->j] = block[f->i][f->j];
                    block[f->i][f->j] = bl;
                    
                    
                    c->fromI = -1;
                    c->fromJ = -1;
                    f->toI = -1;
                    f->toJ = -1;
                    c = f;
                }while (c->fromI != -1);
            }
        }
    }
}

- (void)startMergeAnimation{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            if (mergeBlock[i][j]) {
                CABasicAnimation *mergeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                mergeAnimation.duration = 0.25;
                mergeAnimation.autoreverses = NO;
                mergeAnimation.repeatCount = 0;
                mergeAnimation.removedOnCompletion = NO;
                mergeAnimation.fillMode = kCAFillModeBackwards;
                mergeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
                mergeAnimation.toValue = [NSNumber numberWithFloat:1.05];
                [block[i][j] addAnimation:mergeAnimation forKey:@"transform"];
                mergeBlock[i][j] = false;
            }
            if (generateBlock[i][j]) {
                [self blockRefreshForI:i forJ:j];
                CABasicAnimation *generateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                generateAnimation.duration = 0.3;
                generateAnimation.autoreverses = NO;
                generateAnimation.repeatCount = 0;
                generateAnimation.removedOnCompletion = NO;
                generateAnimation.fillMode = kCAFillModeBackwards;
                generateAnimation.fromValue = [NSNumber numberWithFloat:0.4];
                generateAnimation.toValue = [NSNumber numberWithFloat:1.0];
                [block[i][j] addAnimation:generateAnimation forKey:@"transform"];
                generateBlock[i][j] = false;
            }
        }
    }
    
}

- (void)blockRefreshForI:(NSInteger)forI forJ:(NSInteger)forJ{
    block[forI][forJ].data = [gameData dataAtRow:forI col:forJ];
    block[forI][forJ].power = [gameData powerAtRow:forI col:forJ];
    [block[forI][forJ] setNeedsDisplay];
}
- (void)addMoveAnimationFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ{
    moveTable[fromI][fromJ]->toI = toI;
    moveTable[fromI][fromJ]->toJ = toJ;
    moveTable[toI][toJ]->fromI = fromI;
    moveTable[toI][toJ]->fromJ = fromJ;
    if (mergeBlock[fromI][fromJ]) {
        mergeBlock[toI][toJ] = true;
        mergeBlock[fromI][fromJ] = false;
    }
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
    [gameView setWantsLayer:YES];

    BlockAttribute *attr = [[BlockAttribute alloc]init];
    
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            block[i][j] = [BlockLayer layer];
            [[gameView layer] addSublayer:block[i][j]];
            
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            block[i][j].blockAttr = attr;
            
            [block[i][j] setBounds:CGRectMake(0, 0, 128, 128)];
            [block[i][j] setPosition:CGPointMake(306 + i * 138, 94 + j * 138)];
            [block[i][j] setAnchorPoint:CGPointMake(0.5, 0.5)];
            [block[i][j] setNeedsDisplay];
            
            moveTable[i][j] = malloc(sizeof(moveType));
            moveTable[i][j]->fromI = -1;
            moveTable[i][j]->fromJ = -1;
            moveTable[i][j]->toI = -1;
            moveTable[i][j]->toJ = -1;
            moveTable[i][j]->i = i;
            moveTable[i][j]->j = j;
            mergeBlock[i][j] = false;
            generateBlock[i][j] = false;
        }
    }
}
@end
