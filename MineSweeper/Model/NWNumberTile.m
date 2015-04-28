//
//  NWNumberTile.m
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import "NWNumberTile.h"

@implementation NWNumberTile

- (instancetype)initWithPosX:(NSInteger)xPos PosY:(NSInteger)yPos
{
    self = [super initWithPosX:xPos PosY:yPos];
    if (self) {
        _value = [NSNumber numberWithInteger:0];
    }
    return self;
}

@end
