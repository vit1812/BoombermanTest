//
//  Constant.h
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject

#define TILE_WIDTH 32
#define TILE_HEIGHT 32
#define SCENE_WIDTH 416
#define SCENE_HEIGHT 288

#define WIN_HEIGHT 320

#define TILE_SCORE 10
#define ENEMY_SCORE 100

#define NANDU   1

#pragma mark - hero

typedef enum {
	kHeroActUp,
	kHeroActLeft,
	kHeroActRight,
	kHeroActDown,
    kHeroActStay,
	kHeroActFire
} kHeroAct;

#pragma mark - notification

extern NSString* const NotifyForMainScene;
extern NSString* const NotifyForGameController;

typedef enum {
    kNotificationMessageTypeUndifine,
    kNotificationMessageTypeBombDown,
    kNotificationMessageTypeGameeOver,
    kNotificationMessageTypeDetroyTile,
    kNotificationMessageTypeDetroyEnemy
} kNotificationMessageType;

@end
