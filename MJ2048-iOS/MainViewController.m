
//  MainViewController.m
//  MJ2048
//
//  Created by MJsaka on 15/9/24.
//  Copyright © 2015年 MJsaka. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize blockNum;
@synthesize margin;
@synthesize width;
@synthesize attr;
@synthesize blockAreaView;
@synthesize block;
@synthesize power;
@synthesize best;
@synthesize bestTitle;
@synthesize score;
@synthesize scoreTitle;
@synthesize gameData;


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"setting"]) {
        ((MenuViewController*)segue.destinationViewController).mainViewController = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    gameData = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).gameData;
    attr = [[MacBlockAttribute alloc]init];
    
    CGRect blockAreaViewFrame = CGRectMake(self.view.bounds.size.width * 0.04, self.view.bounds.size.height * 0.3, self.view.bounds.size.width * 0.92, self.view.bounds.size.width * 0.92);
    blockAreaView = [[BlockAreaView alloc]initWithFrame:blockAreaViewFrame];
    [self.view addSubview:blockAreaView];
    blockAreaView.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0];
    blockAreaView.isDeath = [gameData isDeath];
    
    blockNum = [gameData blockNum];
    margin = 8 + (5 - blockNum)*4;
    width = (blockAreaView.frame.size.width -(blockNum + 1)*margin)/blockNum;
    
    blockAreaView.margin = margin;
    blockAreaView.width = width;
    blockAreaView.blockNum = blockNum;
    
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
    
    [blockAreaView setNeedsDisplay];

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < blockNum; ++i) {
        NSMutableArray *col = [NSMutableArray arrayWithCapacity:0];
        for (int j = 0; j < blockNum; ++j) {
            CGRect frame = CGRectMake(margin + (margin + width) * i, margin + (width + margin) * (blockNum-1 - j),width,width);
            UILabel *aLabel = [[UILabel alloc]initWithFrame:frame];
            aLabel.font = [UIFont fontWithName:@"Arial" size:20];
            aLabel.textAlignment = NSTextAlignmentCenter;
            [blockAreaView addSubview:aLabel];
            [col addObject:aLabel];
        }
        [array addObject:col];
    }
    block = [NSArray arrayWithArray:array];
    [self refreshScoreArea];
    for (int i = 0; i < blockNum; ++i) {
        for (int j = 0; j < blockNum; ++j) {
            [self refreshBlockForI:i forJ:j];
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
- (void)refreshBlockForI:(NSInteger)forI forJ:(NSInteger)forJ{
    NSArray *gameDataDownSider = [gameData blockSider:DIR_DOWN];
    blockNodeType* node = gameDataDownSider[forI];
    for (int j = 0; j < forJ; ++j) {
        node = [node nodeOnDir:DIR_UP];
    }

    if (node.data != 0) {
        ((UILabel*)block[forI][forJ]).text = [NSString stringWithFormat:@"%ld",node.data];
        ((UILabel*)block[forI][forJ]).backgroundColor = [attr colorOfPower:node.power];
        ((UILabel*)block[forI][forJ]).alpha = 1;
    }else{
        ((UILabel*)block[forI][forJ]).alpha = 0;
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

- (void)newGame{
    [gameData newGame];
    [self refreshScoreArea];
    for (int i = 0; i < blockNum; ++i) {
        for (int j = 0; j < blockNum; ++j) {
            [self refreshBlockForI:i forJ:j];
            [blockAreaView addSubview:block[i][j]];
        }
    }
    blockAreaView.isDeath = [gameData isDeath];
}
- (void)gameOver{
    for (int i = 0; i < blockNum; ++i) {
        for (int j = 0; j < blockNum; ++j) {
            [block[i][j] removeFromSuperview];
        }
    }
    blockAreaView.isDeath = [gameData isDeath];
    [blockAreaView setNeedsDisplay];
}
- (void)moveControl:(dirEnumType)dir{
    if([gameData merge:dir]){
        [self refreshScoreArea];
        NSArray *gameDataDownSider = [gameData blockSider:DIR_DOWN];
        for (int i = 0; i < blockNum; ++i) {
            blockNodeType* node = gameDataDownSider[i];
            for (int j = 0; j < blockNum; ++j) {
                if (node.refresh) {
                    [self refreshBlockForI:i forJ:j];
                    node.refresh = false;
                }
                node = [node nodeOnDir:DIR_UP];
            }
        }
    }
    if([gameData move:dir]){
        [self startMoveAnimation];
        [self adjustBlock:dir];
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
}

- (void)startMoveAnimation{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
        NSArray *gameDataDownSider = [gameData blockSider:DIR_DOWN];
        for (int i = 0; i < blockNum; ++i) {
            blockNodeType* node = gameDataDownSider[i];
            for (int j = 0; j < blockNum; ++j) {
                NSInteger toI = node.moveToI;
                NSInteger toJ = node.moveToJ;
                if (toI != -1 || toJ != -1) {
                    CGRect toRect = CGRectMake(margin + (margin + width) * toI, margin + (width + margin) * (blockNum-1 - toJ),width,width);
                    ((UILabel*)block[i][j]).frame = toRect;
                }
                node = [node nodeOnDir:DIR_UP];
            }
        }
    } completion:NULL];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startMergeAnimation) userInfo:nil repeats:NO];
}

- (void)startMergeAnimation{
    NSArray *gameDataDownSider = [gameData blockSider:DIR_DOWN];
    for (int i = 0; i < blockNum; ++i) {
        blockNodeType* node = gameDataDownSider[i];
        for (int j = 0; j < blockNum; ++j) {
            if (node.merge) {
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
                node.merge = false;
            }
            if (node.generate) {
                [self refreshBlockForI:i forJ:j];

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
                node.generate = false;
            }
            node = [node nodeOnDir:DIR_UP];
        }
    }
}


- (void)adjustBlock:(dirEnumType)dir{
    dirEnumType redir = 3 - dir;
    NSArray *gameDataDirSider = [gameData blockSider:dir];
    for (int i = 0; i < blockNum; ++i) {
        blockNodeType* node = gameDataDirSider[i];
        for (int j = 0; j < blockNum; ++j) {
            if (node.moveToI == -1 && node.moveFromI != -1) {
                //找到没有出，只有进的block
                //f指向当前block的进入block，c指向当前block
                blockNodeType *c = node;
                blockNodeType *f = [node nodeOnDir:redir];
                while (f.moveToI == -1) {
                    f = [f nodeOnDir:redir];
                }
                CGRect fromRect = CGRectMake(margin + (margin + width) * f.posi, margin + (width + margin) * (blockNum-1 - f.posj),width,width);
                ((UILabel*)block[c.posi][c.posj]).frame = fromRect;
                
                UILabel* bl = block[c.posi][c.posj];
                block[c.posi][c.posj] = block[f.posi][f.posj];
                block[f.posi][f.posj] = bl;
                
                c.moveFromI = -1;
                c.moveFromJ = -1;
                f.moveToI = -1;
                f.moveToJ = -1;
            }
            node = [node nodeOnDir:redir];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
