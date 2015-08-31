//
//  InterfaceControl.h
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GameData.h"
#import "GameView.h"

@interface InterfaceControl : NSObject{
    IBOutlet GameData *gameData;
    IBOutlet GameView *gameView;
}

- (IBAction)newGame:(id)sender;
- (void)keyboardControl:(dirEnumType)dir;

- (void)addMoveAnimationFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ;
- (void)addMergeAnimationFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ;
- (void)addGenerateAnimationForI:(NSInteger)i forj:(NSInteger)j;

@end
