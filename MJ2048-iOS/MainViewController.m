
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

@synthesize blockAreaView;
@synthesize block;

@synthesize power;
@synthesize best;
@synthesize bestTitle;
@synthesize score;
@synthesize scoreTitle;

@synthesize gameOverLabel;
@synthesize shareToWeiXinButton;
@synthesize retryButton;

@synthesize gameData;
@synthesize attr;
@synthesize appDelegate;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"setting"]) {
        ((MenuViewController*)segue.destinationViewController).mainViewController = self;
    }
}

- (void)makeBlockView{
    CGRect blockAreaViewFrame = CGRectMake(self.view.bounds.size.width * 0.04, self.view.bounds.size.height * 0.3, self.view.bounds.size.width * 0.92, self.view.bounds.size.width * 0.92);
    blockAreaView = [[BlockAreaView alloc]initWithFrame:blockAreaViewFrame];
    blockAreaView.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.0];
    [self.view addSubview:blockAreaView];

    
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
}

- (void)makeBlock{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < blockNum; ++i) {
        NSMutableArray *col = [NSMutableArray arrayWithCapacity:0];
        for (int j = 0; j < blockNum; ++j) {
            CGRect frame = CGRectMake(margin + (margin + width) * i, margin + (width + margin) * (blockNum-1 - j),width,width);
            UILabel *aLabel = [[UILabel alloc]initWithFrame:frame];
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.adjustsFontSizeToFitWidth = YES;
            [blockAreaView addSubview:aLabel];
            [col addObject:aLabel];
        }
        [array addObject:col];
    }
    block = [NSArray arrayWithArray:array];
}

- (void)removeOldBlock{
    for (int i = 0; i < blockNum; ++i) {
        for (int j = 0; j < blockNum; ++j) {
            [(UILabel*)block[i][j] removeFromSuperview];
        }
    }
}

- (void)makeBlockNum{
    blockNum = [gameData blockNum];
    margin = 8 + (5 - blockNum)*4;
    width = (blockAreaView.frame.size.width -(blockNum + 1)*margin)/blockNum;
}

- (void)changeBlockNum:(NSInteger)newBlockNum{
    if ([gameData isDeath]) {
        [self removeGameOverSubView];
    }
    [gameData changeBlockNum:newBlockNum];
    [self removeOldBlock];
    [self makeBlockNum];
    [self makeBlock];
    
    [self refreshScoreArea];
    [self refreshBlockView];
    for (int i = 0; i < blockNum; ++i) {
        for (int j = 0; j < blockNum; ++j) {
            [self refreshBlockForI:i forJ:j];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    attr = [[BlockAttributeIOS alloc]init];
    gameData = appDelegate.gameData;

    [self makeBlockView];
    [self makeBlockNum];
    [self makeBlock];

    [self refreshScoreArea];
    [self refreshBlockView];
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

-(void)refreshBlockView{
    blockAreaView.margin = margin;
    blockAreaView.width = width;
    blockAreaView.blockNum = blockNum;
    [blockAreaView setNeedsDisplay];
}

- (void)gameOver{
    if (gameOverLabel == nil) {
        CGRect gameOverLabelFrame = CGRectMake(0, 0, blockAreaView.bounds.size.width, blockAreaView.bounds.size.height*0.75);
        gameOverLabel = [[UILabel alloc] initWithFrame:gameOverLabelFrame];
        gameOverLabel.backgroundColor = [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:0.8];
        gameOverLabel.textAlignment = NSTextAlignmentCenter;
        gameOverLabel.font = [UIFont boldSystemFontOfSize:40];
        gameOverLabel.text = @"GAME OVER";
    }
    if (retryButton == nil) {
        CGRect retryButtonFrame = CGRectMake(0, blockAreaView.bounds.size.height*0.75, blockAreaView.bounds.size.width*0.5, blockAreaView.bounds.size.height*0.25);
        retryButton = [[UIButton alloc] initWithFrame:retryButtonFrame];
        [retryButton setTitle:@"Retry" forState:UIControlStateNormal];
        retryButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0.25 alpha:0.8];
        [retryButton addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
    }
    if (shareToWeiXinButton == nil) {
        CGRect shareToWeiXinButtonFrame = CGRectMake(blockAreaView.bounds.size.width*0.5, blockAreaView.bounds.size.height*0.75, blockAreaView.bounds.size.width*0.5, blockAreaView.bounds.size.height*0.25);
        shareToWeiXinButton = [[UIButton alloc] initWithFrame:shareToWeiXinButtonFrame];
        [shareToWeiXinButton setTitle:@"Share" forState:UIControlStateNormal];
        shareToWeiXinButton.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:0.8];
        [shareToWeiXinButton addTarget:self action:@selector(shareToWeiXin) forControlEvents:UIControlEventTouchUpInside];
    }
    [blockAreaView addSubview:gameOverLabel];
    [blockAreaView addSubview:retryButton];
    [blockAreaView addSubview:shareToWeiXinButton];
}

- (void)removeGameOverSubView{
    [gameOverLabel removeFromSuperview];
    [retryButton removeFromSuperview];
    [shareToWeiXinButton removeFromSuperview];
}

- (void)shareToWeiXin{
    UIImage *thumbImage = [UIImage imageNamed:@"icon.png"];
    WXWebpageObject *wxWebPageObj = [WXWebpageObject object];
    wxWebPageObj.webpageUrl = @"https://github.com/mjsaka/mj2048";
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"我在2048游戏中获得%ld分，快来围观!",[gameData currentScore]];
    message.mediaObject = wxWebPageObj;
    message.messageExt = nil;
    message.messageAction = nil;
    message.mediaTagName = @"MJ2048";
    message.description = @"MJ2048";
    [message setThumbImage:thumbImage];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.scene = WXSceneTimeline;
    req.bText = NO;
    [WXApi sendReq:req];
}

- (void)newGame{
    if ([gameData isDeath]) {
        [self removeGameOverSubView];
    }
    [gameData newGame];
    [self refreshScoreArea];
    for (int i = 0; i < blockNum; ++i) {
        for (int j = 0; j < blockNum; ++j) {
            [self refreshBlockForI:i forJ:j];
        }
    }
    [self refreshBlockView];
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
        [appDelegate playSound];
        [self startMoveAnimation];
        [self adjustBlock:dir];
        [gameData generate:dir];
        if ([gameData isDeath]) {
            [self gameOver];
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

@implementation BlockAttributeIOS {
    UIColor *colorOfPower[36];
}
- (id)init{
    if (self = [super init]) {
        colorOfPower[0] = [UIColor colorWithRed:1.000 green:0.984 blue:0.792 alpha:1.0];
        colorOfPower[1] = [UIColor colorWithRed:0.973 green:0.800 blue:0.584 alpha:1.0];
        colorOfPower[2] = [UIColor colorWithRed:0.965 green:0.800 blue:0.800 alpha:1.0];
        colorOfPower[3] = [UIColor colorWithRed:0.980 green:0.800 blue:0.200 alpha:1.0];
        colorOfPower[4] = [UIColor colorWithRed:0.949 green:0.608 blue:0.200 alpha:1.0];
        
        colorOfPower[5] = [UIColor colorWithRed:0.345 green:0.704 blue:0.896 alpha:1.0];
        colorOfPower[6] = [UIColor colorWithRed:0.922 green:0.396 blue:0.396 alpha:1.0];
        colorOfPower[7] = [UIColor colorWithRed:0.894 green:0.402 blue:0.157 alpha:1.0];
        colorOfPower[8] = [UIColor colorWithRed:0.878 green:0.263 blue:0.506 alpha:1.0];
        
        colorOfPower[9] = [UIColor colorWithRed:0.808 green:0.596 blue:0.716 alpha:1.0];
        colorOfPower[10] = [UIColor colorWithRed:0.682 green:0.153 blue:0.353 alpha:1.0];
        colorOfPower[11] = [UIColor colorWithRed:0.541 green:0.676 blue:0.153 alpha:1.0];
        colorOfPower[12] = [UIColor colorWithRed:0.696 green:0.408 blue:0.180 alpha:1.0];
        
        colorOfPower[13] = [UIColor colorWithRed:0.608 green:0.400 blue:0.804 alpha:1.0];
        colorOfPower[14] = [UIColor colorWithRed:0.308 green:0.604 blue:0.396 alpha:1.0];
        colorOfPower[15] = [UIColor colorWithRed:0.490 green:0.222 blue:0.490 alpha:1.0];
        colorOfPower[16] = [UIColor colorWithRed:0.404 green:0.404 blue:0.704 alpha:1.0];
        
        colorOfPower[17] = [UIColor colorWithRed:0.182 green:0.233 blue:0.473 alpha:1.0];
        colorOfPower[18] =  [UIColor colorWithRed:0.271 green:0.196 blue:0.396 alpha:1.0];
        colorOfPower[19] =  [UIColor colorWithRed:0.425 green:0.249 blue:0.249 alpha:1.0];
        colorOfPower[20] = [UIColor colorWithRed:0.149 green:0.325 blue:0.137 alpha:1.0];
        
        colorOfPower[21] = [UIColor colorWithRed:0.973 green:0.800 blue:0.584 alpha:1.0];
        colorOfPower[22] = [UIColor colorWithRed:0.965 green:0.800 blue:0.800 alpha:1.0];
        colorOfPower[23] = [UIColor colorWithRed:0.980 green:0.800 blue:0.200 alpha:1.0];
        colorOfPower[24] = [UIColor colorWithRed:0.949 green:0.608 blue:0.200 alpha:1.0];
        
        colorOfPower[25] = [UIColor colorWithRed:0.345 green:0.704 blue:0.896 alpha:1.0];
        colorOfPower[26] = [UIColor colorWithRed:0.922 green:0.396 blue:0.396 alpha:1.0];
        colorOfPower[27] = [UIColor colorWithRed:0.894 green:0.402 blue:0.157 alpha:1.0];
        colorOfPower[28] = [UIColor colorWithRed:0.878 green:0.263 blue:0.506 alpha:1.0];
        
        colorOfPower[29] = [UIColor colorWithRed:0.808 green:0.596 blue:0.716 alpha:1.0];
        colorOfPower[30] = [UIColor colorWithRed:1.000 green:0.984 blue:0.792 alpha:1.0];
        colorOfPower[31] = [UIColor colorWithRed:0.973 green:0.800 blue:0.584 alpha:1.0];
        colorOfPower[32] = [UIColor colorWithRed:0.965 green:0.800 blue:0.800 alpha:1.0];
        
        colorOfPower[33] = [UIColor colorWithRed:0.980 green:0.800 blue:0.200 alpha:1.0];
        colorOfPower[34] = [UIColor colorWithRed:0.949 green:0.608 blue:0.200 alpha:1.0];
        colorOfPower[35] = [UIColor colorWithRed:0.345 green:0.704 blue:0.896 alpha:1.0];
    }
    return self;
}
- (UIColor*)colorOfPower:(NSInteger)power{
    return colorOfPower[power];
}

@end
