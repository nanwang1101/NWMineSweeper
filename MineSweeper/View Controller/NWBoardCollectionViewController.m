//
//  NWBoardCollectionViewController.m
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import "NWBoardCollectionViewController.h"
#import "NWTileView.h"

@interface NWBoardCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NWGameControl *gameControl;
@property (nonatomic, strong) NWTile* loseTile;

@end

@implementation NWBoardCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithGameControl:(NWGameControl *)gameControl
{
    self = [self initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    
    if (self) {
        _gameControl = gameControl;
        _loseTile = nil;
        
        NSInteger width = CGRectGetWidth(self.collectionView.frame) / gameControl.currGame.boardWidth;
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
        flowLayout.itemSize = CGSizeMake(width, width);
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.minimumLineSpacing = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"NWTileView" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameControl.currGame.boardHeight * self.gameControl.currGame.boardWidth;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NWTileView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSInteger row = indexPath.row / self.gameControl.currGame.boardWidth;
    NSInteger column = indexPath.row % self.gameControl.currGame.boardWidth;
    
    NWTile *tile = [self.gameControl.currGame tileAtPosX:column PosY:row];
    
    // setup the block for long press on cell
    __weak typeof(self) weakSelf = self;
    [cell setupViewWithTile:tile MarkTileBlock:^(NWTile *tile) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.gameControl.currGame toggleMarkGridAtPosX:tile.xPos PosY:tile.yPos];
        [strongSelf.collectionView reloadData];
        if (strongSelf.gameControl.markBlock) {
            strongSelf.gameControl.markBlock(tile);
        }
    }];
    
    if ([tile isEqual:self.loseTile]) {
        [cell revealMine];
    }
    
    if (self.gameControl.currGame.lose) {
        [cell revealWrongMine];
    }
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.gameControl.currGame.lose || self.gameControl.currGame.win) {
        return;
    }
    
    NWTileView *cell = (NWTileView*)[collectionView cellForItemAtIndexPath:indexPath];

    if (![self.gameControl.currGame revealGridAtPosX:cell.tile.xPos PosY:cell.tile.yPos]){
        if (self.gameControl.currGame.lose) {
            [self.collectionView reloadData];
        }
        return;
    }
    
    if ([cell.tile isKindOfClass:[NWMineTile class]]) {
        self.loseTile = cell.tile;
        if (self.gameControl.finishBlock) {
            self.gameControl.finishBlock();
        }
    }else{
        if (self.gameControl.currGame.win || self.gameControl.currGame.lose) {
            if (self.gameControl.finishBlock) {
                self.gameControl.finishBlock();
            }
        }
    }
    
    // disable cheat on next move
    if (self.gameControl.currGame.cheatOn) {
        self.gameControl.currGame.cheatOn = NO;
    }
    [self.collectionView reloadData];
    
    
}

#pragma mark - class functions

-(void)toggleShowAllMineTiles
{
    self.gameControl.currGame.cheatOn = !self.gameControl.currGame.cheatOn;
    [self.collectionView reloadData];
}


@end
