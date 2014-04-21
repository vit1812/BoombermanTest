//
//  GameHero.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameHero.h"

@implementation GameHero

@synthesize speed   = _speed;

#pragma mark - init

- (id)init {
    self    = [super initWithImageNamed:@"down.png"];
    
    if (self) {
        _speed  = 8;
    }
    
    return self;
}

#pragma mark - methods

-(void) MoveUp
{
    [self changWithSpriteFile:@"up.png"];

    self.position=ccp(self.position.x,self.position.y+self.speed);
}

- (void) MoveLeft
{
    [self changWithSpriteFile:@"left.png"];
    
    self.position=ccp(self.position.x-self.speed,self.position.y);
}

- (void) MoveRight
{
    [self changWithSpriteFile:@"right.png"];
    
    self.position=ccp(self.position.x+self.speed,self.position.y);
}

-(void) MoveDown
{
    [self changWithSpriteFile:@"down.png"];
    
    self.position=ccp(self.position.x,self.position.y-self.speed);
}

-(void) changWithSpriteFile:(NSString *)fileName
{
    
    CCSprite *sprite=[CCSprite spriteWithImageNamed:fileName];
    
    [self setTexture:sprite.texture];
}

@end
