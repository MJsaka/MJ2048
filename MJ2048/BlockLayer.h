//
//  BlockLayer.h
//  MJ2048
//
//  Created by MJsaka on 8/29/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BlockAttribute.h"

@interface BlockLayer : CALayer

@property (strong,nonatomic) BlockAttribute *blockAttr;
@property (assign,nonatomic) NSInteger posI;
@property (assign,nonatomic) NSInteger posJ;
@property (assign,nonatomic) NSInteger data;
@property (assign,nonatomic) NSInteger power;

@end
