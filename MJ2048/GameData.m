//
//  GameData.m
//  MJ2048
//
//  Created by MJsaka on 8/26/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//

#import "GameData.h"
@implementation Node : NSObject

@synthesize data = _data;
@synthesize power = _power;

- (id)init{
    if (self = [super init]) {
        for (int i = 0; i < 4; ++i) {
            nodeOnDir[i] = nil;
            _data = 0;
            _power = 0;
        }
    }
    return self;
}

-(void) setNodeOnDir:(dirEnumType)dir withNode:(Node *)node{
    nodeOnDir[dir] = node;
}
-(Node *)nodeOnDir:(dirEnumType)dir{
    return nodeOnDir[dir];
}

@end



@implementation GameData{
    Node *sider[4][4];
    Node *inner[4][4];
    
    Boolean _isPlaying;
    
    NSInteger _score;
    NSInteger _numTotal;
    
    NSInteger _highScore;
    NSInteger _topPower;
}

- (id)init{
    if (self = [super init]) {
        _isPlaying = false;
        _score = 0;
        _numTotal = 0;
        _highScore = 0;
        _topPower = 0;
        
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                inner[i][j] = [[Node alloc]init];
                inner[i][j].data = pow(2, 4*i+j);
                inner[i][j].power = 4*i+j;
            }
        }//创建inner节点
        for (int i = 0; i < 4; ++i) {//横向
            for (int j = 0; j < 4; ++j) {//纵向
                if (i != 0) {//left
                    [inner[i][j] setNodeOnDir:DIR_LEFT withNode:inner[i-1][j]];
                }
                if (i != 3) {//right
                    [inner[i][j] setNodeOnDir:DIR_RIGHT withNode:inner[i+1][j]];
                }
                if (j != 3) {//up
                    [inner[i][j] setNodeOnDir:DIR_UP withNode:inner[i][j+1]];
                }
                if (j != 0) {//down
                    [inner[i][j] setNodeOnDir:DIR_DOWN withNode:inner[i][j-1]];
                }
            }
        }//建立inner各节点之间的链接
        for (int k = 0; k < 4; ++k) {
            sider[DIR_LEFT][k] = inner[0][k];
            sider[DIR_RIGHT][k] = inner[3][k];
            sider[DIR_UP][k] = inner[k][3];
            sider[DIR_DOWN][k] = inner[k][0];
        }//建立sider链接
        //读取存档
//        [self readNSUserDefaults];
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
        }
    }
    NSInteger i = random() % 4;
    NSInteger j = random() % 4;
    NSInteger k = random() % 2 + 1;
    inner[i][j].data = k*2;
    inner[i][j].power = k;
    _numTotal = 1;
    _score = 0;
    _isPlaying = true;
}
- (Boolean)isDeath{
    if (_numTotal < 16) {
        return false;
    }
    if (!_isPlaying) {
        return true;
    }
    for (int dir = 0; dir <=1 ; ++dir) {//从左到右，从下到上各遍历一次
        int redir = 3 - dir;
        for (int i = 0; i < 4; ++i) {
            Node *n = sider[dir][i];
            Node *t = [n nodeOnDir:redir];
            do {
                if (n.data == t.data) {
                    return false;
                }else{
                    n = t;
                    t = [n nodeOnDir:redir];
                }
            } while (t != nil);
        }
    }
    _isPlaying = false;
    return true;
}

- (Boolean)isNewScoreRecord{
    if (_score > _highScore){
        _highScore = _score;
        return true;
    }else {
        return false;
    }
}
- (Boolean)isNewPowerRecord{
    Boolean b = false;
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            if (inner[i][j].power > _topPower){
                _topPower = inner[i][j].power;
                b = true;
            }
        }
    }
    return b;
}
- (Boolean)move:(dirEnumType)dir
{
    if (!_isPlaying) {
        return false;
    }
    Boolean _isMoved = false;
    int redir = 3 - dir;
    //先做好运算
    for (int i = 0; i < 4; ++i) {
        Node *n = sider[dir][i];
        Node *t = [n nodeOnDir:redir];
        do{
            while (t != nil && n.data == 0) {
                n = t;
                t = [n nodeOnDir:redir];
            }//找到第一个不为0的格子
            while (t != nil && t.data == 0){
                t = [t nodeOnDir:redir];
            }//找到下一个不为0的格子
            if (t != nil && n.data == t.data) {
                n.data *= 2;
                n.power += 1;
                t.data = 0;
                t.power = 0;
                _score += n.data;
                _numTotal -= 1;
                _isMoved = true;
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
    for (int i = 0; i < 4; ++i) {
        Node *n = sider[dir][i];
        Node *t = [n nodeOnDir:redir];
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
                //n下一个必为0，n到t之间皆为0，t直接指向t的下一个
                n = [n nodeOnDir:redir];
                t = [t nodeOnDir:redir];
                _isMoved = true;
            }
        }while (n != nil && t != nil);
    }
    if (_isMoved) {//有移动，则从移动方向的后方新添一个格子。
        Node *n;
        do {//找到移动方向最后的一个为0的节点方可添加
            NSInteger i = random() % 4;
            n = sider[redir][i];
        }while (n.data != 0);
        NSInteger j = random() % 4;
        while ([n nodeOnDir:dir].data == 0 && j != 0){
            n = [n nodeOnDir:dir];
            --j;
        }
        NSInteger k = random() % 2 + 1;
        n.data = k*2;
        n.power = k;
        _numTotal += 1;
        return true;
    }else{
        return false;
    }
}
-(void)saveNSUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_highScore forKey:@"highScore"];
    [userDefaults setInteger:_topPower forKey:@"topPower"];
    if (_isPlaying) {
        [userDefaults setInteger:1 forKey:@"dataSaved"];
        [userDefaults setInteger:_score forKey:@"score"];
        [userDefaults setInteger:_numTotal forKey:@"numTotal"];
        [userDefaults setBool:_isPlaying forKey:@"isPlaying"];
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
        _isPlaying = [userDefaults boolForKey:@"isPlaying"];
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
