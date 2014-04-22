//
//  GameHero.h
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "CCSprite.h"

@interface GameHero : CCSprite

@property (nonatomic, assign) float speed;
@property (nonatomic, assign) kHeroAct kAct;
@property(nonatomic) NSMutableArray *tileArray; 

- (GameHero *)init;

- (void) putBomb;
- (void) MoveUp;
- (void) MoveLeft;
- (void) MoveRight;
- (void) MoveDown;
- (void) OnStay;
- (void) changWithSpriteFile:(NSString *)fileName;

@end
