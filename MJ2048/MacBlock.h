//
//  MacBlockLayer.h
//  MJ2048
//
//  Created by MJsaka on 8/29/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MacBlockAttribute : NSObject

- (NSColor*)colorOfPower:(NSInteger)power;
- (NSDictionary*)stringAttr;
@end

@interface MacBlockLayer : CALayer

@property (strong,nonatomic) MacBlockAttribute *blockAttr;
@property (assign,nonatomic) NSInteger data;
@property (assign,nonatomic) NSInteger power;

@end
