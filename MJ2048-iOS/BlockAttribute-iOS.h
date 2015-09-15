//
//  BlockAttribute.h
//  MJ2048
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockAttribute : NSObject

- (UIColor*)colorOfPower:(NSInteger)power;
- (NSDictionary*)stringAttr;
@end
