//
//  MacInterfaceControl.h
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GameData.h"
#import "MacGameView.h"

@interface MacInterfaceControl : NSObject{
    IBOutlet GameData *gameData;
    IBOutlet MacGameAreaView *gameAreaView;
    IBOutlet NSTextField* bestScoreTitle;
    IBOutlet NSTextField* bestScore;
    IBOutlet NSTextField* topPowerTitle;
    IBOutlet NSTextField* topPower;
    IBOutlet NSTextField* currentScoreTitle;
    IBOutlet NSTextField* currentScore;
}

- (IBAction)newGame:(id)sender;
- (void)newBlockNum:(id)sender;
- (void)keyboardControl:(dirEnumType)dir;
@end
