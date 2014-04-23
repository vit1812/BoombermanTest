//
//  GameController.h
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"

@class GameHero;

@interface GameController : CCScene {
    int score;
    int level;
    int time;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *levelLabel;
    CCLabelTTF *timeLabel;
}

@property (nonatomic, strong) GameHero *hero;
@property (nonatomic) NSArray *enemyArray;

-(void) gameOver;

@end
