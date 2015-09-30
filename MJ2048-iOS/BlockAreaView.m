//
//  BlockAreaView.m
//  MJ2048
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "BlockAreaView.h"

@implementation BlockAreaView{
    UILabel* gameOverLabel;
}
@synthesize isDeath;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if(isDeath){
        if (gameOverLabel == nil) {
            gameOverLabel = [[UILabel alloc] initWithFrame:rect];
        }
        gameOverLabel.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0];
        gameOverLabel.textAlignment = NSTextAlignmentCenter;
        gameOverLabel.text = @"GAME OVER";
        gameOverLabel.font = [UIFont boldSystemFontOfSize:40];
        [self addSubview:gameOverLabel];
    }else{
        NSInteger l = (rect.size.width - 50)/4;
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                CGRect brect = CGRectMake(10 + i * (l+10), 10 + j * (l+10), l, l);
                CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.000, 0.984 ,0.792, 1.0);
                UIRectFill(brect);
            }
        }
        [gameOverLabel removeFromSuperview];
    }
}
@end
