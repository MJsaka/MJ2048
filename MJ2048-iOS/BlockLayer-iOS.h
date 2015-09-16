//
//  BlockLayer-iOS.h
//  MJ2048
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BlockAttribute-iOS.h"

@interface BlockLayer : CALayer

@property (strong,nonatomic) BlockAttribute *blockAttr;
@property (assign,nonatomic) NSInteger data;
@property (assign,nonatomic) NSInteger power;

@end
