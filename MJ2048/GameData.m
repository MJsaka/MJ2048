//
//  GameData.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "GameData.h"
//每个格子的数据结构
typedef struct blockNode{
    struct blockNode *nodeOnDir[4];
    NSInteger posi;
    NSInteger posj;
    NSInteger data;//格子内的数字
    NSInteger power;//直接记录幂次，以简化输出对应颜色的计算。
}blockNodeType;

@implementation GameData{
    blockNodeType *sider[4][4];
    blockNodeType inner[4][4];
    moveTableArray moveTable;
    boolTable refreshTable;
    boolTable mergeTable;
    boolTable generateTable;
    animationStatusType animationStatus;
    
    Boolean _isDeath;
    
    NSInteger _score;
    NSInteger _numTotal;
    
    NSInteger _highScore;
    NSInteger _topPower;
}

- (id)init{
    if (self = [super init]) {
        _isDeath = true;
        _score = 0;
        _numTotal = 0;
        _highScore = 0;
        _topPower = 0;
        
        animationStatus.aRefreshTable = &refreshTable;
        animationStatus.aMergeTable = &mergeTable;
        animationStatus.aGenerateTable = &generateTable;
        animationStatus.aMoveTable = &moveTable;
        
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                for (int k = 0; k < 4; ++k) {
                    inner[i][j].nodeOnDir[k] = nil;
                }
                inner[i][j].data = 0;
                inner[i][j].power = 0;
                inner[i][j].posi = i;
                inner[i][j].posj = j;
                
                moveTable[i][j].fromI = -1;
                moveTable[i][j].fromJ = -1;
                moveTable[i][j].toI = -1;
                moveTable[i][j].toJ = -1;
                moveTable[i][j].i = i;
                moveTable[i][j].j = j;
                mergeTable[i][j] = false;
                generateTable[i][j] = false;
                refreshTable[i][j] = false;
            }
        }//创建inner节点
        for (int i = 0; i < 4; ++i) {//横向
            for (int j = 0; j < 4; ++j) {//纵向
                if (i != 0) {//left
                    inner[i][j].nodeOnDir[DIR_LEFT] = &inner[i-1][j];
                }
                if (i != 3) {//right
                    inner[i][j].nodeOnDir[DIR_RIGHT] = &inner[i+1][j];
                }
                if (j != 3) {//up
                    inner[i][j].nodeOnDir[DIR_UP] = &inner[i][j+1];
                }
                if (j != 0) {//down
                    inner[i][j].nodeOnDir[DIR_DOWN] = &inner[i][j-1];
                }
            }
        }//建立inner各节点之间的链接
        for (int k = 0; k < 4; ++k) {
            sider[DIR_LEFT][k] = &inner[0][k];
            sider[DIR_RIGHT][k] = &inner[3][k];
            sider[DIR_UP][k] = &inner[k][3];
            sider[DIR_DOWN][k] = &inner[k][0];
        }//建立sider链接
        //读取存档
        [self readNSUserDefaults];
    }
    if (_isDeath){
        [self newGame];
    }
    return self;
}
- (NSInteger)dataAtRow:(NSInteger)row col:(NSInteger)col{
    return inner[row][col].data;
}
- (NSInteger)powerAtRow:(NSInteger)row col:(NSInteger)col{
    return inner[row][col].power;
}
-(NSInteger)currentScore{
    return _score;
}
-(NSInteger)highScore{
    return _highScore;
}
- (NSInteger)topPower{
    return _topPower;
}


- (void)newGame{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            inner[i][j].data = 0;
            inner[i][j].power = 0;
            
            moveTable[i][j].fromI = -1;
            moveTable[i][j].fromJ = -1;
            moveTable[i][j].toI = -1;
            moveTable[i][j].toJ = -1;
            mergeTable[i][j] = false;
            generateTable[i][j] = false;
            refreshTable[i][j] = false;
        }
    }
    NSInteger i = random() % 4;
    NSInteger j = random() % 4;
    NSInteger k = random() % 2 + 1;
    inner[i][j].data = k*2;
    inner[i][j].power = k;
    _numTotal = 1;
    _score = 0;
    _isDeath = false;
}
- (Boolean)isDeath{
    if (_isDeath) {
        return _isDeath;
    }
    if (_numTotal == 16){//检查游戏是否结束
        for (int dir = 0; dir <=1 ; ++dir) {//从左到右，从下到上各遍历一次
            int redir = 3 - dir;
            for (int i = 0; i < 4; ++i) {
                blockNodeType *n = sider[dir][i];
                blockNodeType *t = n->nodeOnDir[redir];
                do {
                    if (n->data == t->data) {
                        return _isDeath;
                    }else{
                        n = t;
                        t = n->nodeOnDir[redir];
                    }
                } while (t != nil);
            }
        }
        _isDeath = true;
    }
    return _isDeath;
}


- (Boolean)merge:(dirEnumType)dir
{
    if (_isDeath) {
        return false;
    }
    Boolean _isMerged = false;
    int redir = 3 - dir;
    //先做好运算
    for (int i = 0; i < 4; ++i) {
        blockNodeType *n = sider[dir][i];
        blockNodeType *t = n->nodeOnDir[redir];
        do{
            while (t != nil && n->data == 0) {
                n = t;
                t = n->nodeOnDir[redir];
            }//找到第一个不为0的格子
            while (t != nil && t->data == 0){
                t = t->nodeOnDir[redir];
            }//找到下一个不为0的格子
            if (t != nil && n->data == t->data) {
                t->data *= 2;
                t->power += 1;
                n->data = 0;
                n->power = 0;
                _score += t->data;
                _numTotal -= 1;
                if (t->power > _topPower){
                    _topPower = t->power;
                }
                if (_score > _highScore){
                    _highScore = _score;
                }
                _isMerged = true;
                mergeTable[t->posi][t->posj] = true;
                refreshTable[t->posi][t->posj] = true;
                refreshTable[n->posi][n->posj] = true;
                
                n = t->nodeOnDir[redir];
                if (n != nil) {
                    t = n->nodeOnDir[redir];
                }
            }else if(t != nil) {
                n = t;
                t = n->nodeOnDir[redir];
            }
        }while (n != nil && t != nil);
    }//再做移位
    return _isMerged;
}
- (Boolean)move:(dirEnumType)dir{
    if (_isDeath) {
        return false;
    }
    Boolean _isMoved = false;
    int redir = 3 - dir;
    for (int i = 0; i < 4; ++i) {
        blockNodeType *n = sider[dir][i];
        blockNodeType *t = n->nodeOnDir[redir];
        do{
            while (t != nil && n->data != 0) {
                n = t;
                t = n->nodeOnDir[redir];
            }//找到第一个为0的格子
            while (t != nil && t->data == 0) {
                t = t->nodeOnDir[redir];
            }//找到下一个不为0的格子
            if (t != nil) {
                n->data = t->data;
                n->power = t->power;
                t->data = 0;
                t->power = 0;
                [self addMoveAnimationFromI:t->posi fromJ:t->posj toI:n->posi toJ:n->posj];
                //n下一个必为0，n到t之间皆为0，t直接指向t的下一个
                n = n->nodeOnDir[redir];
                t = t->nodeOnDir[redir];
                _isMoved = true;
            }
        }while (n != nil && t != nil);
    }
    return _isMoved;
}
- (void)generate:(dirEnumType)dir{
    int redir = 3 - dir;
    //有移动，则从移动方向的后方新添一个格子。
    blockNodeType *n;
    do {//找到移动方向最后的一个为0的节点方可添加
        NSInteger i = random() % 4;
        n = sider[redir][i];
    }while (n->data != 0);
    NSInteger j = random() % 4;
    blockNodeType *t = n->nodeOnDir[dir];
    while (t != nil && t->data == 0 && j != 0){
        n = t;
        t = n->nodeOnDir[dir];
        --j;
    }
    NSInteger k = random() % 2 + 1;
    n->data = k*2;
    n->power = k;
    _numTotal += 1;
    generateTable[n->posi][n->posj] = true;
}

- (void)addMoveAnimationFromI:(NSInteger)fromI fromJ:(NSInteger)fromJ toI:(NSInteger)toI toJ:(NSInteger)toJ{
    moveTable[fromI][fromJ].toI = toI;
    moveTable[fromI][fromJ].toJ = toJ;
    moveTable[toI][toJ].fromI = fromI;
    moveTable[toI][toJ].fromJ = fromJ;
    if (mergeTable[fromI][fromJ]) {
        mergeTable[toI][toJ] = true;
        mergeTable[fromI][fromJ] = false;
    }
    if (generateTable[fromI][fromJ]) {
        generateTable[toI][toJ] = true;
        generateTable[fromI][fromJ] = false;
    }
}
- (animationStatusType*)animationStatus{
    return &animationStatus;
}

-(void)saveNSUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_highScore forKey:@"highScore"];
    [userDefaults setInteger:_topPower forKey:@"topPower"];
    if (!_isDeath) {
        [userDefaults setInteger:1 forKey:@"dataSaved"];
        [userDefaults setInteger:_score forKey:@"score"];
        [userDefaults setInteger:_numTotal forKey:@"numTotal"];
        [userDefaults setBool:_isDeath forKey:@"isDeath"];
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                NSString *dataString = [NSString stringWithFormat:@"d%d%d",i,j];
                NSString *powerString = [NSString stringWithFormat:@"p%d%d",i,j];
                [userDefaults setInteger:inner[i][j].data forKey:dataString];
                [userDefaults setInteger:inner[i][j].power forKey:powerString];
            }
        }
    }else {
        [userDefaults setInteger:0 forKey:@"dataSaved"];
    }
    [userDefaults synchronize];
}
-(void)readNSUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _highScore = [userDefaults integerForKey:@"highScore"];
    _topPower = [userDefaults integerForKey:@"topPower"];
    NSInteger dataSaved = [userDefaults integerForKey:@"dataSaved"];
    if (dataSaved) {
        _score = [userDefaults integerForKey:@"score"];
        _numTotal = [userDefaults integerForKey:@"numTotal"];
        _isDeath = [userDefaults boolForKey:@"isDeath"];
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                NSString *dataString = [NSString stringWithFormat:@"d%d%d",i,j];
                NSString *powerString = [NSString stringWithFormat:@"p%d%d",i,j];
                inner[i][j].data = [userDefaults integerForKey:dataString];
                inner[i][j].power = [userDefaults integerForKey:powerString];
            }
        }
    }    
}
@end
