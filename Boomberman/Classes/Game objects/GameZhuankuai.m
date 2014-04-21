//
//  GameZhuankuai.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameZhuankuai.h"
#import "CCSpriteFrameCache.h"

@implementation GameZhuankuai

#pragma mark - init

- (id)init {
    CCSpriteFrame *spriteFrame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"zhuankuai.png"];
    
    if ([self initWithSpriteFrame:spriteFrame])
    {
        
    }
    
    return self;
}

@end
