//
//  GameTile.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameShitou.h"
#import "CCSpriteFrameCache.h"

@implementation GameShitou

#pragma mark - init

- (id)init {
    CCSpriteFrame *spriteFrame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"shitou.png"];
    
    if ([self initWithSpriteFrame:spriteFrame])
    {
        
    }
    
    return self;
}

@end
