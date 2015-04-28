//
//  NWSettingViewController.h
//  MineSweeper
//
//  Created by Nan Wang on 4/14/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWGameControl.h"

typedef void (^doneSettingBlock)(BOOL change);

@interface NWSettingViewController : UIViewController

- (instancetype)initWithGameControl:(NWGameControl*)control DoneHandler:(doneSettingBlock)doneBlock;

@end
