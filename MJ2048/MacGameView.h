//
//  MacGameAreaView.h
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface MacGameAreaView : NSView{
    IBOutlet id interface;
}
@property (strong,nonatomic) NSMutableDictionary *attrGameOver;
@property (assign,nonatomic) Boolean isDeath;
@property (assign,nonatomic) NSInteger blockNum;

@end

@interface MacInfoAreaView : NSView

@end

@interface MacInfoAreaLabelView : NSView
//{
//    NSColor *_backgroundColor;
//}
@property(copy,nonatomic) NSColor *backgroundColor;
@end