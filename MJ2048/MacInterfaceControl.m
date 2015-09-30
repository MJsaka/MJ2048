    //
//  MacInterfaceControl.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "MacInterfaceControl.h"
#import "MacBlock.h"
#import <QuartzCore/QuartzCore.h>

@implementation MacInterfaceControl{
    MacBlockAttribute *attr;
    MacBlockLayer *block[4][4];
    moveTableArray *moveTable;
    boolTable *refreshTable;
    boolTable *mergeTable;
    boolTable *generateTable;
}


- (IBAction)newGame:(id)sender{
    [gameData newGame];
    [self refreshScoreArea];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            [block[i][j] setNeedsDisplay];
            [[gameAreaView layer] addSublayer:block[i][j]];
            [block[i][j] setHidden:NO];
        }
    }
    gameAreaView.isDeath = [gameData isDeath];
    [gameAreaView setNeedsDisplay:YES];
}

- (void)keyboardControl:(dirEnumType)dir{
    if([gameData merge:dir]){
        [self refreshScoreArea];
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
        if ([gameData isDeath]) {
            gameAreaView.isDeath = [gameData isDeath];
            //隐藏Block
            for (int i = 0; i < 4; ++i) {
                for (int j = 0; j < 4; ++j) {
                    [block[i][j] removeFromSuperlayer];
                }
            }
            [gameAreaView setNeedsDisplay:YES];
        }
    }
}

- (void)startMoveAnimation{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            NSInteger toI = (*moveTable)[i][j].toI;
            NSInteger toJ = (*moveTable)[i][j].toJ;
            if (toI != -1 || toJ != -1) {
                CGPoint toPoint = CGPointMake(55.5 + toI * 103, 55.5 + toJ * 103);
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
                    CGPoint fromPoint = CGPointMake(55.5 + f->i * 103, 55.5 + f->j * 103);
                    
                    [CATransaction begin];
                    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey: kCATransactionDisableActions];
                    [block[c->i][c->j] setPosition:fromPoint];
                    [CATransaction commit];
                    
                    MacBlockLayer* bl = block[c->i][c->j];
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
- (void)refreshScoreArea{
    [power setStringValue:[NSString stringWithFormat:@"%.0f",pow(2, [gameData topPower])]];
    powerTitle.backgroundColor = [attr colorOfPower:[gameData topPower]];
    power.backgroundColor = [attr colorOfPower:[gameData topPower]];
    [score setStringValue: [NSString stringWithFormat:@"%ld",[gameData currentScore]]];
    
    bestTitle.backgroundColor = [attr colorOfPower:[gameData topPower]];
    best.backgroundColor = [attr colorOfPower:[gameData topPower]];
    [best setStringValue:[NSString stringWithFormat:@"%ld",[gameData highScore]]];
}


- (void)awakeFromNib{
    gameAreaView.isDeath = [gameData isDeath];
    [gameAreaView setWantsLayer:YES];
    [gameAreaView setNeedsDisplay:YES];

    attr = [[MacBlockAttribute alloc]init];
    
    animationStatusType* aST = [gameData animationStatus];
    moveTable = aST->aMoveTable;
    refreshTable = aST->aRefreshTable;
    mergeTable = aST->aMergeTable;
    generateTable = aST->aGenerateTable;
    
    [self refreshScoreArea];
    
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            block[i][j] = [MacBlockLayer layer];
            [[gameAreaView layer] addSublayer:block[i][j]];
            
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            block[i][j].blockAttr = attr;
            
            [block[i][j] setBounds:CGRectMake(0, 0, 95, 95)];
            [block[i][j] setPosition:CGPointMake(55.5 + i * 103, 55.5 + j * 103)];
            [block[i][j] setAnchorPoint:CGPointMake(0.5, 0.5)];
            [block[i][j] setNeedsDisplay];
        }
    }
}
@end
