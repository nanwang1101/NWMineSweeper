//
//  NWMainViewController.m
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import "NWMainViewController.h"
#import "NWGameControl.h"
#import "NWBoardCollectionViewController.h"
#import "NWSettingViewController.h"

@interface NWMainViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *mineCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *loseLabel;

@property (nonatomic, strong) NWGameControl *gameControl;
@property (nonatomic, strong) NWBoardCollectionViewController *boardViewController;

@end

@implementation NWMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        finishGameBlock gameFinish = ^(){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf showWinLoseMessage];
        };
        markTileBlock markTile = ^(NWTile* tile){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.mineCountLabel.text = [NSString stringWithFormat:@"Mines: %@", @(strongSelf.gameControl.currGame.remainingMines)];
        };
        _gameControl = [[NWGameControl alloc] initWithFinish:gameFinish Mark:markTile];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Mine Sweeper";

    [self startNewGameWithLevel:self.gameControl.currLevel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark
#pragma mark - game logic
- (void)startNewGameWithLevel:(gameLevel)level
{
    self.loseLabel.hidden = YES;
    [self.gameControl createNewGameWithLevel:level];
    NWBoardCollectionViewController *nextVC = [[NWBoardCollectionViewController alloc] initWithGameControl:self.gameControl];
    nextVC.view.frame = self.contentView.bounds;
    
    if (self.boardViewController) {
        
        [self addChildViewController:nextVC];
        [self.boardViewController willMoveToParentViewController:nil];
        
        [self transitionFromViewController:self.boardViewController toViewController:nextVC duration:.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{}
                                completion:^(BOOL finished) {
                                    [self.boardViewController removeFromParentViewController];
                                    [nextVC didMoveToParentViewController:self];
                                    self.boardViewController = nextVC;
                                    self.mineCountLabel.text = [NSString stringWithFormat:@"Mines: %@", @(self.gameControl.currGame.remainingMines)];
                                }];
    }else{
        [self addChildViewController:nextVC];
        [self.contentView addSubview:nextVC.view];
        [nextVC didMoveToParentViewController:self];
        self.boardViewController = nextVC;
        self.mineCountLabel.text = [NSString stringWithFormat:@"Mines: %@", @(self.gameControl.currGame.remainingMines)];
    }
}

- (void)showWinLoseMessage
{
    NSString *msg = self.gameControl.currGame.lose ? @"LOSE!" : @"WIN!";
    self.loseLabel.text = msg;
    self.loseLabel.hidden = NO;
}

#pragma mark
#pragma mark - button functions

- (IBAction)newGameClicked:(id)sender {
    [self startNewGameWithLevel:self.gameControl.currLevel];
}

// validate game rules:
// Win condition:
//  1. when the unrevealed tiles are all mines;
//  2. when all marked tiles are mines and total count is equal to mine count
// Otherwise the game is lost
- (IBAction)validateGame:(id)sender {
    if (![self.gameControl validateGame]) {
        self.gameControl.currGame.lose = YES;
    }
    
    [self showWinLoseMessage];
}

- (IBAction)toggleCheat:(id)sender {
    [self.boardViewController toggleShowAllMineTiles];
}

- (IBAction)moreClicked:(id)sender {
    
    NWSettingViewController *setting = [[NWSettingViewController alloc] initWithGameControl:self.gameControl DoneHandler:^(BOOL change) {
        if (change) {
            [self startNewGameWithLevel:self.gameControl.currLevel];
        }
    }];
    
    [self presentViewController:setting animated:YES completion:nil];
}

@end
