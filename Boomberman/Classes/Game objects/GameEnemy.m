//
//  GameEnemy.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameEnemy.h"
#import "CCSpriteFrameCache.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "CCAction.h"

@implementation GameEnemy

#pragma mark - init

- (id)init {
    CCSpriteFrame *spriteFrame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy1.png"];
    if ([self initWithSpriteFrame:spriteFrame])
    {
        CCSpriteFrame *frame1=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy1.png"];
        CCSpriteFrame *frame2=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy2.png"];
        NSArray *frameArray=[NSArray arrayWithObjects:frame1,frame2, nil];
        
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frameArray];
        CCActionAnimate *actionAnimate  = [CCActionAnimate actionWithAnimation:animation];
        [self runAction:[CCActionRepeatForever actionWithAction:actionAnimate]];
    }
    
    return self;
}

@end
