//
//  GameView.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//
#import "GameView.h"
#import "InterfaceControl.h"

@implementation GameView
{
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
@synthesize currentScore;
@synthesize highScore;
@synthesize topPower;
@synthesize isDeath;
//@synthesize isNewPower;
//@synthesize isNewScore;

- (void)drawStringAtCenter:(NSString*)string withAttr:(NSDictionary*)attr inArea:(NSRect)rect{
    NSSize size = [string sizeWithAttributes:attr];
    NSPoint point;
    point.x = rect.origin.x + (rect.size.width - size.width)/2;
    point.y = rect.origin.y + (rect.size.height - size.height)/2;
    [string drawAtPoint:point withAttributes:attr];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Fill the view
    [super drawRect:dirtyRect];
    NSRect bounds = [self bounds];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect: bounds];
    
    [[NSColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0] set];
    [NSBezierPath fillRect: scoreArea];
    [NSBezierPath fillRect: recordArea];
    [NSBezierPath fillRect: numberArea];
    [NSBezierPath fillRect: gameArea];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            NSRect rect = NSMakeRect(242 + i * 138, 30 + j * 138, 128, 128);
            [[NSColor colorWithRed:1.000 green:0.984 blue:0.792 alpha:1.0] set];
            [NSBezierPath fillRect: rect];
        }
    }
    
    [self drawStringAtCenter:@"当前分数" withAttr:attrTitle inArea:scoreAreaUp];
    [self drawStringAtCenter:@"最高分数" withAttr:attrTitle inArea:recordAreaUp];
    [self drawStringAtCenter:@"最大数字" withAttr:attrTitle inArea:numberAreaUp];

    NSString *str;
    str = [NSString stringWithFormat:@"%ld",currentScore];
    [self drawStringAtCenter:str withAttr:attrTitle inArea:scoreAreaDown];
    
    str = [NSString stringWithFormat:@"%ld",highScore];
    [self drawStringAtCenter:str withAttr:attrTitle inArea:recordAreaDown];
    
    str = [NSString stringWithFormat:@"%.0f",pow(2,topPower)];
    [self drawStringAtCenter:str withAttr:attrTitle inArea:numberAreaDown];
    
    
    if (isDeath) {
        [[NSColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0] set];
        [NSBezierPath fillRect: gameArea];
//        NSMutableString *gameOverString = [NSMutableString string];
//        if (isNewScore) {
//            [gameOverString appendString:[NSString stringWithFormat:@"NEW SCORE: %ld\n",highScore]];
//        }
//        if (isNewPower) {
//            [gameOverString appendString:[NSString stringWithFormat:@"NEW BLOCK: %.0f",pow(2,topPower)]];
//        }
//        if ([gameOverString isEqualTo:@""]) {
            [self drawStringAtCenter:@"GAME OVER" withAttr:attrGameOver inArea:gameArea];
//        }else{
//            [self drawStringAtCenter:@"GAME OVER" withAttr:attrGameOver inArea:gameAreaUp];
//            [self drawStringAtCenter:gameOverString withAttr:attrTitle inArea:gameAreaDown];
//        }
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
    gameAreaDown = NSMakeRect(232,140,562,160);
    gameAreaUp = NSMakeRect(232,300,562,160);;
    
    attrTitle = [NSMutableDictionary dictionary];
    [attrTitle setObject:[NSFont fontWithName:@"SimHei" size:40] forKey:NSFontAttributeName];
    
    attrGameOver = [NSMutableDictionary dictionary];
    [attrGameOver setObject:[NSFont fontWithName:@"SimHei" size:100] forKey:NSFontAttributeName];
    [attrGameOver setObject:[NSColor colorWithRed:0.149 green:0.325 blue:0.137 alpha:1.0] forKey:NSForegroundColorAttributeName];
    
}

@end
