//
//  InterfaceControl.h
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GameData.h"
@interface InterfaceControl : NSObject{
    IBOutlet id gameData;
    IBOutlet id gameView;
    
    IBOutlet id theMainWindow;
    IBOutlet id theWinSheet;
    IBOutlet id theLabel;
}

- (IBAction)newGame:(id)sender;
- (void)keyboardControl:(dirEnumType)dir;

- (void)openWinSheet;
- (IBAction)continueClick:(id)sender;
- (IBAction)okClick:(id)sender;
@end
