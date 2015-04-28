//
//  NWGameControll.h
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWGame.h"

typedef enum {
    NWGameLevel1 = 1,
    NWGameLevel2,
    NWGameLevel3,
} gameLevel;

typedef void (^finishGameBlock)();
typedef void (^markTileBlock)(NWTile *tile);

@interface NWGameControl : NSObject

@property (nonatomic, strong) NWGame *currGame;
@property (nonatomic) gameLevel currLevel;

// finish game callback
@property (nonatomic, copy) finishGameBlock finishBlock;
// mark tile callback
@property (nonatomic, copy) markTileBlock markBlock;


- (instancetype)initWithFinish:(finishGameBlock)finish Mark:(markTileBlock)mark;
- (void)createNewGameWithLevel:(gameLevel)level;
- (BOOL)validateGame;


@end
