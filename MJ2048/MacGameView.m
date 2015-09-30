//
//  MacGameAreaView.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//
#import "MacGameView.h"
#import "MacInterfaceControl.h"

@implementation MacGameAreaView

@synthesize attrGameOver;
@synthesize isDeath;

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
    [[NSColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0] set];
    [NSBezierPath fillRect: bounds];
    if (isDeath) {
        [self drawStringAtCenter:@"GAME OVER" withAttr:attrGameOver inArea:bounds];
    } else {
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                NSRect rect = NSMakeRect( 8 + i * 103, 8+ j * 103, 95, 95);
                [[NSColor colorWithRed:1.000 green:0.984 blue:0.792 alpha:1.0] set];
                [NSBezierPath fillRect: rect];
            }
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
    attrGameOver = [NSMutableDictionary dictionary];
    [attrGameOver setObject:[NSFont fontWithName:@"SimHei" size:80] forKey:NSFontAttributeName];
    [attrGameOver setObject:[NSColor colorWithRed:0.149 green:0.325 blue:0.137 alpha:1.0] forKey:NSForegroundColorAttributeName];
    
}

@end


@implementation MacInfoAreaView

-(void)drawRect:(NSRect)dirtyRect{
    [[NSColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0] set];
    [NSBezierPath fillRect:dirtyRect];
}

@end
