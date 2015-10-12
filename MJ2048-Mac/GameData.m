//
//  GameData.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "GameData.h"

@implementation blockNodeType
@synthesize posi;
@synthesize posj;
@synthesize power;
@synthesize data;

@synthesize moveFromI;
@synthesize moveFromJ;
@synthesize moveToI;
@synthesize moveToJ;

@synthesize refresh;
@synthesize merge;
@synthesize generate;

-(void)setNodeOnDir:(dirEnumType)dir node:(blockNodeType*)node{
    nodeOnDir[dir] = node;
}
-(blockNodeType*)nodeOnDir:(dirEnumType)dir{
    return nodeOnDir[dir];
}
-(id)init{
    if (self = [super init]) {
        for (int i = 0; i < 4; ++i) {
            nodeOnDir[i] = nil;
        }
        data = 0;
        power = 0;
        posi = -1;
        posj = -1;
        moveFromI = -1;
        moveFromJ = -1;
        moveToI = -1;
        moveToJ = -1;
        merge = false;
        generate = false;
        refresh = false;
    }
    return self;
}
-(void)resetNodeStatus{
    data = 0;
    power = 0;
    moveFromI = -1;
    moveFromJ = -1;
    moveToI = -1;
    moveToJ = -1;
    merge = false;
    generate = false;
    refresh = false;
}

@end


@implementation GameData{
    NSArray *blockSider[4];
    NSInteger _blockNum;
    Boolean _isDeath;
    
    NSInteger _currentScore;
    NSInteger _currentPower;
    NSInteger _numTotal;
    
    NSInteger _highScore;
    NSInteger _topPower;
}

-(NSArray*)blockSider:(dirEnumType)dir{
    return blockSider[dir];
}

-(NSInteger)blockNum{
    return _blockNum;
}
-(void)changeBlockNum:(NSInteger)blockNum{
    if (_blockNum != blockNum){
        [self saveNSUserDefaults];
        _blockNum = blockNum;
        [self makeData];
    }
}

- (void)makeData{
    if (_blockNum < 3 || _blockNum > 6) {
        _blockNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"blockNum"];
        if (_blockNum < 3 || _blockNum > 6) {
            _blockNum = 4;
        }
    }
    _isDeath = true;
    _currentScore = 0;
    _currentPower = 0;
    _numTotal = 0;
    _highScore = 0;
    _topPower = 0;
    
    [self generateNode];
    [self readNSUserDefaults];
    if (_isDeath){
        [self newGame];
    }
}

- (id)init{
    if (self = [super init]) {
        [self makeData];
    }
    return self;
}
-(void)generateNode{
    NSMutableArray *leftSider = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *rightSider = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *upSider = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *downSider = [NSMutableArray arrayWithCapacity:0];
    //建立所有结点，并建立左右连接，左右边界
    blockNodeType *leftNode;
    blockNodeType *rightNode;
    for (int j = 0; j < _blockNum ; ++j){
        leftNode = [[blockNodeType alloc]init];
        leftNode.posi = 0;
        leftNode.posj = j;
        leftNode.data = pow(2, _blockNum*j);
        leftNode.power = _blockNum*j;
        [leftSider addObject:leftNode];
        for (int i = 1; i < _blockNum; ++i) {
            rightNode = [[blockNodeType alloc]init];
            rightNode.posi = i;
            rightNode.posj = j;
            rightNode.data = pow(2, _blockNum*j+i);
            rightNode.power = i+_blockNum*j;
            [leftNode setNodeOnDir:DIR_RIGHT node:rightNode];
            [rightNode setNodeOnDir:DIR_LEFT node:leftNode];
            leftNode = rightNode;
        }
        [rightSider addObject:rightNode];
    }
    //建立上下连接
    blockNodeType *downNode;
    blockNodeType *upNode;
    for (int j = 1; j < _blockNum; ++j) {
        downNode = [leftSider objectAtIndex:j-1];
        upNode = [leftSider objectAtIndex:j];
        for (int i = 0; i < _blockNum; ++i) {
            [downNode setNodeOnDir:DIR_UP node:upNode];
            [upNode setNodeOnDir:DIR_DOWN node:downNode];
            downNode = [downNode nodeOnDir:DIR_RIGHT];
            upNode = [upNode nodeOnDir:DIR_RIGHT];
        }
    }
    //建立上下边界
    downNode = [leftSider objectAtIndex:0];
    upNode = [leftSider objectAtIndex:_blockNum-1];
    for (int i = 0; i < _blockNum; ++i) {
        [downSider addObject:downNode];
        [upSider addObject:upNode];
        downNode = [downNode nodeOnDir:DIR_RIGHT];
        upNode = [upNode nodeOnDir:DIR_RIGHT];
    }
    
    blockSider[DIR_LEFT] = [NSArray arrayWithArray:leftSider];
    blockSider[DIR_RIGHT] = [NSArray arrayWithArray:rightSider];
    blockSider[DIR_UP] = [NSArray arrayWithArray:upSider];
    blockSider[DIR_DOWN] = [NSArray arrayWithArray:downSider];
}

-(NSInteger)currentScore{
    return _currentScore;
}
-(NSInteger)highScore{
    return _highScore;
}
- (NSInteger)topPower{
    return _topPower;
}
- (NSInteger)currentPower{
    return _currentPower;
}

- (void)newGame{
    for (int i = 0; i < _blockNum; ++i) {
        blockNodeType *node = blockSider[DIR_DOWN][i];
        for (int j = 0; j < _blockNum; ++j) {
            [node resetNodeStatus];
            node = [node nodeOnDir:DIR_UP];
        }
    }
    
    NSInteger i = random() % _blockNum;
    NSInteger j = random() % _blockNum;
    NSInteger k = random() % 2 + 1;
    blockNodeType *node = blockSider[DIR_DOWN][i];
    while(j>0) {
        node = [node nodeOnDir:DIR_UP];
        --j;
    }
    node.data = k*2;
    node.power = k;

    _numTotal = 1;
    _currentScore = 0;
    _currentPower = 0;
    _isDeath = false;
}
- (Boolean)isDeath{
    if (_isDeath) {
        return _isDeath;
    }
    if (_numTotal == _blockNum*_blockNum){//检查游戏是否结束
        for (int dir = 0; dir <=1 ; ++dir) {//从左到右，从下到上各遍历一次
            int redir = 3 - dir;
            for (int i = 0; i < _blockNum; ++i) {
                blockNodeType *n = blockSider[dir][i];
                blockNodeType *t = [n nodeOnDir:redir];
                do {
                    if (n.data == t.data) {
                        return _isDeath;
                    }else{
                        n = t;
                        t = [n nodeOnDir:redir];
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
    for (int i = 0; i < _blockNum; ++i) {
        blockNodeType *n = blockSider[dir][i];
        blockNodeType *t = [n nodeOnDir:redir];
        do{
            while (t != nil && n.data == 0) {
                n = t;
                t = [n nodeOnDir:redir];
            }//找到第一个不为0的格子
            while (t != nil && t.data == 0){
                t = [t nodeOnDir:redir];
            }//找到下一个不为0的格子
            if (t != nil && n.data == t.data) {
                t.data *= 2;
                t.power += 1;
                n.data = 0;
                n.power = 0;
                _currentScore += t.data;
                _numTotal -= 1;
                if (t.power > _topPower){
                    _topPower = t.power;
                }
                if (t.power > _currentPower) {
                    _currentPower = t.power;
                }
                if (_currentScore > _highScore){
                    _highScore = _currentScore;
                }
                _isMerged = true;
                t.merge = true;
                t.refresh = true;
                n.refresh = true;
                
                n = [t nodeOnDir:redir];
                if (n != nil) {
                    t = [n nodeOnDir:redir];
                }
            }else if(t != nil) {
                n = t;
                t = [n nodeOnDir:redir];
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
    for (int i = 0; i < _blockNum; ++i) {
        blockNodeType *n = blockSider[dir][i];
        blockNodeType *t = [n nodeOnDir:redir];
        do{
            while (t != nil && n.data != 0) {
                n = t;
                t = [n nodeOnDir:redir];
            }//找到第一个为0的格子
            while (t != nil && t.data == 0) {
                t = [t nodeOnDir:redir];
            }//找到下一个不为0的格子
            if (t != nil) {
                n.data = t.data;
                n.power = t.power;
                t.data = 0;
                t.power = 0;
                [self addMoveAnimationFromNode:t toNode:n];
                //n下一个必为0，n到t之间皆为0，t直接指向t的下一个
                n = [n nodeOnDir:redir];
                t = [t nodeOnDir:redir];
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
        NSInteger i = random() % _blockNum;
        n = blockSider[redir][i];
    }while (n.data != 0);
    NSInteger j = random() % _blockNum;
    while (j > 0 && [n nodeOnDir:dir].data == 0){
        --j;
        n = [n nodeOnDir:dir];
    }
    NSInteger k = random() % 2 + 1;
    n.data = k*2;
    n.power = k;
    _numTotal += 1;
    n.generate = true;
}

- (void)addMoveAnimationFromNode:(blockNodeType*)fromNode toNode:(blockNodeType*)toNode{
    fromNode.moveToI = toNode.posi;
    fromNode.moveToJ = toNode.posj;
    toNode.moveFromI = fromNode.posi;
    toNode.moveFromJ = fromNode.posj;
    
    if (fromNode.merge) {
        toNode.merge = true;
        fromNode.merge = false;
    }
    if (fromNode.generate) {
        toNode.generate = true;
        fromNode.generate = false;
    }
}


-(void)saveNSUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_blockNum forKey:@"blockNum"];

    NSMutableDictionary* currentData = [NSMutableDictionary dictionary];
    
    [currentData setValue:[NSNumber numberWithInteger:_highScore] forKey:@"highScore"];
    
    [currentData setValue:[NSNumber numberWithInteger:_topPower] forKey:@"topPower"];
    if (!_isDeath) {
        [currentData setValue:[NSNumber numberWithBool:true] forKey:@"dataSaved"];
        
        [currentData setValue:[NSNumber numberWithInteger:_currentScore] forKey:@"currentScore"];
        [currentData setValue:[NSNumber numberWithInteger:_currentPower] forKey:@"currentPower"];
        [currentData setValue:[NSNumber numberWithInteger:_numTotal] forKey:@"numTotal"];
        [currentData setValue:[NSNumber numberWithBool:_isDeath] forKey:@"isDeath"];
        for (int i = 0; i < _blockNum; ++i) {
            blockNodeType *node = blockSider[DIR_DOWN][i];
            for (int j = 0; j < _blockNum; ++j) {
                NSString *dataString = [NSString stringWithFormat:@"d%d%d",i,j];
                NSString *powerString = [NSString stringWithFormat:@"p%d%d",i,j];
                [currentData setValue:[NSNumber numberWithInteger:node.data] forKey:dataString];
                [currentData setValue:[NSNumber numberWithInteger:node.power] forKey:powerString];
                node = [node nodeOnDir:DIR_UP];
            }
        }
    }else{
        [currentData setValue:[NSNumber numberWithBool:false] forKey:@"dataSaved"];
    }
    
    NSString *blockDataString = [NSString stringWithFormat:@"blockData%ld",_blockNum];
    [userDefaults setPersistentDomain:currentData forName:blockDataString];
    [userDefaults synchronize];
}
-(void)readNSUserDefaults
{
//    NSLog(@"%@",NSHomeDirectory());
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *blockDataString = [NSString stringWithFormat:@"blockData%ld",_blockNum];
    NSDictionary* currentData = [userDefaults persistentDomainForName:blockDataString];
    
    _highScore = [[currentData valueForKey:@"highScore"] integerValue];
    _topPower = [[currentData valueForKey:@"topPower"] integerValue];
    
    NSInteger dataSaved = [[currentData valueForKey:@"dataSaved"] boolValue];
    if (dataSaved) {
        
        _currentScore = [[currentData valueForKey:@"currentScore"] integerValue];
        _currentPower = [[currentData valueForKey:@"currentPower"] integerValue];
        _numTotal = [[currentData valueForKey:@"numTotal"] integerValue];
        _isDeath = [[currentData valueForKey:@"isDeath"] boolValue];
        for (int i = 0; i < _blockNum; ++i) {
            blockNodeType *node = blockSider[DIR_DOWN][i];
            for (int j = 0; j < _blockNum; ++j) {
                NSString *dataString = [NSString stringWithFormat:@"d%d%d",i,j];
                NSString *powerString = [NSString stringWithFormat:@"p%d%d",i,j];
                node.data = [[currentData valueForKey:dataString] integerValue];
                node.power = [[currentData valueForKey:powerString] integerValue];
                node = [node nodeOnDir:DIR_UP];
            }
        }
    }    
}
@end
