//
//  GameAreaView.m
//  MJ2048
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "GameAreaView.h"

@implementation GameAreaView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [super drawRect:rect];
//    CGRect bounds = [self bounds];
    
//    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0.824, 0.824 ,0.824, 1.0);
//    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
//    UIRectFill(rect);
    NSInteger l = (rect.size.width - 50)/4;

    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            CGRect brect = CGRectMake(10 + i * (l+10), 10 + j * (l+10), l, l);
            CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.000, 0.984 ,0.792, 1.0);
            UIRectFill(brect);
            ;
//            CGContextFillRect(UIGraphicsGetCurrentContext(), brect);
        }
    }
}

@end
