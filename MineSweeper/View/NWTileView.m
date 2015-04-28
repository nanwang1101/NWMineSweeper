//
//  NWTileView.m
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import "NWTileView.h"

@interface NWTileView ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;


@end

@implementation NWTileView

- (void)awakeFromNib {
    // Initialization code
    self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
    self.contentView.layer.borderWidth = .5f;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressGesture:)];
    [self addGestureRecognizer:longPress];
}


// show "M" with red background for reveal mine
// show "WM" with red background for wrong mark for mine
// show "M" with yellow background for correct mines
- (void)setupViewWithTile:(NWTile *)tile MarkTileBlock:(markTileBlock)block
{
    self.markTile = block;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.tile = tile;
    self.coverView.hidden = tile.isRevealed;
    [self setupMarkMineView];
    
    if ([tile isKindOfClass:[NWMineTile class]]) {
        self.valueLabel.text = @"M";
        NWMineTile *mineTile = (NWMineTile*)tile;
        if (mineTile.cheat && !mineTile.isRevealed) {
            self.coverView.hidden = YES;
            self.contentView.backgroundColor = [UIColor yellowColor];
        }
    }else{
        NWNumberTile *numTile = (NWNumberTile*)self.tile;
        self.valueLabel.text = numTile.value.integerValue == 0 ? @"" : [NSString stringWithFormat:@"%@", numTile.value];
    }
    
}

- (void)revealMine
{
    if ([self.tile isKindOfClass:[NWMineTile class]]) {
        self.contentView.backgroundColor = [UIColor redColor];
        if (!self.coverView.hidden && self.tile.isRevealed) {
            self.coverView.hidden = YES;
        }
    }
}

- (void)revealWrongMine
{
    if ([self.tile isKindOfClass:[NWNumberTile class]] && self.tile.isMarked) {
        self.valueLabel.text = @"WM";
        self.contentView.backgroundColor = [UIColor redColor];
        self.coverView.hidden = YES;
    }
}

- (void)setupMarkMineView
{
    self.flagImageView.hidden = !self.tile.isMarked;
}

- (void)longpressGesture:(UILongPressGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateEnded) return;
    if (!self.tile.isRevealed) {
        if (self.markTile) {
            self.markTile(self.tile);
        }
    }
}

@end
