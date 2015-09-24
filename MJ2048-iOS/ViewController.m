//
//  ViewController.m
//  MJ2048
//
//  Created by MJsaka on 15/9/24.
//  Copyright © 2015年 MJsaka. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "GameData.h"
#import "BlockAttr.h"
#import "BlockAreaView.h"

@interface ViewController ()

@end

@implementation ViewController{
    UILabel *block[4][4];
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
    BlockAreaView *blockAreaView;
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
    
    [self refreshScoreArea];
    
    CGRect blockAreaViewFrame = CGRectMake(self.view.bounds.size.width * 0.04, self.view.bounds.size.height * 0.3, self.view.bounds.size.width * 0.92, self.view.bounds.size.width * 0.92);
    blockAreaView = [[BlockAreaView alloc]initWithFrame:blockAreaViewFrame];
    [self.view addSubview:blockAreaView];
    blockAreaView.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0];
    blockAreaView.isDeath = [gameData isDeath];
    
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
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            CGRect frame = CGRectMake(10 + (10 + l) * i, 10 + (10 + l) * (3 - j),l,l);
            block[i][j] = [[UILabel alloc]initWithFrame:frame];
            block[i][j].font = [UIFont fontWithName:@"Arial" size:20];
            block[i][j].textAlignment = NSTextAlignmentCenter;
            [self refreshBlockForI:i forJ:j];
            [blockAreaView addSubview:block[i][j]];
        }
    }
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
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if (size.height > size.width) {
        CGRect blockAreaViewFrame = CGRectMake(size.width * 0.04, size.height * 0.3, size.width * 0.92, size.width * 0.92);
        blockAreaView.frame = blockAreaViewFrame;
    }else{
        CGRect blockAreaViewFrame = CGRectMake(size.width * 0.4, size.height * 0.04, size.height * 0.92, size.height * 0.92);
        blockAreaView.frame = blockAreaViewFrame;
    }
}
- (void)refreshBlockForI:(NSInteger)i forJ:(NSInteger)j{
    if ([gameData powerAtRow:i col:j] != 0) {
        block[i][j].text = [NSString stringWithFormat:@"%ld",[gameData dataAtRow:i col:j]];
        block[i][j].backgroundColor = [attr colorOfPower:[gameData powerAtRow:i col:j]];
        block[i][j].alpha = 1;
    }else{
        block[i][j].alpha = 0;
    }
}
- (void)refreshScoreArea{
    power.text = [NSString stringWithFormat:@"%.0f",pow(2, [gameData topPower])];
    power.backgroundColor = [attr colorOfPower:[gameData topPower]];
    score.text = [NSString stringWithFormat:@"%ld",[gameData currentScore]];
    bestTitle.backgroundColor = [attr colorOfPower:[gameData topPower]];
    best.backgroundColor = [attr colorOfPower:[gameData topPower]];
    best.text = [NSString stringWithFormat:@"%ld",[gameData highScore]];
}

- (IBAction)newGame{
    [gameData newGame];
    [self refreshScoreArea];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            [self refreshBlockForI:i forJ:j];
            [blockAreaView addSubview:block[i][j]];
        }
    }
    blockAreaView.isDeath = [gameData isDeath];
    [blockAreaView setNeedsDisplay];
}
- (void)gameOver{
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            [block[i][j] removeFromSuperview];
        }
    }
    blockAreaView.isDeath = [gameData isDeath];
    [blockAreaView setNeedsDisplay];
}
- (void)moveControl:(dirEnumType)dir{
    Boolean merged = NO;
    if([gameData merge:dir]){
        merged = YES;
        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                if ((*refreshTable)[i][j]) {
                    [self refreshBlockForI:i forJ:j];
                    (*refreshTable)[i][j] = false;
                }
            }
        }
    }
    if([gameData move:dir]){
        [self startMoveAnimation];
        [gameData generate:dir];
        if ([gameData isDeath]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Game Over" message:@"Try again?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* tryAgainAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){[self newGame];}];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){[self gameOver];}];
            [alert addAction:cancelAction];
            [alert addAction:tryAgainAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    if (merged) {
        [self refreshScoreArea];
    }
}

- (void)startMoveAnimation{
    NSInteger l = ([blockAreaView bounds].size.width - 50)/4;
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            NSInteger toI = (*moveTable)[i][j].toI;
            NSInteger toJ = (*moveTable)[i][j].toJ;
            if (toI != -1 || toJ != -1) {
                CGRect toRect = CGRectMake(10 + (10 + l) * toI, 10 + ( 10 + l) * (3 - toJ),l,l);
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){block[i][j].frame = toRect;} completion:NULL];
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
                [[block[i][j] layer] addAnimation:mergeAnimation forKey:@"transform"];
                (*mergeTable)[i][j] = false;
            }
            if ((*generateTable)[i][j]) {
                block[i][j].text = [NSString stringWithFormat:@"%ld",(long)[gameData dataAtRow:i col:j]];
                block[i][j].backgroundColor = [attr colorOfPower:[gameData powerAtRow:i col:j]];
                block[i][j].alpha = 1;

                CABasicAnimation *generateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                generateAnimation.duration = 0.3;
                generateAnimation.autoreverses = NO;
                generateAnimation.repeatCount = 0;
                generateAnimation.removedOnCompletion = NO;
                generateAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                generateAnimation.fillMode = kCAFillModeBackwards;
                generateAnimation.fromValue = [NSNumber numberWithFloat:0];
                generateAnimation.toValue = [NSNumber numberWithFloat:1.0];
                [[block[i][j] layer] addAnimation:generateAnimation forKey:@"transform"];
                (*generateTable)[i][j] = false;
            }
        }
    }
}


- (void)adjustBlock{
    NSInteger l = ([blockAreaView bounds].size.width - 50)/4;
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            moveElementType *c = &((*moveTable)[i][j]);
            if (c->toI == -1 && c->fromI != -1) {
                //找到没有出，只有进的block
                //f指向当前block的进入block，c指向当前block
                moveElementType *f;
                do{
                    f = &((*moveTable)[c->fromI][c->fromJ]);
                    CGRect fromRect = CGRectMake(10 + (10 + l) * (f->i), 10 + (10 + l) * (3 - (f->j)), l, l);
                    block[c->i][c->j].frame = fromRect;
                    
                    UILabel* bl = block[c->i][c->j];
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
