//
//  GameBomb.h
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "CCSprite.h"

@class GameHero;

@interface GameBomb : CCSprite

@property (nonatomic, assign) float fTimer;
@property (nonatomic, assign) float fBomcActionEffectDuration;
@property(nonatomic) NSMutableArray *tileArray;
@property(nonatomic) GameHero *hero;

@end
