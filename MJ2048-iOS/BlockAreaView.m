//
//  BlockAreaView.m
//  MJ2048
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "BlockAreaView.h"
@import CoreText;

@implementation BlockAreaView
@synthesize isDeath;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if(!isDeath){
        NSInteger l = (rect.size.width - 50)/4;
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                CGRect brect = CGRectMake(10 + i * (l+10), 10 + j * (l+10), l, l);
                CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.000, 0.984 ,0.792, 1.0);
                UIRectFill(brect);
            }
        }
    }else {
        self.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0];
        CFStringRef string = CFStringCreateWithFormat ( kCFAllocatorDefault, nil, CFSTR("GAME OVER"));
        CTFontRef font = CTFontCreateWithName ( CFSTR("SimHei"), 40, NULL);
        
        CFStringRef keys[] = { kCTFontAttributeName };
        CFTypeRef values[] = { font };
        
        CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys, (const void**)&values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
        CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
        CFRelease(string);
        CFRelease(attributes);
        CTLineRef line = CTLineCreateWithAttributedString(attrString);
        
        // Set text position and draw the line into the graphics context
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect lrect = CTLineGetImageBounds(line , ctx);
        CGPoint point;
        point.x = (rect.size.width - lrect.size.width)/2;
        point.y = (rect.size.height - lrect.size.height)/2;
        
        CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
        CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,rect.size.height);
        CGContextConcatCTM(ctx, flipVertical);
    
        CGContextSetTextPosition(ctx, point.x , point.y);
        CTLineDraw(line, ctx);
        CFRelease(line);
    }
}
@end
