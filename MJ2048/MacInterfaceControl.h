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
    IBOutlet NSTextField* bestTitle;
    IBOutlet NSTextField* best;
    IBOutlet NSTextField* powerTitle;
    IBOutlet NSTextField* power;
    IBOutlet NSTextField* scoreTitle;
    IBOutlet NSTextField* score;
}

- (IBAction)newGame:(id)sender;
- (void)newBlockNum:(id)sender;
- (void)keyboardControl:(dirEnumType)dir;
@end
