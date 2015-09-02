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
- (void)addMoveAnimationAfterMergeFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ;
- (void)addMergeAnimationForI:(NSInteger)fromI forJ:(NSInteger)fromJ;
- (void)addGenerateAnimationForI:(NSInteger)forI forJ:(NSInteger)forJ;

- (void)startMoveAnimation;
- (void)startMoveAnimationAfterMerge;
- (void)startMergeAnimation;

@end
