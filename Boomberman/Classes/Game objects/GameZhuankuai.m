//
//  GameZhuankuai.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameZhuankuai.h"
#import "CCSpriteFrameCache.h"
#import "CCPhysicsBody.h"

@implementation GameZhuankuai

#pragma mark - init

- (id)init {
    CCSpriteFrame *spriteFrame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"zhuankuai.png"];
    
    self    = [super initWithSpriteFrame:spriteFrame];
    
    if (self)
    {
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
        self.physicsBody.collisionGroup = @"zhuankuaiGroup"; // 2
        self.physicsBody.collisionType  = @"zhuankuaiCollision";
    }
    
    return self;
}

@end
