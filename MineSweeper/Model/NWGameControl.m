//
//  NWGameControll.m
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import "NWGameControl.h"
#import "NWNumberTile.h"
#import "NWMineTile.h"

@implementation NWGameControl

- (instancetype)initWithFinish:(finishGameBlock)finish Mark:(markTileBlock)mark
{
    self = [super init];
    if (self) {
       [self createNewGameWithLevel:NWGameLevel1];
        _finishBlock = finish;
        _markBlock = mark;
        // default level
        _currLevel = NWGameLevel1;
    }
    return self;
}

- (void)createNewGameWithLevel:(gameLevel)level
{
    self.currLevel = level;
    switch (level) {
        case NWGameLevel1:
            self.currGame = [NWGame GameWithWidth:8 Height:8 NumberOfMines:10];
            break;
            
        case NWGameLevel2:
            self.currGame = [NWGame GameWithWidth:10 Height:10 NumberOfMines:20];
            break;
            
        case NWGameLevel3:
            self.currGame = [NWGame GameWithWidth:12 Height:12 NumberOfMines:30];
            break;
            
        default:
            break;
    }
}


- (BOOL)validateGame
{
    [self.currGame checkWin];
    if (self.currGame.win) {
        return YES;
    }
    
    self.currGame.lose = YES;
    return NO;
}

@end
