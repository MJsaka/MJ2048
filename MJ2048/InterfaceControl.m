    //
//  InterfaceControl.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "InterfaceControl.h"
#import "BlockLayer.h"
#import <QuartzCore/QuartzCore.h>

@implementation InterfaceControl{
    BlockLayer *block[4][4];
    moveTableArray *moveTable;
    boolTable *refreshTable;
    boolTable *mergeTable;
    boolTable *generateTable;
}


- (IBAction)newGame:(id)sender{
    [gameData newGame];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            [block[i][j] setNeedsDisplay];
            [[gameView layer] addSublayer:block[i][j]];
            [block[i][j] setHidden:NO];
        }
    }
    gameView.isDeath = [gameData isDeath];
    gameView.currentScore = [gameData currentScore];
    gameView.highScore = [gameData highScore];
    gameView.topPower = [gameData topPower];
    [gameView setNeedsDisplay:YES];
}

- (void)keyboardControl:(dirEnumType)dir{
    if([gameData merge:dir]){
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                if ((*refreshTable)[i][j]) {
                    block[i][j].data = [gameData dataAtRow:i col:j];
                    block[i][j].power = [gameData powerAtRow:i col:j];
                    (*refreshTable)[i][j] = false;
                    [block[i][j] setNeedsDisplay];
                }
            }
        }
    }
    if([gameData move:dir]){
        [self startMoveAnimation];
        [gameData generate:dir];
        gameView.currentScore = [gameData currentScore];
        if ([gameData isDeath]) {
            gameView.isDeath = [gameData isDeath];
            gameView.highScore = [gameData highScore];
            gameView.topPower = [gameData topPower];
            //隐藏Block
            for (int i = 0; i < 4; ++i) {
                for (int j = 0; j < 4; ++j) {
                    [block[i][j] removeFromSuperlayer];
                }
            }
        }
        [gameView setNeedsDisplay:YES];
    }
}

- (void)startMoveAnimation{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            NSInteger toI = (*moveTable)[i][j].toI;
            NSInteger toJ = (*moveTable)[i][j].toJ;
            if (toI != -1 || toJ != -1) {
                CGPoint toPoint = CGPointMake(306 + toI * 138, 94 + toJ * 138);
                [CATransaction begin];
                [CATransaction setValue:[NSNumber numberWithFloat:0.3f] forKey: kCATransactionAnimationDuration];
                [block[i][j] setPosition:toPoint];
                [CATransaction commit];
            }
        }
    }
    [self adjustBlock];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startMergeAnimation) userInfo:nil repeats:NO];
}

- (void)startMergeAnimation{
    
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            if ((*mergeTable)[i][j]) {
                CABasicAnimation *mergeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                mergeAnimation.duration = 0.3;
                mergeAnimation.autoreverses = NO;
                mergeAnimation.repeatCount = 0;
                mergeAnimation.removedOnCompletion = NO;
                mergeAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                mergeAnimation.fillMode = kCAFillModeBackwards;
                mergeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
                mergeAnimation.toValue = [NSNumber numberWithFloat:1.15];
                [block[i][j] addAnimation:mergeAnimation forKey:@"transform"];
                (*mergeTable)[i][j] = false;
            }
            if ((*generateTable)[i][j]) {
                block[i][j].data = [gameData dataAtRow:i col:j];
                block[i][j].power = [gameData powerAtRow:i col:j];
                [block[i][j] setNeedsDisplay];
                
                CABasicAnimation *generateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                generateAnimation.duration = 0.3;
                generateAnimation.autoreverses = NO;
                generateAnimation.repeatCount = 0;
                generateAnimation.removedOnCompletion = NO;
                generateAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                generateAnimation.fillMode = kCAFillModeBackwards;
                generateAnimation.fromValue = [NSNumber numberWithFloat:0];
                generateAnimation.toValue = [NSNumber numberWithFloat:1.0];
                [block[i][j] addAnimation:generateAnimation forKey:@"transform"];
                (*generateTable)[i][j] = false;
            }
        }
    }
}


- (void)adjustBlock{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            moveElementType *c = &((*moveTable)[i][j]);
            if (c->toI == -1 && c->fromI != -1) {
                //找到没有出，只有进的block
                //f指向当前block的进入block，c指向当前block
                moveElementType *f;
                do{
                    f = &((*moveTable)[c->fromI][c->fromJ]);
                    CGPoint fromPoint = CGPointMake(306 + f->i * 138, 94 + f->j * 138);
                    
                    [CATransaction begin];
                    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey: kCATransactionDisableActions];
                    [block[c->i][c->j] setPosition:fromPoint];
                    [CATransaction commit];
                    
                    BlockLayer* bl = block[c->i][c->j];
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


- (void)awakeFromNib{
    gameView.isDeath = [gameData isDeath];
    gameView.currentScore = [gameData currentScore];
    gameView.highScore = [gameData highScore];
    gameView.topPower = [gameData topPower];
    [gameView setWantsLayer:YES];
    [gameView setNeedsDisplay:YES];

    BlockAttribute *attr = [[BlockAttribute alloc]init];
    
    animationStatusType* aST = [gameData animationStatus];
    moveTable = aST->aMoveTable;
    refreshTable = aST->aRefreshTable;
    mergeTable = aST->aMergeTable;
    generateTable = aST->aGenerateTable;
    
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
        }
    }
}
@end
