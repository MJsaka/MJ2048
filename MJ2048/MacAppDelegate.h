//
//  MacAppDelegate.h
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MacInterfaceControl.h"

@interface MacAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSPanel *preferencePanel;
@property (weak) IBOutlet GameData *gameData;
@property (weak) IBOutlet NSTextField *num;
@property (weak) IBOutlet NSStepper *stepper;
@property (weak) IBOutlet MacInterfaceControl *interfaceControl;
@end

