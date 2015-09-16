//
//  BlockLayer-iOS.m
//  MJ2048
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "BlockLayer-iOS.h"
@import CoreText;

@implementation BlockLayer
@synthesize blockAttr;
@synthesize data;
@synthesize power;
- (void)drawInContext:(CGContextRef)ctx {
    
    CGRect bounds = [self bounds];
    UIColor *color = [blockAttr colorOfPower:power];
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextFillRect(ctx,bounds);
    
    //Draw Number;
    if (data != 0) {
        [self setOpacity:1.0];
        
        CFStringRef string = CFStringCreateWithFormat ( kCFAllocatorDefault, nil, CFSTR("%ld") , (long)data );
        CTFontRef font = CTFontCreateWithName ( CFSTR("SimHei"), 20, NULL);
        
        CFStringRef keys[] = { kCTFontAttributeName };
        CFTypeRef values[] = { font };
        
        CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys, (const void**)&values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
        CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
        CFRelease(string);
        CFRelease(attributes);
        CTLineRef line = CTLineCreateWithAttributedString(attrString);
        
        // Set text position and draw the line into the graphics context
        CGRect rect = CTLineGetImageBounds(line , ctx);
        CGPoint point;
        point.x = (bounds.size.width - rect.size.width)/2;
        point.y = (bounds.size.height - rect.size.height)/2;
        CGContextSetTextPosition(ctx, point.x , point.y);
        CTLineDraw(line, ctx);
        CFRelease(line);
    }else{
        [self setOpacity:0];
    }
    
}

- (BOOL)isOpaque{
    return YES;
}

@end
