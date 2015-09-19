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
//    CGColorRef color = [[blockAttr colorOfPower:power] CGColor];
//    self.backgroundColor = color;
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextFillRect(ctx,bounds);
    
    //Draw Number;
    if (data != 0) {
        [self setOpacity:1.0];
        
        CFStringRef string = CFStringCreateWithFormat ( kCFAllocatorDefault, nil, CFSTR("%ld") , (long)data );
        CTFontRef font = CTFontCreateWithName ( CFSTR("System"), 20, NULL);
        
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
        CGContextSetTextDrawingMode(ctx, kCGTextFillClip);
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


@implementation BlockAttribute {
    UIColor *colorOfPower[21];
}
- (id)init{
    if (self = [super init]) {
        colorOfPower[0] = [UIColor colorWithRed:1.000 green:0.984 blue:0.792 alpha:1.0];
        colorOfPower[1] = [UIColor colorWithRed:0.973 green:0.800 blue:0.584 alpha:1.0];
        colorOfPower[2] = [UIColor colorWithRed:0.965 green:0.800 blue:0.800 alpha:1.0];
        colorOfPower[3] = [UIColor colorWithRed:0.980 green:0.800 blue:0.200 alpha:1.0];
        colorOfPower[4] = [UIColor colorWithRed:0.949 green:0.608 blue:0.200 alpha:1.0];
        
        colorOfPower[5] = [UIColor colorWithRed:0.345 green:0.704 blue:0.896 alpha:1.0];
        colorOfPower[6] = [UIColor colorWithRed:0.922 green:0.396 blue:0.396 alpha:1.0];
        colorOfPower[7] = [UIColor colorWithRed:0.894 green:0.402 blue:0.157 alpha:1.0];
        colorOfPower[8] = [UIColor colorWithRed:0.878 green:0.263 blue:0.506 alpha:1.0];
        
        colorOfPower[9] = [UIColor colorWithRed:0.808 green:0.596 blue:0.716 alpha:1.0];
        colorOfPower[10] = [UIColor colorWithRed:0.682 green:0.153 blue:0.353 alpha:1.0];
        colorOfPower[11] = [UIColor colorWithRed:0.541 green:0.676 blue:0.153 alpha:1.0];
        colorOfPower[12] = [UIColor colorWithRed:0.696 green:0.408 blue:0.180 alpha:1.0];
        
        colorOfPower[13] = [UIColor colorWithRed:0.608 green:0.400 blue:0.804 alpha:1.0];
        colorOfPower[14] = [UIColor colorWithRed:0.308 green:0.604 blue:0.396 alpha:1.0];
        colorOfPower[15] = [UIColor colorWithRed:0.490 green:0.222 blue:0.490 alpha:1.0];
        colorOfPower[16] = [UIColor colorWithRed:0.404 green:0.404 blue:0.704 alpha:1.0];
        
        colorOfPower[17] = [UIColor colorWithRed:0.182 green:0.233 blue:0.473 alpha:1.0];
        colorOfPower[18] =  [UIColor colorWithRed:0.271 green:0.196 blue:0.396 alpha:1.0];
        colorOfPower[19] =  [UIColor colorWithRed:0.425 green:0.249 blue:0.249 alpha:1.0];
        colorOfPower[20] = [UIColor colorWithRed:0.149 green:0.325 blue:0.137 alpha:1.0];
    }
    return self;
}
- (UIColor*)colorOfPower:(NSInteger)power{
    return colorOfPower[power];
}

@end
