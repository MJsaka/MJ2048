//
//  MacBlockLayer.m
//  MJ2048
//
//  Created by MJsaka on 8/29/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//
#import "MacBlock.h"
#import <QuartzCore/QuartzCore.h>

@implementation MacBlockLayer

@synthesize blockAttr;
@synthesize data;
@synthesize power;
- (void)drawInContext:(CGContextRef)ctx {
    
    CGRect bounds = [self bounds];
    NSColor *color = [blockAttr colorOfPower:power];
    CGContextSetRGBFillColor(ctx, color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent);
    CGContextFillRect(ctx,bounds);
    //Draw Number;
    if (data != 0) {
        [self setOpacity:1.0];
        
        CFStringRef string = CFStringCreateWithFormat ( kCFAllocatorDefault, nil, CFSTR("%ld") , (long)data );
        CTFontRef font = CTFontCreateWithName ( CFSTR("SimHei"), blockAttr.fontSize, NULL);
        
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
    }else{
        [self setOpacity:0];
    }
    
}

- (BOOL)isOpaque{
    return YES;
}

@end


@implementation MacBlockAttribute {
    NSColor *colorOfPower[36];
}
@synthesize fontSize;
- (id)init{
    if (self = [super init]) {
        colorOfPower[0] = [NSColor colorWithRed:1.000 green:0.984 blue:0.792 alpha:1.0];
        colorOfPower[1] = [NSColor colorWithRed:0.973 green:0.800 blue:0.584 alpha:1.0];
        colorOfPower[2] = [NSColor colorWithRed:0.965 green:0.800 blue:0.800 alpha:1.0];
        colorOfPower[3] = [NSColor colorWithRed:0.980 green:0.800 blue:0.200 alpha:1.0];
        colorOfPower[4] = [NSColor colorWithRed:0.949 green:0.608 blue:0.200 alpha:1.0];
        
        colorOfPower[5] = [NSColor colorWithRed:0.345 green:0.704 blue:0.896 alpha:1.0];
        colorOfPower[6] = [NSColor colorWithRed:0.922 green:0.396 blue:0.396 alpha:1.0];
        colorOfPower[7] = [NSColor colorWithRed:0.894 green:0.402 blue:0.157 alpha:1.0];
        colorOfPower[8] = [NSColor colorWithRed:0.878 green:0.263 blue:0.506 alpha:1.0];
        
        colorOfPower[9] = [NSColor colorWithRed:0.808 green:0.596 blue:0.716 alpha:1.0];
        colorOfPower[10] = [NSColor colorWithRed:0.682 green:0.153 blue:0.353 alpha:1.0];
        colorOfPower[11] = [NSColor colorWithRed:0.541 green:0.676 blue:0.153 alpha:1.0];
        colorOfPower[12] = [NSColor colorWithRed:0.696 green:0.408 blue:0.180 alpha:1.0];
        
        colorOfPower[13] = [NSColor colorWithRed:0.608 green:0.400 blue:0.804 alpha:1.0];
        colorOfPower[14] = [NSColor colorWithRed:0.308 green:0.604 blue:0.396 alpha:1.0];
        colorOfPower[15] = [NSColor colorWithRed:0.490 green:0.222 blue:0.490 alpha:1.0];
        colorOfPower[16] = [NSColor colorWithRed:0.404 green:0.404 blue:0.704 alpha:1.0];
        
        colorOfPower[17] = [NSColor colorWithRed:0.182 green:0.233 blue:0.473 alpha:1.0];
        colorOfPower[18] =  [NSColor colorWithRed:0.271 green:0.196 blue:0.396 alpha:1.0];
        colorOfPower[19] =  [NSColor colorWithRed:0.425 green:0.249 blue:0.249 alpha:1.0];
        colorOfPower[20] = [NSColor colorWithRed:0.149 green:0.325 blue:0.137 alpha:1.0];
        
        colorOfPower[21] = [NSColor colorWithRed:0.973 green:0.800 blue:0.584 alpha:1.0];
        colorOfPower[22] = [NSColor colorWithRed:0.965 green:0.800 blue:0.800 alpha:1.0];
        colorOfPower[23] = [NSColor colorWithRed:0.980 green:0.800 blue:0.200 alpha:1.0];
        colorOfPower[24] = [NSColor colorWithRed:0.949 green:0.608 blue:0.200 alpha:1.0];
        
        colorOfPower[25] = [NSColor colorWithRed:0.345 green:0.704 blue:0.896 alpha:1.0];
        colorOfPower[26] = [NSColor colorWithRed:0.922 green:0.396 blue:0.396 alpha:1.0];
        colorOfPower[27] = [NSColor colorWithRed:0.894 green:0.402 blue:0.157 alpha:1.0];
        colorOfPower[28] = [NSColor colorWithRed:0.878 green:0.263 blue:0.506 alpha:1.0];
        
        colorOfPower[29] = [NSColor colorWithRed:0.808 green:0.596 blue:0.716 alpha:1.0];
        colorOfPower[30] = [NSColor colorWithRed:1.000 green:0.984 blue:0.792 alpha:1.0];
        colorOfPower[31] = [NSColor colorWithRed:0.973 green:0.800 blue:0.584 alpha:1.0];
        colorOfPower[32] = [NSColor colorWithRed:0.965 green:0.800 blue:0.800 alpha:1.0];
        
        colorOfPower[33] = [NSColor colorWithRed:0.980 green:0.800 blue:0.200 alpha:1.0];
        colorOfPower[34] = [NSColor colorWithRed:0.949 green:0.608 blue:0.200 alpha:1.0];
        colorOfPower[35] = [NSColor colorWithRed:0.345 green:0.704 blue:0.896 alpha:1.0];
        colorOfPower[36] = [NSColor colorWithRed:0.922 green:0.396 blue:0.396 alpha:1.0];
    }
    return self;
}
- (id)initWithFontSize:(CGFloat)size{
    self = [self init];
    fontSize = size;
    return self;
}
- (NSColor*)colorOfPower:(NSInteger)power{
    return colorOfPower[power];
}
@end
