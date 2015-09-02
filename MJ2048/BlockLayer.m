//
//  BlockLayer.m
//  MJ2048
//
//  Created by MJsaka on 8/29/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//
#import "BlockLayer.h"
#import <QuartzCore/QuartzCore.h>

@implementation BlockLayer

@synthesize blockAttr;
@synthesize data;
@synthesize power;
@synthesize posI;
@synthesize posJ;
//
//- (void)drawStringAtCenter:(NSString*)string withAttr:(NSDictionary*)attr inArea:(NSRect)rect{
//    NSSize size = [string sizeWithAttributes:attr];
//    NSPoint point;
//    point.x = rect.origin.x + (rect.size.width - size.width)/2;
//    point.y = rect.origin.y + (rect.size.height - size.height)/2;
//    [string drawAtPoint:point withAttributes:attr];
//}

- (void)drawInContext:(CGContextRef)ctx {
    CGPoint position = CGPointMake(306 + posI * 138, 94 + posJ * 138);
    [self setPosition:position];
    CGRect bounds = [self bounds];
    NSColor *color = [blockAttr colorOfPower:power];
    CGContextSetRGBFillColor(ctx, color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent);
    CGContextFillRect(ctx,bounds);
    //Draw Number;
    if (data != 0) {
        
        CFStringRef string = CFStringCreateWithFormat ( kCFAllocatorDefault, nil, CFSTR("%ld") , (long)data );
        CTFontRef font = CTFontCreateWithName ( CFSTR("SimHei"), 50, NULL);
        
        CFStringRef keys[] = { kCTFontAttributeName };
        CFTypeRef values[] = { font };
        
        CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys, (const void**)&values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
        CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
        CFRelease(string);
        CFRelease(attributes);
        CTLineRef line = CTLineCreateWithAttributedString(attrString);
        
        // Set text position and draw the line into the graphics context
        CGRect rect = CTLineGetImageBounds(line , ctx);
        NSPoint point;
        point.x = (bounds.size.width - rect.size.width)/2;
        point.y = (bounds.size.height - rect.size.height)/2;
        CGContextSetTextPosition(ctx, point.x , point.y);
        CTLineDraw(line, ctx);
        CFRelease(line);
    }
    
}

- (BOOL)isOpaque{
    return YES;
}
@end
