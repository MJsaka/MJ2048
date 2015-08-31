//
//  BlockAttribute.h
//  MJ2048
//
//  Created by MJsaka on 8/31/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BlockAttribute : NSObject

- (NSColor*)colorOfPower:(NSInteger)power;
- (NSDictionary*)stringAttr;
@end
