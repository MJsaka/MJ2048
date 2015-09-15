//
//  ViewController.h
//  MJ2048-iOS
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameData.h"

@interface ViewController : UIViewController {
    IBOutlet GameData *gameData;
}

- (IBAction)newGame:(id)sender;
- (void)keyboardControl:(dirEnumType)dir;

- (void)addMoveAnimationFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ;
- (void)addMergeAnimationForI:(NSInteger)forI forJ:(NSInteger)forJ;
- (void)addGenerateAnimationForI:(NSInteger)forI forJ:(NSInteger)forJ;
- (void)blockRefreshForI:(NSInteger)forI forJ:(NSInteger)forJ;


@end

