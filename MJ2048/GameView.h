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
@property (assign,nonatomic) NSInteger currentScore;
@property (assign,nonatomic) NSInteger highScore;
@property (assign,nonatomic) NSInteger topPower;
@property (assign,nonatomic) Boolean isDeath;
@property (assign,nonatomic) Boolean isNewScore;
@property (assign,nonatomic) Boolean isNewPower;

@end
