//
//  NWTileView.h
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWNumberTile.h"
#import "NWMineTile.h"

typedef void (^markTileBlock)(NWTile* tile);

@interface NWTileView : UICollectionViewCell

@property (nonatomic, strong) NWTile *tile;
@property (nonatomic, copy) markTileBlock markTile;

- (void)setupViewWithTile:(NWTile*)tile MarkTileBlock:(markTileBlock)block;
- (void)revealMine;
- (void)revealWrongMine;

@end
