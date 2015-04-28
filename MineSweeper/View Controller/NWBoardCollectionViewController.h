//
//  NWBoardCollectionViewController.h
//  MineSweeper
//
//  Created by Nan Wang on 4/13/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWGameControl.h"

@interface NWBoardCollectionViewController : UICollectionViewController

- (instancetype)initWithGameControl:(NWGameControl*)gameControl;
- (void)toggleShowAllMineTiles;

@end
