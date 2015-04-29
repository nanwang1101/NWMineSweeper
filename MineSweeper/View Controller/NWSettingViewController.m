//
//  NWSettingViewController.m
//  MineSweeper
//
//  Created by Nan Wang on 4/14/15.
//  Copyright (c) 2015 Nan Wang. All rights reserved.
//

#import "NWSettingViewController.h"

static CGFloat const oneLevel = 3.0f;

@interface NWSettingViewController ()

@property (weak, nonatomic) IBOutlet UISlider *levelSlider;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (nonatomic, copy) doneSettingBlock doneHandler;
@property (nonatomic, strong) NWGameControl *gameControl;

@end

@implementation NWSettingViewController

- (instancetype)initWithGameControl:(NWGameControl *)control DoneHandler:(doneSettingBlock)doneBlock
{
    self = [self initWithNibName:@"NWSettingViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _gameControl = control;
        _doneHandler = doneBlock;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.levelSlider.value = [self sliderValueWithLevel:self.gameControl.currLevel];
    [self setupLevelStringWithLevel:self.gameControl.currLevel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark - helper functions

- (void)setupLevelStringWithLevel:(gameLevel)level
{
    NSString *levelString = @"";
    switch (level) {
        case NWGameLevel1:
            levelString = @"Level 1";
            break;
            
        case NWGameLevel2:
            levelString = @"Level 2";
            break;
            
        case NWGameLevel3:
            levelString = @"Level 3";
            break;
            
        default:
            break;
    }
    
    self.levelLabel.text = levelString;
}

- (CGFloat)sliderValueWithLevel:(gameLevel)level
{
    CGFloat levelInteger = 0;
    switch (level) {
        case NWGameLevel1:
            levelInteger = 1.0f;
            break;
            
        case NWGameLevel2:
            levelInteger = 2.0f;
            break;
            
        case NWGameLevel3:
            levelInteger = 3.0f;
            break;
        default:
            break;
    }
    return levelInteger * oneLevel;
}

- (gameLevel)levelWithSliderValue
{
    NSInteger level;
    if ((NSInteger)self.levelSlider.value % (NSInteger)oneLevel == 0) {
        level = self.levelSlider.value / oneLevel;
    }else{
        level = self.levelSlider.value / oneLevel + 1;
    }
    self.levelSlider.value = (CGFloat)level * oneLevel;

    switch (level) {
        case 1:
            return NWGameLevel1;
            break;
            
        case 2:
            return NWGameLevel2;
            break;
        
        case 3:
            return NWGameLevel3;
            break;
            
        default:
            return NWGameLevel1;
            break;
    }
}

#pragma mark
#pragma mark - IBOutlet functions

- (IBAction)doneClicked:(id)sender {
    gameLevel level = [self levelWithSliderValue];
    BOOL change = level != self.gameControl.currLevel;
    if (change) {
        self.gameControl.currLevel = level;
        if (self.doneHandler) {
            self.doneHandler(YES);
        }
    }else{
        if (self.doneHandler) {
            self.doneHandler(NO);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sliderValueChanged:(id)sender {
    
    gameLevel level = [self levelWithSliderValue];
    [self setupLevelStringWithLevel:level];
}

@end
