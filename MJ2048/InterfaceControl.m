//
//  InterfaceControl.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "InterfaceControl.h"

@implementation InterfaceControl{
    NSMutableString *labelString;
}


- (IBAction)newGame:(id)sender{
    [gameData newGame];
    [gameView setNeedsDisplay:YES];
    labelString =  [NSMutableString stringWithString:@"Game Over\n"];
}

- (void)keyboardControl:(dirEnumType)dir{
    if([gameData move:dir]){
        [gameView setNeedsDisplay:YES];
        if([gameData isDeath]){
            if ([gameData isNewScoreRecord]) {
                [labelString appendString:[NSString stringWithFormat:@"You get a new highscore:%ld\n",[gameData highScore]]];
            }
            if ([gameData isNewPowerRecord]) {
                [labelString appendString:[NSString stringWithFormat:@"You make a new block:%.0f\n",pow(2,[gameData topPower])]];
            }
            [self openWinSheet];
        }
    }
}
- (void)openWinSheet{
    [theLabel setStringValue:labelString];
    [NSApp beginSheet:theWinSheet modalForWindow:theMainWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];
}
- (IBAction)continueClick:(id)sender{
    [theWinSheet orderOut:nil];
    [NSApp endSheet:theWinSheet];
    [self newGame:self];
}
- (IBAction)okClick:(id)sender{
    [theWinSheet orderOut:nil];
    [NSApp endSheet:theWinSheet];
}
- (void)awakeFromNib{
    labelString =  [NSMutableString stringWithString:@"Game Over\n"];
}
@end
