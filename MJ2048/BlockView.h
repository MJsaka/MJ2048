//
//  BlockView.h
//  MJ2048
//
//  Created by MJsaka on 8/29/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BlockAttribute.h"

@interface BlockView : NSView

@property (strong,nonatomic) BlockAttribute *blockAttr;
@property (assign,nonatomic) NSInteger i;
@property (assign,nonatomic) NSInteger j;
@property (assign,nonatomic) NSInteger data;
@property (assign,nonatomic) NSInteger power;
@end
