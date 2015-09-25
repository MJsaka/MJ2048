//
//  GameData.h
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Foundation/Foundation.h>
//移动方向
typedef enum moveDir{
    DIR_LEFT = 0,
    DIR_DOWN = 1,
    DIR_UP = 2,
    DIR_RIGHT = 3
} dirEnumType;
//记录每个格子的移动情况，用来实现动画
typedef struct moveElement{
    NSInteger fromI;
    NSInteger fromJ;
    NSInteger toI;
    NSInteger toJ;
    NSInteger i;
    NSInteger j;
}moveElementType;
typedef moveElementType moveTableArray[4][4];
typedef Boolean boolTable[4][4];

typedef struct animationStatus{
    moveTableArray* aMoveTable;
    boolTable* aRefreshTable;//记录合并了的相关格子，移动前先刷新
    boolTable* aMergeTable;//记录需要产生合并动画的格子
    boolTable* aGenerateTable;//记录需要产生生成动画的格子
}animationStatusType;

@interface GameData : NSObject

- (animationStatusType*)animationStatus;

- (NSInteger)currentScore;//总分。
- (NSInteger)highScore;//历史最高分
- (NSInteger)topPower;//历史最大格子数值

- (NSInteger)dataAtRow:(NSInteger)row col:(NSInteger)col;
- (NSInteger)powerAtRow:(NSInteger)row col:(NSInteger)col;


- (Boolean)merge:(dirEnumType)dir;
- (Boolean)move:(dirEnumType)dir;
- (void)generate:(dirEnumType)dir;
- (Boolean)isDeath;

- (void)newGame;
- (void)saveNSUserDefaults;
@end