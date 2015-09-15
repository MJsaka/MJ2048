//
//  GameData.h
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum moveDir{
    DIR_LEFT = 0,
    DIR_DOWN = 1,
    DIR_UP = 2,
    DIR_RIGHT = 3
} dirEnumType;

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
    boolTable* aRefreshTable;
    boolTable* aMergeTable;
    boolTable* aGenerateTable;
}animationStatusType;

@interface Node : NSObject

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
- (animationStatusType*)animationStatus;
//
//
//- (Boolean)needRefreshBeforeAnimationForI:(NSInteger)forI forJ:(NSInteger)forJ;
//- (void)resetRefreshStatus;
//- (NSInteger)ToIMovedFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ;
//- (NSInteger)ToJMovedFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ;
//- (Boolean)hasMergeAnimationForI:(NSInteger)forI forJ:(NSInteger)forJ;
//- (void)resetMergeStatusForI:(NSInteger)forI forJ:(NSInteger)forJ;
//- (Boolean)hasGenerateAnimationForI:(NSInteger)forI forJ:(NSInteger)forJ;
//- (void)resetGenerateStatusForI:(NSInteger)forI forJ:(NSInteger)forJ;
//

- (Boolean)merge:(dirEnumType)dir;
- (Boolean)move:(dirEnumType)dir;
- (void)generate:(dirEnumType)dir;
- (Boolean)isDeath;
- (Boolean)isNewScoreRecord;
- (Boolean)isNewPowerRecord;

- (void)newGame;
- (void)saveNSUserDefaults;
@end