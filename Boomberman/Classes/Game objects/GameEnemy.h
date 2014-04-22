//
//  GameEnemy.h
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "CCSprite.h"

typedef enum
{
    kEnemyActHorizon,
    kEnemyActVertical
    
}kEnemyAct;

@interface GameEnemy : CCSprite {

}

@property(nonatomic, assign) kEnemyAct kAct;
@property(nonatomic, assign) float fSpeed;
@property(nonatomic) NSMutableArray *tileArray; 

@end
