//
//  GameInfo.m
//  Boomberman
//
//  Created by Storm on 4/22/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameInfo.h"

@implementation GameInfo

@synthesize score,level;
static GameInfo *gameinfo;

+ (id)sharedGameInf
{
    if (!gameinfo)
    {
        gameinfo = [[GameInfo alloc] init];
        
    }
    return gameinfo;
}

- (id)init
{
    if (self=[super init])
    {
        score = 0;
        level = 1;
    }
    return self;
}

@end
