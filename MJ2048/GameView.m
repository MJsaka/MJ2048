//
//  GameView.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "GameView.h"
#import "GameData.h"
#import "InterfaceControl.h"

@implementation GameView
{
    NSColor *colorOfData[21];
    NSMutableDictionary *attrTitle;
    NSMutableDictionary *attrContent;
    NSMutableDictionary *attrGameOver;
    NSRect recordArea;
    NSRect recordAreaUp;
    NSRect recordAreaDown;
    NSRect scoreArea;
    NSRect scoreAreaUp;
    NSRect scoreAreaDown;
    NSRect numberArea;
    NSRect numberAreaUp;
    NSRect numberAreaDown;
    NSRect gameArea;
    NSRect gameAreaUp;
    NSRect gameAreaDown;

}
- (void)drawStringAtCenter:(NSString*)string withAttr:(NSDictionary*)attr inArea:(NSRect)rect{
    NSSize size = [string sizeWithAttributes:attr];
    NSPoint point;
    point.x = rect.origin.x + (rect.size.width - size.width)/2;
    point.y = rect.origin.y + (rect.size.height - size.height)/2;
    [string drawAtPoint:point withAttributes:attr];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Fill the view
    NSRect bounds = [self bounds];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect: bounds];
    
    NSString *str;
    //Draw InfoArea;
    [[NSColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0] set];
    [NSBezierPath fillRect: scoreArea];
    str = [NSString stringWithFormat:@"%ld",[gameData currentScore]];
    [self drawStringAtCenter:str withAttr:attrTitle inArea:scoreAreaDown];
    [self drawStringAtCenter:@"当前分数" withAttr:attrTitle inArea:scoreAreaUp];
    
    [[NSColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0] set];
    [NSBezierPath fillRect: recordArea];
    str = [NSString stringWithFormat:@"%ld",[gameData highScore]];
    [self drawStringAtCenter:str withAttr:attrTitle inArea:recordAreaDown];
    [self drawStringAtCenter:@"最高分数" withAttr:attrTitle inArea:recordAreaUp];
    
    [colorOfData[[gameData topPower]] set];
    [NSBezierPath fillRect: numberArea];
    str = [NSString stringWithFormat:@"%.0f",pow(2,[gameData topPower])];
    [self drawStringAtCenter:str withAttr:attrTitle inArea:numberAreaDown];
    [self drawStringAtCenter:@"最大数字" withAttr:attrTitle inArea:numberAreaUp];
    
    //Draw GameArea;
    [[NSColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0] set];
    [NSBezierPath fillRect: gameArea];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            NSRect rect = NSMakeRect(242+138*i,30+138*j,128,128);
            //Draw Block Background;
            NSInteger power = [gameData powerAtRow:i col:j];
            [colorOfData[power] set];
            [NSBezierPath fillRect: rect];
            //Draw Number;
            NSInteger data = [gameData dataAtRow:i col:j];
            if (data != 0) {
                NSString *dataString = [NSString stringWithFormat:@"%ld",data];
                [self drawStringAtCenter:dataString withAttr:attrContent inArea:rect];
            }
        }
    }
    if ([gameData isDeath]) {
        [[NSColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0] set];
        [NSBezierPath fillRect: gameArea];
        if ([[interface gameOverString] isEqualTo:@""]) {
            [self drawStringAtCenter:@"GAME OVER" withAttr:attrGameOver inArea:gameArea];
        }else{
            [self drawStringAtCenter:@"GAME OVER" withAttr:attrGameOver inArea:gameAreaUp];
            [self drawStringAtCenter:[interface gameOverString] withAttr:attrTitle inArea:gameAreaDown];
        }
    }
}

- (BOOL)isOpaque{
    return YES;
}

- (BOOL)acceptsFirstResponder{
    return YES; }
- (BOOL)resignFirstResponder{
    [self setNeedsDisplay:YES];
    return YES;
}
- (BOOL)becomeFirstResponder{
    [self setNeedsDisplay:YES];
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    if ([theEvent modifierFlags] & NSNumericPadKeyMask) {
        [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    } else {
        [super keyDown:theEvent];
    }
}

-(IBAction)moveUp:(id)sender{
    [interface keyboardControl:DIR_UP];
}
-(IBAction)moveDown:(id)sender{
    [interface keyboardControl:DIR_DOWN];
}
-(IBAction)moveLeft:(id)sender{
    [interface keyboardControl:DIR_LEFT];
}
-(IBAction)moveRight:(id)sender{
    [interface keyboardControl:DIR_RIGHT];
}

-(void)awakeFromNib{
    colorOfData[0] = [NSColor colorWithRed:1.000 green:0.984 blue:0.792 alpha:1.0];
    colorOfData[1] = [NSColor colorWithRed:0.973 green:0.800 blue:0.584 alpha:1.0];
    colorOfData[2] = [NSColor colorWithRed:0.965 green:0.800 blue:0.800 alpha:1.0];
    colorOfData[3] = [NSColor colorWithRed:0.980 green:0.800 blue:0.200 alpha:1.0];
    colorOfData[4] = [NSColor colorWithRed:0.949 green:0.608 blue:0.200 alpha:1.0];
    
    colorOfData[5] = [NSColor colorWithRed:0.345 green:0.704 blue:0.896 alpha:1.0];
    colorOfData[6] = [NSColor colorWithRed:0.922 green:0.396 blue:0.396 alpha:1.0];
    colorOfData[7] = [NSColor colorWithRed:0.894 green:0.402 blue:0.157 alpha:1.0];
    colorOfData[8] = [NSColor colorWithRed:0.878 green:0.263 blue:0.506 alpha:1.0];
    
    colorOfData[9] = [NSColor colorWithRed:0.808 green:0.596 blue:0.716 alpha:1.0];
    colorOfData[10] = [NSColor colorWithRed:0.682 green:0.153 blue:0.353 alpha:1.0];
    colorOfData[11] = [NSColor colorWithRed:0.541 green:0.676 blue:0.153 alpha:1.0];
    colorOfData[12] = [NSColor colorWithRed:0.696 green:0.408 blue:0.180 alpha:1.0];
    
    colorOfData[13] = [NSColor colorWithRed:0.608 green:0.400 blue:0.804 alpha:1.0];
    colorOfData[14] = [NSColor colorWithRed:0.308 green:0.604 blue:0.396 alpha:1.0];
    colorOfData[15] = [NSColor colorWithRed:0.490 green:0.222 blue:0.490 alpha:1.0];
    colorOfData[16] = [NSColor colorWithRed:0.404 green:0.404 blue:0.704 alpha:1.0];
    
    colorOfData[17] = [NSColor colorWithRed:0.182 green:0.233 blue:0.473 alpha:1.0];
    colorOfData[18] =  [NSColor colorWithRed:0.271 green:0.196 blue:0.396 alpha:1.0];
    colorOfData[19] =  [NSColor colorWithRed:0.425 green:0.249 blue:0.249 alpha:1.0];
    colorOfData[20] = [NSColor colorWithRed:0.149 green:0.325 blue:0.137 alpha:1.0];

    scoreArea = NSMakeRect(20, 102, 192, 150);
    scoreAreaDown = NSMakeRect(20, 102, 192, 75);
    scoreAreaUp = NSMakeRect(20, 177, 192, 75);
    
    recordArea = NSMakeRect(20, 267, 192, 150);
    recordAreaDown = NSMakeRect(20, 267, 192, 75);
    recordAreaUp = NSMakeRect(20, 342, 192, 75);
    
    numberArea = NSMakeRect(20, 432, 192, 150);
    numberAreaDown = NSMakeRect(20, 432, 192, 75);
    numberAreaUp = NSMakeRect(20, 507, 192, 75);
    
    gameArea = NSMakeRect(232,20,562,562);
    gameAreaDown = NSMakeRect(232,20,562,400);
    gameAreaUp = NSMakeRect(232,220,562,262);;
    
    attrContent = [NSMutableDictionary dictionary];
    [attrContent setObject:[NSFont fontWithName:@"SimHei" size:50] forKey:NSFontAttributeName];
    
    attrTitle = [NSMutableDictionary dictionary];
    [attrTitle setObject:[NSFont fontWithName:@"SimHei" size:40] forKey:NSFontAttributeName];
    
    attrGameOver = [NSMutableDictionary dictionary];
    [attrGameOver setObject:[NSFont fontWithName:@"SimHei" size:100] forKey:NSFontAttributeName];
    [attrGameOver setObject:[NSColor colorWithRed:0.149 green:0.325 blue:0.137 alpha:1.0] forKey:NSForegroundColorAttributeName];
}

@end
