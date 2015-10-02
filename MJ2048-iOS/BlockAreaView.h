//
//  BlockAreaView.h
//  MJ2048
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockAreaView : UIView

@property (assign,nonatomic) Boolean isDeath;
@property (assign,nonatomic) NSInteger margin;
@property (assign,nonatomic) NSInteger width;
@property (assign,nonatomic) NSInteger blockNum;
@end
