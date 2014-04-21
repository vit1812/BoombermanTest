//
//  GameBomb.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameBomb.h"
#import "CCSpriteFrameCache.h"

@implementation GameBomb

#pragma mark - init

- (id)init {
    CCSpriteFrame *spriteFrame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bomb.png"];
    
    self    = [super initWithSpriteFrame:spriteFrame];
    
    if (self)
    {

    }
    
    return self;
}

@end
