//
//  GameController.h
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "CCScene.h"

@class GameHero;

@interface GameController : CCScene

@property (nonatomic, strong) GameHero *hero;

-(void) gameOver;

@end
