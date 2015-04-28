//
//  NWGame.m
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import "NWGame.h"

@interface NWGame ()

@property (nonatomic, copy) NSMutableSet* mineTiles;
@property (nonatomic) NSInteger revealedCount;
@property (nonatomic) NSInteger boardSize;
@property (nonatomic) NSInteger mineCount;

@end

@implementation NWGame

#pragma mark
#pragma mark - init methods

+ (id)GameWithWidth:(NSInteger)width Height:(NSInteger)height NumberOfMines:(NSInteger)mines
{
    return [[[self class] alloc] initWithWidth:width Height:height NumberOfMines:mines];
}

- (instancetype)initWithWidth:(NSInteger)width Height:(NSInteger)height NumberOfMines:(NSInteger)mines{
    
    NSParameterAssert(width > 0);
    NSParameterAssert(height > 0);
    NSParameterAssert(mines > 0);
    
    self = [super init];
    if (self) {
        _revealedCount = 0;
        _board = [self createBoardWithWidth:width Height:height NumberOfMines:mines];
        _boardSize = height * width;
        _boardHeight = height;
        _boardWidth = width;
        _remainingMines = mines;
        _mineCount = mines;
        _lose = NO;
        _win = NO;
        _cheatOn = NO;
    }
    
    return self;
}

#pragma mark
#pragma mark - setter/getter

- (NSMutableSet *)mineTiles
{
    if (!_mineTiles) {
        _mineTiles = [NSMutableSet set];
    }
    return _mineTiles;
}

- (void)setCheatOn:(BOOL)cheatOn
{
    _cheatOn = cheatOn;
    for (NWMineTile *mineTile in self.mineTiles) {
        mineTile.cheat = cheatOn;
    }
}

#pragma mark
#pragma mark - init helper
- (NSArray*)createBoardWithWidth:(NSInteger)width Height:(NSInteger)height NumberOfMines:(NSInteger)mines{
    
    // generate mine positions
    NSMutableSet *minePosSet = [NSMutableSet set];
    while (mines > 0) {
        NSInteger randomNumber = arc4random() % (width*height);
        if (![minePosSet containsObject:@(randomNumber)]) {
            [minePosSet addObject:@(randomNumber)];
            mines--;
        }
    }
    
    // use mine positions to generate board
    NSMutableArray *boardArray = [NSMutableArray array];
    for (NSInteger i = 0; i < height; i++) {
        NSMutableArray *row = [NSMutableArray array];
        boardArray[i] = row;
        for (NSInteger j = 0; j < width; j++) {
            NSInteger currPos = i*width + j;
            // add mine or number tile
            NWTile *tile;
            if ([minePosSet containsObject:@(currPos)]) {
                tile = [[NWMineTile alloc] initWithPosX:j PosY:i];
                [self.mineTiles addObject:tile];
            }else{
                tile = [[NWNumberTile alloc] initWithPosX:j PosY:i];
            }
            [row addObject:tile];
        }
    }
    
    // correct the value of number tiles
    for (NSInteger i = 0; i < height; i++) {
        NSMutableArray *row = boardArray[i];
        for (NSInteger j = 0; j < width; j++) {
            NWTile *tile = row[j];
            if ([tile isKindOfClass:[NWMineTile class]]) {
                for (NWTile *neighborTile in [self neighborsOfTile:tile inBoard:boardArray]) {
                    if ([neighborTile isKindOfClass:[NWNumberTile class]]) {
                        NWNumberTile *numTile = (NWNumberTile*)neighborTile;
                        NSInteger number = numTile.value.integerValue;
                        number++;
                        numTile.value = [NSNumber numberWithInteger:number];
                    }
                    
                }
            }
        }
    }
    
    return boardArray;
}

- (NSArray*)neighborsOfTile:(NWTile*)tile inBoard:(NSArray*)board
{
    NSArray *preRow = nil;
    NSArray *nextRow = nil;
    NSArray *currRow = board[tile.yPos];
    if (tile.yPos > 0) {
        preRow = board[tile.yPos-1];
    }
    if (tile.yPos < board.count-1) {
        nextRow = board[tile.yPos+1];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (tile.xPos > 0) {
        [array addObject:currRow[tile.xPos-1]];
    }
    if (tile.xPos < currRow.count - 1) {
        [array addObject:currRow[tile.xPos+1]];
    }
    
    if (preRow) {
        [array addObject:preRow[tile.xPos]];
        if (tile.xPos > 0) {
            [array addObject:preRow[tile.xPos-1]];
        }
        if (tile.xPos < preRow.count - 1) {
            [array addObject:preRow[tile.xPos+1]];
        }
    }
    
    if (nextRow) {
        [array addObject:nextRow[tile.xPos]];
        if (tile.xPos > 0) {
            [array addObject:nextRow[tile.xPos-1]];
        }
        if (tile.xPos < nextRow.count - 1) {
            [array addObject:nextRow[tile.xPos+1]];
        }
    }
    
    return array;
}


#pragma mark
#pragma mark - helper functions

- (NSSet *)allMineTiles
{
    return self.mineTiles;
}

- (NSInteger)markedNeighborCountForTile:(NWTile*)tile
{
    NSInteger count = 0;
    for (NWTile *neighbor in [self neighborsOfTile:tile inBoard:self.board]) {
        if (neighbor.isMarked) {
            count++;
        }
    }
    return count;
}


- (BOOL)revealNeighbors:(NWNumberTile*)tile{
    
    BOOL revealed = NO;
    
    for (NWTile *neighbor in [self neighborsOfTile:tile inBoard:self.board]) {
        if ([neighbor isKindOfClass:[NWNumberTile class]]) {
            if (![neighbor reveal]) {
                if (neighbor.isMarked && !neighbor.isRevealed) {
                    self.lose = YES;
                }
                continue;
            }else{
                revealed = YES;
                self.revealedCount++;
                [self checkWin];
                NWNumberTile *numTile = (NWNumberTile*)neighbor;
                if (numTile.value.integerValue == 0) {
                    [self revealNeighbors:numTile];
                }
            }
        }
    }
    
    return revealed;
}


#pragma mark
#pragma mark - class functions

- (NWTile *)tileAtPosX:(NSInteger)posX PosY:(NSInteger)posY
{
    if(posY < self.board.count){
        NSArray *row = self.board[posY];
        if (posX < row.count) {
            NWTile *tile = row[posX];
            return tile;
        }
    }
    
    return nil;
}

- (void)toggleMarkGridAtPosX:(NSInteger)posX PosY:(NSInteger)posY
{
    if (self.lose) {
        return;
    }
    
    NWTile *tile = [self tileAtPosX:posX PosY:posY];
    if (tile) {
        if (![tile toggleMark]) {
            NSLog(@"failed mark/unmark tile");
        }else{
            self.remainingMines = tile.isMarked ? self.remainingMines - 1 : self.remainingMines + 1;
        }

    }
}

- (BOOL)revealGridAtPosX:(NSInteger)posX PosY:(NSInteger)posY{
    
    if (self.lose) {
        return NO;
    }
    
    NWTile *tile = [self tileAtPosX:posX PosY:posY];
    if (!tile) {
        return NO;
    }
    
    // if the tile can be revealed (unrevealed and unmarked)
    if ([tile reveal]) {
        self.revealedCount++;
        [self checkWin];
        
        if ([tile isKindOfClass:[NWMineTile class]]) {
            self.lose = YES;
        }else if ([tile isKindOfClass:[NWNumberTile class]]) {
            NWNumberTile *currNumTile = (NWNumberTile*)tile;
            if (currNumTile.value.integerValue == 0) {
                [self revealNeighbors:currNumTile];
            }
        }
        return YES;
    }else{
        // if the tile is already revealed and not marked
        if ([tile isKindOfClass:[NWNumberTile class]] && tile.isRevealed && !tile.isMarked){
            NWNumberTile *numTile = (NWNumberTile*)tile;
            if (numTile.value.integerValue == [self markedNeighborCountForTile:numTile]) {
                return [self revealNeighbors:numTile];
            }
        }
        
        return NO;
    }
}

- (void)checkWin
{
    NSInteger unrevealedCount = self.boardSize - self.revealedCount;
    if (unrevealedCount == self.mineCount) {
        self.win = YES;
        return;
    }
    
    if (self.remainingMines == 0) {
        for (NWMineTile *tile in self.mineTiles) {
            if (!tile.isMarked) {
                return;
            }
        }
        self.win = YES;
    }
}

@end
