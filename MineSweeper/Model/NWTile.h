//
//  NWTile.h
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWTile : NSObject

@property (nonatomic, readonly, getter=isRevealed) BOOL revealed;
@property (nonatomic, readonly,  getter=isMarked) BOOL marked;
@property (nonatomic) NSInteger xPos;
@property (nonatomic) NSInteger yPos;

- (instancetype)initWithPosX:(NSInteger)xPos PosY:(NSInteger)yPos;
- (BOOL)toggleMark;
- (BOOL)reveal;

@end
