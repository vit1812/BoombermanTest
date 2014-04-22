//
//  HelloWorldScene.h
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright Anonymous 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface MainScene : CCScene <CCPhysicsCollisionDelegate>

// -----------------------------------------------------------------------

@property (nonatomic, assign) int iEnemyNum;

+ (MainScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end