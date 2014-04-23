//
//  GameHero.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameHero.h"
#import "GameBomb.h"
#import "CCPhysicsBody.h"

@implementation GameHero

@synthesize speed   = _speed;
@synthesize kAct    = _kAct;
@synthesize tileArray   = _tileArray;

#pragma mark - init

- (id)init {
    self    = [super initWithImageNamed:@"down.png"];
    
    if (self) {
        _speed  = 8;
        _kAct   = kHeroActStay;
        
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
        self.physicsBody.collisionGroup = @"heroGroup"; // 2
        self.physicsBody.collisionType  = @"heroCollision";
    }
    
    return self;
}

#pragma mark - methods

- (void)putBomb {
    CGPoint pos=self.position;
    pos=[Utils convertToTilePos:pos];
    
    GameBomb *bomb  = [GameBomb node];
    [bomb setPosition: pos];
    bomb.tileArray  = self.tileArray;
    bomb.hero   = self;
    
    [self.parent addChild:bomb z:-1];
    
    [bomb schedule:@selector(bombDown) interval:bomb.fTimer repeat:NO delay:bomb.fTimer];
}

-(void) MoveUp
{
    [self changWithSpriteFile:@"up.png"];
    self.kAct=kHeroActUp;

    CCSprite *tile;
    for (int i=0; i<self.tileArray.count; i++)
    {
        tile=[self.tileArray objectAtIndex:i];
        
        if ((self.position.y<tile.position.y)&&tile.position.y-self.position.y==TILE_HEIGHT)
        {
            if (tile.position.x==self.position.x)
            {
                return;
            }
            if (tile.position.x>self.position.x&&tile.position.x-self.position.x<TILE_WIDTH)
            {
                self.position=ccp(tile.position.x-TILE_WIDTH,self.position.y);
                break;
            }
            if (tile.position.x<self.position.x&&self.position.x-tile.position.x<TILE_WIDTH)
            {
                self.position=ccp(tile.position.x+TILE_WIDTH,self.position.y);
                break;
            }
        }

        if (self.position.y>=(9-0.5)*TILE_HEIGHT)
        {
            self.position=ccp(self.position.x,(9-0.5)*TILE_HEIGHT);
            return;
        }
        
    }
    
    self.position=ccp(self.position.x,self.position.y+self.speed);
}

- (void) MoveLeft
{
    [self changWithSpriteFile:@"left.png"];
    self.kAct=kHeroActLeft;

    CCSprite *tile;
    for (int i=0; i<self.tileArray.count; i++)
    {
        tile=[self.tileArray objectAtIndex:i];
        
        if ((self.position.x>tile.position.x)&&self.position.x-tile.position.x==TILE_WIDTH)
        {
            
            if (tile.position.y==self.position.y)
            {
                return;
            }
            if (tile.position.y>self.position.y&&tile.position.y-self.position.y<TILE_HEIGHT)
            {
                self.position=ccp(self.position.x,tile.position.y-TILE_HEIGHT);
                break;
            }
            if (tile.position.y<self.position.y&&self.position.y-tile.position.y<TILE_HEIGHT)
            {
                self.position=ccp(self.position.x,tile.position.y+TILE_HEIGHT);
                break;
            }
            
        }

        if (self.position.x<=1.5*TILE_WIDTH)
        {
            self.position=ccp(1.5*TILE_WIDTH,self.position.y);
            return;
        }
        
    }
    
    self.position=ccp(self.position.x-self.speed,self.position.y);
}

- (void) MoveRight
{
    [self changWithSpriteFile:@"right.png"];
    self.kAct=kHeroActRight;

    CCSprite *tile;
    for (int i=0; i<self.tileArray.count; i++)
    {
        tile=[self.tileArray objectAtIndex:i];
        
        if ((self.position.x<tile.position.x)&&tile.position.x-self.position.x==TILE_WIDTH)
        {
            if (tile.position.y==self.position.y)
            {
                return;
            }
            if (tile.position.y>self.position.y&&tile.position.y-self.position.y<TILE_HEIGHT)
            {
                self.position=ccp(self.position.x,tile.position.y-TILE_HEIGHT);
                break;
            }
            if (tile.position.y<self.position.y&&self.position.y-tile.position.y<TILE_HEIGHT)
            {
                self.position=ccp(self.position.x,tile.position.y+TILE_HEIGHT);
                break;
            }
            
        }

        if (self.position.x>=13.5*TILE_WIDTH)
        {
            self.position=ccp(13.5*TILE_WIDTH,self.position.y);
            return;
        }
        
    }
    
    self.position=ccp(self.position.x+self.speed,self.position.y);
}

-(void) MoveDown
{
    [self changWithSpriteFile:@"down.png"];
    self.kAct=kHeroActDown;

    CCSprite *tile;
    for (int i=0; i<self.tileArray.count; i++)
    {
        tile=[self.tileArray objectAtIndex:i];
        
        if ((self.position.y>tile.position.y)&&self.position.y-tile.position.y==TILE_HEIGHT)
        {
            if (tile.position.x==self.position.x)
            {
                return;
            }
            if (tile.position.x>self.position.x&&tile.position.x-self.position.x<TILE_WIDTH)
            {
                self.position=ccp(tile.position.x-TILE_WIDTH,self.position.y);
                break;
            }
            if (tile.position.x<self.position.x&&self.position.x-tile.position.x<TILE_WIDTH)
            {
                self.position=ccp(tile.position.x+TILE_WIDTH,self.position.y);
                break;
            }
        }
        
        if (self.position.y<=0.5*TILE_HEIGHT)
        {
            self.position=ccp(self.position.x,0.5*TILE_HEIGHT);
            return;
        }
        
    }
    
    self.position=ccp(self.position.x,self.position.y-self.speed);
}

-(void) OnStay
{
    self.kAct=kHeroActStay;
}

-(void) changWithSpriteFile:(NSString *)fileName
{
    CCSprite *sprite=[CCSprite spriteWithImageNamed:fileName];
    
    [self setTexture:sprite.texture];
}

@end
