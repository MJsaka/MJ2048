//
//  BlockAreaView.m
//  MJ2048
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "BlockAreaView.h"

@implementation BlockAreaView

@synthesize blockNum;
@synthesize margin;
@synthesize width;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
        for (int i = 0; i < blockNum; ++i) {
            for (int j = 0; j < blockNum; ++j) {
                CGRect brect = CGRectMake(margin + (margin + width) * i, margin + (width + margin) * (blockNum-1 - j),width,width);
                CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.000, 0.984 ,0.792, 1.0);
                UIRectFill(brect);
            }
        }
}
@end
