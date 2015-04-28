//
//  NWGame.h
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWMineTile.h"
#import "NWNumberTile.h"

@class NWTile;
@interface NWGame : NSObject

@property (nonatomic, strong) NSArray *board;
@property (nonatomic) NSInteger boardWidth;
@property (nonatomic) NSInteger boardHeight;
@property (nonatomic) NSInteger remainingMines;
@property (nonatomic) BOOL lose;
@property (nonatomic) BOOL win;
@property (nonatomic) BOOL cheatOn;

+ (id)GameWithWidth:(NSInteger)width Height:(NSInteger)height NumberOfMines:(NSInteger)mines;

- (NWTile*)tileAtPosX:(NSInteger)posX PosY:(NSInteger)posY;

// mark/unmark tile
- (void)toggleMarkGridAtPosX:(NSInteger)posX PosY:(NSInteger)posY;
// reveal tile
- (BOOL)revealGridAtPosX:(NSInteger)posX PosY:(NSInteger)posY;

- (void)checkWin;

@end
