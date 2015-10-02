//
//  MenuViewController.m
//  MJ2048
//
//  Created by MJsaka on 15/10/2.
//  Copyright © 2015年 MJsaka. All rights reserved.
//

#import "MenuViewController.h"
#import "OptionViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize mainViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGame:(id)sender{
    mainViewController.isNewGame = YES;
    [mainViewController viewDidLoad];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resume:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"option"]) {
        ((OptionViewController*)segue.destinationViewController).mainViewController = self.mainViewController;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
