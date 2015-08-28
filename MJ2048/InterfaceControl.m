//
//  InterfaceControl.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "InterfaceControl.h"
#import "GameView.h"

@implementation InterfaceControl{
    NSMutableString *gameOverString;
}

- (NSString*)gameOverString{
    return gameOverString;
}


- (IBAction)newGame:(id)sender{
    [gameData newGame];
    [gameView setNeedsDisplay:YES];
    gameOverString = [NSMutableString stringWithString:@""];
}

- (void)keyboardControl:(dirEnumType)dir{
    if([gameData move:dir]){
        [gameView setNeedsDisplay:YES];
        if([gameData isDeath]){
            if ([gameData isNewScoreRecord]) {
                [gameOverString appendString:[NSString stringWithFormat:@"NEW SCORE: %ld\n",[gameData highScore]]];
            }
            if ([gameData isNewPowerRecord]) {
                [gameOverString appendString:[NSString stringWithFormat:@"NEW BLOCK: %.0f",pow(2,[gameData topPower])]];
            }
        }
    }
}

- (void)awakeFromNib{
    gameOverString = [NSMutableString stringWithString:@""];
}
@end
