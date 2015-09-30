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

//每个格子的数据结构
@interface blockNodeType : NSObject{
    blockNodeType *nodeOnDir[4];
}
@property (assign,nonatomic) NSInteger posi;
@property (assign,nonatomic) NSInteger posj;
@property (assign,nonatomic) NSInteger data;//格子内的数字
@property (assign,nonatomic) NSInteger power;//直接记录幂次，以简化输出对应颜色的计算。

@property (assign,nonatomic) NSInteger moveFromI;
@property (assign,nonatomic) NSInteger moveFromJ;
@property (assign,nonatomic) NSInteger moveToI;
@property (assign,nonatomic) NSInteger moveToJ;

@property (assign,nonatomic) Boolean refresh;//记录该格子移动前是否要刷新
@property (assign,nonatomic) Boolean merge;//记录该格子是否需要产生合并动画
@property (assign,nonatomic) Boolean generate;//记录该格子是否需要产生生成动画
-(void)setNodeOnDir:(dirEnumType)dir node:(blockNodeType*)node;
-(blockNodeType*)nodeOnDir:(dirEnumType)dir;
-(void)resetNodeStatus;
@end

@interface GameData : NSObject

- (NSArray*)blockSider:(dirEnumType)dir;
- (NSInteger)currentScore;//总分。
- (NSInteger)highScore;//历史最高分
- (NSInteger)topPower;//历史最大格子数值
- (NSInteger)blockNum;
- (void)setBlockNum:(NSInteger)blockNum;

//- (NSInteger)dataAtRow:(NSInteger)row col:(NSInteger)col;
//- (NSInteger)powerAtRow:(NSInteger)row col:(NSInteger)col;

- (Boolean)merge:(dirEnumType)dir;
- (Boolean)move:(dirEnumType)dir;
- (void)generate:(dirEnumType)dir;
- (Boolean)isDeath;

- (void)newGame;
- (void)saveNSUserDefaults;
@end