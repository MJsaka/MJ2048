//
//  MacAppDelegate.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "MacAppDelegate.h"
#import "GameData.h"

@interface MacAppDelegate ()

@end

@implementation MacAppDelegate
@synthesize window;
@synthesize preferencePanel;
@synthesize num;
@synthesize gameData;
@synthesize interfaceControl;
@synthesize stepper;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [gameData saveNSUserDefaults];
}
- (IBAction)stepperValueChanged:(NSStepper *)sender {
    [num setDoubleValue:[sender doubleValue]];
}

- (IBAction)openWinSheet:(id)sender{
    [stepper setIntegerValue:[gameData blockNum]];
    [num setIntegerValue:[gameData blockNum]];
    [NSApp beginSheet:preferencePanel modalForWindow:window modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)okClick:(id)sender{
    [preferencePanel orderOut:nil];
    [NSApp endSheet:preferencePanel];
    [gameData setBlockNum:[num integerValue]];
    [interfaceControl newBlockNum:self];
}


@end
