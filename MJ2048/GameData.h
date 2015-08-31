//
//  GameData.h
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum moveDir{
    DIR_LEFT = 0,
    DIR_DOWN = 1,
    DIR_UP = 2,
    DIR_RIGHT = 3
} dirEnumType;

@interface Node : NSObject
{
    Node *nodeOnDir[4];//上下左右格子的指针
}

@property (assign,nonatomic) NSInteger posi;
@property (assign,nonatomic) NSInteger posj;
@property (assign,nonatomic) NSInteger data;//格子内的数字
@property (assign,nonatomic) NSInteger power;//直接记录幂次，以简化输出对应颜色的计算。

-(void)setNodeOnDir:(dirEnumType)dir withNode:(Node *)node;
-(Node *)nodeOnDir:(dirEnumType)dir;
@end

@interface GameData : NSObject

- (NSInteger)currentScore;//记录总分。
- (NSInteger)highScore;
- (NSInteger)topPower;

- (NSInteger)dataAtRow:(NSInteger)row col:(NSInteger)col;
- (NSInteger)powerAtRow:(NSInteger)row col:(NSInteger)col;

- (Boolean)move:(dirEnumType)dir sender:(id)sender;
- (Boolean)isDeath;
- (Boolean)isNewScoreRecord;
- (Boolean)isNewPowerRecord;

- (void)newGame;
- (void)saveNSUserDefaults;
@end