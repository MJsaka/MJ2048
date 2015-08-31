//
//  GameView.h
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface GameView : NSView{
    IBOutlet id interface;
}
@property (assign) NSInteger currentScore;
@property (assign) NSInteger highScore;
@property (assign) NSInteger topPower;
@property (assign) Boolean isDeath;
@property (assign) Boolean isNewScore;
@property (assign) Boolean isNewPower;

@end
