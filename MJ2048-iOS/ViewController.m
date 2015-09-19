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
#import "GameData.h"
#import "BlockAreaView.h"

@interface ViewController ()

@end

@implementation ViewController{
    BlockLayer *block[4][4];
    moveTableArray *moveTable;
    boolTable *refreshTable;
    boolTable *mergeTable;
    boolTable *generateTable;
    BlockAttribute *attr;
    IBOutlet UILabel *power;
    IBOutlet UILabel *bestTitle;
    IBOutlet UILabel *best;
    IBOutlet UILabel *scoreTitle;
    IBOutlet UILabel *score;
    IBOutlet GameData *gameData;
    IBOutlet BlockAreaView *blockAreaView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //     Do any additional setup after loading the view, typically from a nib.

    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).gameData = gameData;
    
    animationStatusType* aST = [gameData animationStatus];
    moveTable = aST->aMoveTable;
    refreshTable = aST->aRefreshTable;
    mergeTable = aST->aMergeTable;
    generateTable = aST->aGenerateTable;
    attr = [[BlockAttribute alloc]init];
    
    score.text = [NSString stringWithFormat:@"%ld",[gameData currentScore]];
    power.text = [NSString stringWithFormat:@"%.0f",pow(2, [gameData topPower])];
    power.backgroundColor = [attr colorOfPower:[gameData topPower]];
    bestTitle.backgroundColor = [attr colorOfPower:[gameData topPower]];
    best.backgroundColor = [attr colorOfPower:[gameData topPower]];
    best.text = [NSString stringWithFormat:@"%ld",[gameData highScore]];
    
//    CGRect blockAreaViewFrame = CGRectMake(self.view.bounds.size.width * 0.04, self.view.bounds.size.height * 0.3, self.view.bounds.size.width * 0.92, self.view.bounds.size.width * 0.92);
//    CGRect blockAreaViewFrame = CGRectMake(13, 170, 294, 294);
//    blockAreaView = [[BlockAreaView alloc]initWithFrame:blockAreaViewFrame];
//    [self.view addSubview:blockAreaView];
    blockAreaView.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0];
    blockAreaView.isDeath = [gameData isDeath];

    NSLog(@"%@",blockAreaView);
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwiped:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [blockAreaView addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwiped:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [blockAreaView addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwiped:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [blockAreaView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwiped:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [blockAreaView addGestureRecognizer:swipeRight];
    
    
    NSInteger l = ([blockAreaView frame].size.width - 50)/4;
//    NSInteger l = 61;
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            block[i][j] = [BlockLayer layer];
            [[blockAreaView layer] addSublayer:block[i][j]];
            
            block[i][j].data = [gameData dataAtRow:i col:j];
            block[i][j].power = [gameData powerAtRow:i col:j];
            block[i][j].blockAttr = attr;
            
            [block[i][j] setBounds:CGRectMake(0, 0, l, l)];
            [block[i][j] setAnchorPoint:CGPointMake(0.5, 0.5)];
            [block[i][j] setPosition:CGPointMake(10 + (l/2) + (10 + l) * i, 10 + (l/2) + (10 + l) * (3 - j))];
            block[i][j].geometryFlipped = true;
            [block[i][j] setNeedsDisplay];
        }
    }
}
- (IBAction)onSwiped:(UISwipeGestureRecognizer*)gesture{
    switch(gesture.direction){
        case UISwipeGestureRecognizerDirectionUp:
            [self moveControl:DIR_UP];
//            NSLog(@"UP");
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self moveControl:DIR_DOWN];
//            NSLog(@"Down");
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self moveControl:DIR_LEFT];
//            NSLog(@"Left");
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [self moveControl:DIR_RIGHT];
//            NSLog(@"right");
            break;
        default:
            break;
    }
}

- (IBAction)newGame:(id)sender{
    [gameData newGame];
    power.text = [NSString stringWithFormat:@"%.0f",pow(2, [gameData topPower])];
    power.backgroundColor = [attr colorOfPower:[gameData topPower]];
    score.text = [NSString stringWithFormat:@"%ld",[gameData currentScore]];
    bestTitle.backgroundColor = [attr colorOfPower:[gameData topPower]];
    best.backgroundColor = [attr colorOfPower:[gameData topPower]];
    best.text = [NSString stringWithFormat:@"%ld",[gameData highScore]];
    blockAreaView.isDeath = [gameData isDeath];
    [blockAreaView setNeedsDisplay];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            [[blockAreaView layer] addSublayer:block[i][j]];
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
        if ([gameData isDeath]) {
            blockAreaView.isDeath = [gameData isDeath];
            //隐藏Block
            for (int i = 0; i < 4; ++i) {
                for (int j = 0; j < 4; ++j) {
                    [block[i][j] removeFromSuperlayer];
                }
            }
            [blockAreaView setNeedsDisplay];
        }
    }
    power.text = [NSString stringWithFormat:@"%.0f",pow(2, [gameData topPower])];
    power.backgroundColor = [attr colorOfPower:[gameData topPower]];
    score.text = [NSString stringWithFormat:@"%ld",[gameData currentScore]];
    bestTitle.backgroundColor = [attr colorOfPower:[gameData topPower]];
    best.backgroundColor = [attr colorOfPower:[gameData topPower]];
    best.text = [NSString stringWithFormat:@"%ld",[gameData highScore]];
}

- (void)startMoveAnimation{
    NSInteger l = ([blockAreaView bounds].size.width - 50)/4;
//    NSInteger l = 61;
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            NSInteger toI = (*moveTable)[i][j].toI;
            NSInteger toJ = (*moveTable)[i][j].toJ;
            if (toI != -1 || toJ != -1) {
                CGPoint toPoint = CGPointMake(10 + (l/2) + (10 + l) * toI, 10 + (l/2) + ( 10 + l) * (3 - toJ));
//                NSLog(@"(%d,%d)-->(%ld,%ld)...Pos:(%f,%f)",i,j,toI,toJ,toPoint.x,toPoint.y);
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
    NSInteger l = ([blockAreaView bounds].size.width - 50)/4;
//    NSInteger l = 61;
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            moveElementType *c = &((*moveTable)[i][j]);
            if (c->toI == -1 && c->fromI != -1) {
                //找到没有出，只有进的block
                //f指向当前block的进入block，c指向当前block
                moveElementType *f;
                do{
                    f = &((*moveTable)[c->fromI][c->fromJ]);
                    CGPoint fromPoint = CGPointMake(10 + l/2 + (10 + l) * (f->i), 10 + l/2 + (10 + l) * (3 - (f->j)));
//                    NSLog(@"(%d,%d)<--(%ld,%ld)...Pos:(%f,%f)",i,j,f->fromI,f->fromJ,fromPoint.x,fromPoint.y);
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
