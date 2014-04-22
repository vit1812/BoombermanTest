//
//  GameTile.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameShitou.h"
#import "CCSpriteFrameCache.h"
#import "CCPhysicsBody.h"

@implementation GameShitou

#pragma mark - init

- (id)init {
    CCSpriteFrame *spriteFrame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"shitou.png"];
    
    self    = [super initWithSpriteFrame:spriteFrame];
    
    if (self)
    {
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
        self.physicsBody.collisionGroup = @"shitouGroup"; // 2
        self.physicsBody.collisionType  = @"shitouCollision";
    }
    
    return self;
}

@end
