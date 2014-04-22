//
//  Utils.m
//  Boomberman
//
//  Created by LionKing on 4/22/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (CGPoint) convertToTilePos:(CGPoint) pos
{
    int x=pos.x/TILE_WIDTH;
    int y=pos.y/TILE_HEIGHT;
    return CGPointMake((x+0.5)*TILE_WIDTH, (y+0.5)*TILE_HEIGHT);
}

@end
