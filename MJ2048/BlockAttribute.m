//
//  BlockAttribute.m
//  MJ2048
//
//  Created by MJsaka on 8/31/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "BlockAttribute.h"

@implementation BlockAttribute {
    NSColor *colorOfPower[21];
    NSMutableDictionary *attrContent;
}
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
        attrContent = [NSMutableDictionary dictionary];
        [attrContent setObject:[NSFont fontWithName:@"SimHei" size:50] forKey:NSFontAttributeName];
    }
     return self;
}
- (NSColor*)colorOfPower:(NSInteger)power{
    return colorOfPower[power];
}
- (NSDictionary*)stringAttr{
    return attrContent;
}

@end
