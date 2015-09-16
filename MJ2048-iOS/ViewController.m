//
//  ViewController.m
//  MJ2048-iOS
//
//  Created by MJsaka on 9/15/15.
//  Copyright (c) 2015 MJsaka. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "BlockLayer-iOS.h"

@interface ViewController ()

@end

@implementation ViewController{
    BlockLayer *block[4][4];
    moveTableArray *moveTable;
    boolTable *refreshTable;
    boolTable *mergeTable;
    boolTable *generateTable;
    IBOutlet GameData *gameData;
    GameAreaView *gameAreaView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).gameData = gameData;
    BlockAttribute *attr = [[BlockAttribute alloc]init];
    
    animationStatusType* aST = [gameData animationStatus];
    moveTable = aST->aMoveTable;
    refreshTable = aST->aRefreshTable;
    mergeTable = aST->aMergeTable;
    generateTable = aST->aGenerateTable;
    
    CGRect gameAreaViewFrame = CGRectMake((self.view.bounds.size.width - 290)/2, 150, 290, 290);
    gameAreaView = [[GameAreaView alloc]initWithFrame:gameAreaViewFrame];
    gameAreaView.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0];
    [gameAreaView setNeedsDisplay];
    [self.view addSubview:gameAreaView];
    
    NSInteger l = ([gameAreaView bounds].size.width - 50)/4;
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            block[i][j] = [BlockLayer layer];
            [[gameAreaView layer] addSublayer:block[i][j]];
            
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            block[i][j].blockAttr = attr;
            
            [block[i][j] setBounds:CGRectMake(0, 0, l, l)];
            [block[i][j] setPosition:CGPointMake(40 + (10 + l)*i, 40 + (10 + l)*(3-j))];
            [block[i][j] setAnchorPoint:CGPointMake(0.5, 0.5)];
            block[i][j].geometryFlipped = true;
            [block[i][j] setNeedsDisplay];
        }
    }
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwiped:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [gameAreaView addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwiped:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [gameAreaView addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwiped:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [gameAreaView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwiped:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [gameAreaView addGestureRecognizer:swipeRight];
    
    [gameAreaView setNeedsDisplay];
//     Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)onSwiped:(UISwipeGestureRecognizer*)gesture{
    switch(gesture.direction){
        case UISwipeGestureRecognizerDirectionUp:
            [self moveControl:DIR_UP];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self moveControl:DIR_DOWN];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self moveControl:DIR_LEFT];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [self moveControl:DIR_RIGHT];
            break;
        default:
            break;
    }
}

- (IBAction)newGame:(id)sender{
    [gameData newGame];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            [[gameAreaView layer] addSublayer:block[i][j]];
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            [block[i][j] setNeedsDisplay];
            [block[i][j] setHidden:NO];
        }
    }

}
- (void)moveControl:(dirEnumType)dir{
    if([gameData merge:dir]){
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                if ((*refreshTable)[i][j]) {
                    block[i][j].data = [gameData dataAtRow:i col:j];
                    block[i][j].power = [gameData powerAtRow:i col:j];
                    (*refreshTable)[i][j] = false;
                    [block[i][j] setNeedsDisplay];
                }
            }
        }
    }
    if([gameData move:dir]){
        [self startMoveAnimation];
        [gameData generate:dir];
//        gameView.currentScore = [gameData currentScore];
        if ([gameData isDeath]) {
//            gameView.isDeath = [gameData isDeath];
//            gameView.isNewScore = [gameData isNewScoreRecord];
//            gameView.isNewPower = [gameData isNewPowerRecord];
//            gameView.highScore = [gameData highScore];
//            gameView.topPower = [gameData topPower];
            //隐藏Block
            for (int i = 0; i < 4; ++i) {
                for (int j = 0; j < 4; ++j) {
                    [block[i][j] removeFromSuperlayer];
                }
            }
        }
//        [gameView setNeedsDisplay:YES];
    }
}

- (void)startMoveAnimation{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            NSInteger toI = (*moveTable)[i][j].toI;
            NSInteger toJ = (*moveTable)[i][j].toJ;
            if (toI != -1 || toJ != -1) {
                CGPoint toPoint = CGPointMake(40 + toI * 70, 40 + (3-toJ) * 70);
                [CATransaction begin];
                [CATransaction setValue:[NSNumber numberWithFloat:0.3f] forKey: kCATransactionAnimationDuration];
                [block[i][j] setPosition:toPoint];
                [CATransaction commit];
            }
        }
    }
    [self adjustBlock];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startMergeAnimation) userInfo:nil repeats:NO];
}

- (void)startMergeAnimation{
    
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            if ((*mergeTable)[i][j]) {
                CABasicAnimation *mergeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                mergeAnimation.duration = 0.3;
                mergeAnimation.autoreverses = NO;
                mergeAnimation.repeatCount = 0;
                mergeAnimation.removedOnCompletion = NO;
                mergeAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                mergeAnimation.fillMode = kCAFillModeBackwards;
                mergeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
                mergeAnimation.toValue = [NSNumber numberWithFloat:1.15];
                [block[i][j] addAnimation:mergeAnimation forKey:@"transform"];
                (*mergeTable)[i][j] = false;
            }
            if ((*generateTable)[i][j]) {
                block[i][j].data = [gameData dataAtRow:i col:j];
                block[i][j].power = [gameData powerAtRow:i col:j];
                [block[i][j] setNeedsDisplay];
                
                CABasicAnimation *generateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                generateAnimation.duration = 0.3;
                generateAnimation.autoreverses = NO;
                generateAnimation.repeatCount = 0;
                generateAnimation.removedOnCompletion = NO;
                generateAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                generateAnimation.fillMode = kCAFillModeBackwards;
                generateAnimation.fromValue = [NSNumber numberWithFloat:0];
                generateAnimation.toValue = [NSNumber numberWithFloat:1.0];
                [block[i][j] addAnimation:generateAnimation forKey:@"transform"];
                (*generateTable)[i][j] = false;
            }
        }
    }
}


- (void)adjustBlock{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            moveElementType *c = &((*moveTable)[i][j]);
            if (c->toI == -1 && c->fromI != -1) {
                //找到没有出，只有进的block
                //f指向当前block的进入block，c指向当前block
                moveElementType *f;
                do{
                    f = &((*moveTable)[c->fromI][c->fromJ]);
                    CGPoint fromPoint = CGPointMake(40 + f->i * 70, 40 + (3-f->j) * 70);
                    
                    [CATransaction begin];
                    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey: kCATransactionDisableActions];
                    [block[c->i][c->j] setPosition:fromPoint];
                    [CATransaction commit];
                    
                    BlockLayer* bl = block[c->i][c->j];
                    block[c->i][c->j] = block[f->i][f->j];
                    block[f->i][f->j] = bl;
                    
                    c->fromI = -1;
                    c->fromJ = -1;
                    f->toI = -1;
                    f->toJ = -1;
                    c = f;
                }while (c->fromI != -1);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
