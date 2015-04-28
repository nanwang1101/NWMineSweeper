//
//  NWTile.m
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import "NWTile.h"

@interface NWTile ()

@property (nonatomic, readwrite) BOOL revealed;
@property (nonatomic, readwrite) BOOL marked;

@end

@implementation NWTile

- (instancetype)initWithPosX:(NSInteger)xPos PosY:(NSInteger)yPos
{
    self = [super init];
    if (self) {
        _xPos = xPos;
        _yPos = yPos;
        _revealed = NO;
        _marked = NO;
    }
    
    return self;
}

#pragma mark
#pragma mark - setter

- (void)setRevealed:(BOOL)revealed
{
    _revealed = revealed;
    if (revealed) {
        self.marked = NO;
    }
}

- (void)setMarked:(BOOL)marked
{
    _marked = marked;
}

- (BOOL)isEqual:(id)object
{
    if (!object) {
        return NO;
    }
    NWTile *other = (NWTile*)object;
    return other.xPos == self.xPos && other.yPos == self.yPos;
}

#pragma mark
#pragma mark - class function

- (BOOL)toggleMark
{
    if (self.isRevealed) {
        self.marked = NO;
        return NO;
    }
    
    self.marked = !self.isMarked;
    return YES;
}

- (BOOL)reveal
{
    if (self.isRevealed || self.isMarked) {
        return NO;
    }
    
    self.revealed = YES;
    return YES;
}

@end

