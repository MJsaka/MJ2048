//
//  BlockView.m
//  MJ2048
//
//  Created by MJsaka on 8/29/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//
#import "BlockView.h"

@implementation BlockView

@synthesize blockAttr;
@synthesize data;
@synthesize power;

- (void)drawStringAtCenter:(NSString*)string withAttr:(NSDictionary*)attr inArea:(NSRect)rect{
    NSSize size = [string sizeWithAttributes:attr];
    NSPoint point;
    point.x = rect.origin.x + (rect.size.width - size.width)/2;
    point.y = rect.origin.y + (rect.size.height - size.height)/2;
    [string drawAtPoint:point withAttributes:attr];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSRect rect = [self bounds];
    [[blockAttr colorOfPower:power] set];
    [NSBezierPath fillRect: rect];
    //Draw Number;
    if (data != 0) {
        NSString *dataString = [NSString stringWithFormat:@"%ld",data];
        [self drawStringAtCenter:dataString withAttr:[blockAttr stringAttr] inArea:rect];
    }
    
}

- (BOOL)isOpaque{
    return YES;
}

- (BOOL)acceptsFirstResponder{
    return NO;
}
- (BOOL)resignFirstResponder{
    return NO;
}
- (BOOL)becomeFirstResponder{
    return NO;
}
@end
