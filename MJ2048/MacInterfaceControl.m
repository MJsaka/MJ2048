    //
//  MacInterfaceControl.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//
#import "MacAppDelegate.h"
#import "MacInterfaceControl.h"
#import "MacBlock.h"
#import <QuartzCore/QuartzCore.h>

@implementation MacInterfaceControl{
    MacBlockAttribute *attr;
    NSArray *block;
    NSInteger blockNum;
    NSInteger margin;
    NSInteger width;
}

- (void)newBlockNum:(id)sender{
    for (int i = 0; i < blockNum; ++i) {
        for (int j = 0; j < blockNum; ++j) {
            [((MacBlockLayer*)block[i][j]) removeFromSuperlayer];
        }
    }
    [self awakeFromNib];
    [self newGame:self];
}

- (IBAction)newGame:(id)sender{
    [gameData newGame];
    [self refreshScoreArea];
    gameAreaView.isDeath = [gameData isDeath];
    gameAreaView.blockNum = blockNum;
    [gameAreaView setNeedsDisplay:YES];
    NSArray *gameDataDownSider = [gameData blockSider:DIR_DOWN];
    for (int i = 0; i < blockNum; ++i) {
        blockNodeType* node = gameDataDownSider[i];
        for (int j = 0; j < blockNum; ++j) {
            ((MacBlockLayer*)block[i][j]).data = node.data;
            ((MacBlockLayer*)block[i][j]).power = node.power;
            [((MacBlockLayer*)block[i][j]) setNeedsDisplay];
            [[gameAreaView layer] addSublayer:((MacBlockLayer*)block[i][j])];
            node = [node nodeOnDir:DIR_UP];
        }
    }
}

- (void)keyboardControl:(dirEnumType)dir{
    if([gameData merge:dir]){
        [self refreshScoreArea];
        NSArray *gameDataDownSider = [gameData blockSider:DIR_DOWN];
        for (int i = 0; i < blockNum; ++i) {
            blockNodeType* node = gameDataDownSider[i];
            for (int j = 0; j < blockNum; ++j) {
                if (node.refresh) {
                    ((MacBlockLayer*)block[i][j]).data = node.data;
                    ((MacBlockLayer*)block[i][j]).power = node.power;
                    node.refresh = false;
                    [((MacBlockLayer*)block[i][j]) setNeedsDisplay];
                }
                node = [node nodeOnDir:DIR_UP];
            }
        }
    }
    if([gameData move:dir]){
        [self startMoveAnimation];
        [self adjustBlock:dir];
        [gameData generate:dir];
        if ([gameData isDeath]) {
            gameAreaView.isDeath = [gameData isDeath];
            //隐藏Block
            for (int i = 0; i < blockNum; ++i) {
                for (int j = 0; j < blockNum; ++j) {
                    [((MacBlockLayer*)block[i][j]) removeFromSuperlayer];
                }
            }
            [gameAreaView setNeedsDisplay:YES];
        }
    }
}

- (void)startMoveAnimation{
    NSArray *gameDataDownSider = [gameData blockSider:DIR_DOWN];
    for (int i = 0; i < blockNum; ++i) {
        blockNodeType* node = gameDataDownSider[i];
        for (int j = 0; j < blockNum; ++j) {
            NSInteger toI = node.moveToI;
            NSInteger toJ = node.moveToJ;
            if (toI != -1 || toJ != -1) {
                CGPoint toPoint = CGPointMake(margin+width/2+toI*(margin+width), margin+width/2+toJ*(margin + width));
                [CATransaction begin];
                [CATransaction setValue:[NSNumber numberWithFloat:0.3f] forKey: kCATransactionAnimationDuration];
                [((MacBlockLayer*)block[i][j]) setPosition:toPoint];
                [CATransaction commit];
            }
            node = [node nodeOnDir:DIR_UP];
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startMergeAnimation) userInfo:nil repeats:NO];
}

- (void)startMergeAnimation{
    NSArray *gameDataDownSider = [gameData blockSider:DIR_DOWN];
    for (int i = 0; i < blockNum; ++i) {
        blockNodeType* node = gameDataDownSider[i];
        for (int j = 0; j < blockNum; ++j) {
            if (node.merge) {
                CABasicAnimation *mergeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                mergeAnimation.duration = 0.3;
                mergeAnimation.autoreverses = NO;
                mergeAnimation.repeatCount = 0;
                mergeAnimation.removedOnCompletion = NO;
                mergeAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                mergeAnimation.fillMode = kCAFillModeBackwards;
                mergeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
                mergeAnimation.toValue = [NSNumber numberWithFloat:1.15];
                [((MacBlockLayer*)block[i][j]) addAnimation:mergeAnimation forKey:@"transform"];
                node.merge = false;
            }
            if (node.generate) {
                ((MacBlockLayer*)block[i][j]).data = node.data;
                ((MacBlockLayer*)block[i][j]).power = node.power;
                [((MacBlockLayer*)block[i][j]) setNeedsDisplay];
                
                CABasicAnimation *generateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                generateAnimation.duration = 0.3;
                generateAnimation.autoreverses = NO;
                generateAnimation.repeatCount = 0;
                generateAnimation.removedOnCompletion = NO;
                generateAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                generateAnimation.fillMode = kCAFillModeBackwards;
                generateAnimation.fromValue = [NSNumber numberWithFloat:0];
                generateAnimation.toValue = [NSNumber numberWithFloat:1.0];
                [((MacBlockLayer*)block[i][j]) addAnimation:generateAnimation forKey:@"transform"];
                node.generate = false;
            }
            node = [node nodeOnDir:DIR_UP];
        }
    }
}


- (void)adjustBlock:(dirEnumType)dir{
    dirEnumType redir = 3 - dir;
    NSArray *gameDataDirSider = [gameData blockSider:dir];
    for (int i = 0; i < blockNum; ++i) {
        blockNodeType* node = gameDataDirSider[i];
        for (int j = 0; j < blockNum; ++j) {
            if (node.moveToI == -1 && node.moveFromI != -1) {
                //找到没有出，只有进的block
                //f指向当前block的进入block，c指向当前block
                blockNodeType *c = node;
                blockNodeType *f = [node nodeOnDir:redir];
                while (f.moveToI == -1) {
                    f = [f nodeOnDir:redir];
                }
                CGPoint fromPoint = CGPointMake(margin+width/2+f.posi*(margin+width), margin+width/2+f.posj*(margin + width));
                
                [CATransaction begin];
                [CATransaction setValue:[NSNumber numberWithBool:YES] forKey: kCATransactionDisableActions];
                [block[c.posi][c.posj] setPosition:fromPoint];
                [CATransaction commit];
                
                MacBlockLayer* bl = block[c.posi][c.posj];
                block[c.posi][c.posj] = block[f.posi][f.posj];
                block[f.posi][f.posj] = bl;
                
                c.moveFromI = -1;
                c.moveFromJ = -1;
                f.moveToI = -1;
                f.moveToJ = -1;
            }
            node = [node nodeOnDir:redir];
        }
    }
}
- (void)refreshScoreArea{
    topPowerTitleView.backgroundColor = [attr colorOfPower:[gameData topPower]];
    topPowerView.backgroundColor = [attr colorOfPower:[gameData topPower]];
    
    bestScoreTitleView.backgroundColor = [attr colorOfPower:[gameData topPower]];
    bestScoreView.backgroundColor = [attr colorOfPower:[gameData topPower]];
    
    currentScoreTitleView.backgroundColor = [attr colorOfPower:[gameData currentPower]];
    currentScoreView.backgroundColor = [attr colorOfPower:[gameData currentPower]];
    
    [topPower setStringValue:[NSString stringWithFormat:@"%.0f",pow(2, [gameData topPower])]];
    [bestScore setStringValue:[NSString stringWithFormat:@"%ld",[gameData highScore]]];
    [currentScore setStringValue: [NSString stringWithFormat:@"%ld",[gameData currentScore]]];
}


- (void)awakeFromNib{
    blockNum = [gameData blockNum];
    margin = 10 + (5-blockNum)*4;
    width = (630 - (blockNum+1)*margin)/blockNum;
    attr = [[MacBlockAttribute alloc]initWithFontSize:blockNum * 5 * pow(2, 5-blockNum)];
    
    [self refreshScoreArea];

    gameAreaView.blockNum = blockNum;
    gameAreaView.isDeath = [gameData isDeath];
    [gameAreaView setWantsLayer:YES];
    [gameAreaView setNeedsDisplay:YES];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSArray *gameDataDirSider = [gameData blockSider:DIR_DOWN];
    for (int i = 0; i < blockNum; ++i) {
        NSMutableArray *col = [NSMutableArray arrayWithCapacity:0];
        blockNodeType *node = gameDataDirSider[i];
        for (int j = 0; j < blockNum; ++j) {
            MacBlockLayer *blockLayer = [MacBlockLayer layer];
            [[gameAreaView layer] addSublayer:blockLayer];
            
            blockLayer.data = node.data;
            blockLayer.power = node.power;
            blockLayer.blockAttr = attr;
            
            [blockLayer setBounds:CGRectMake(0, 0, width, width)];
            [blockLayer setPosition:CGPointMake(margin+width/2+i*(margin+width), margin+width/2+j*(margin + width))];
            [blockLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
            [blockLayer setNeedsDisplay];
            [col addObject:blockLayer];
            node = [node nodeOnDir:DIR_UP];
        }
        [array addObject:col];
    }
    block = [NSArray arrayWithArray:array];
}
@end
