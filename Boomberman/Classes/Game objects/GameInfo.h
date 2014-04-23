//
//  GameInfo.h
//  Boomberman
//
//  Created by Storm on 4/22/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameInfo : NSObject
{
    int score;
    int level;
}

@property(assign) int score;
@property(assign) int level;

+(id) sharedGameInf;

@end
