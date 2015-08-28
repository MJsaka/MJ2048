//
//  AppDelegate.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "AppDelegate.h"
#import "GameData.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate{
    IBOutlet GameData *gameData;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [gameData saveNSUserDefaults];
}

@end
