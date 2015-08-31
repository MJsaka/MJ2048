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

@implementation InterfaceControl{
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
            gameView.isDeath = [gameData isDeath];
            gameView.isNewScore = [gameData isNewScoreRecord];
            gameView.isNewPower = [gameData isNewPowerRecord];
            gameView.highScore = [gameData highScore];
            gameView.topPower = [gameData topPower];
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

- (void)awakeFromNib{
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
            block[i][j].blockAttr = attr;
        }
    }
}
@end
