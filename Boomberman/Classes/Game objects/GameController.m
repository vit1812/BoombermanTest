//
//  GameController.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameController.h"
#import "CCSprite.h"
#import "CCDirector.h"
#import "GameHero.h"
#import "GameBomb.h"

@implementation GameController {

}

@synthesize hero    = _hero;

#pragma mark - init

-(id) init
{
    if (self=[super init])
    {
        self.userInteractionEnabled = YES;
        
        CCSprite *ukeySprite=[CCSprite spriteWithImageNamed:@"key.png"];
        [self addChild:ukeySprite];
        ukeySprite.position=ccp(1.5 * TILE_WIDTH, 1.5 * TILE_HEIGHT);
        
        CCSprite *dkeySprite=[CCSprite spriteWithImageNamed:@"key.png"];
        [self addChild:dkeySprite];
        dkeySprite.position=ccp(1.5 * TILE_WIDTH, 0.5 * TILE_HEIGHT);
        dkeySprite.rotation=180;
        
        CCSprite *lkeySprite=[CCSprite spriteWithImageNamed:@"key.png"];
        [self addChild:lkeySprite];
        lkeySprite.position=ccp(0.5 * TILE_WIDTH, 0.5 * TILE_HEIGHT);
        lkeySprite.rotation=-90;
        
        CCSprite *rkeySprite=[CCSprite spriteWithImageNamed:@"key.png"];
        [self addChild:rkeySprite];
        rkeySprite.position=ccp(2.5*TILE_WIDTH,0.5*TILE_HEIGHT);
        rkeySprite.rotation=90;
        
        CCSprite *bomb=[CCSprite spriteWithImageNamed:@"bomb.png"];
        [self addChild:bomb];
        bomb.position=ccp(14.5*TILE_WIDTH,0.5*TILE_HEIGHT);
    }
    return self;
}

#pragma mark - touch handler

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location=[touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL: location];
    CGPoint touchpos=[self convertToTilePos:location];
    
    if (touchpos.x==0.5*TILE_WIDTH&&touchpos.y==0.5*TILE_HEIGHT)
    {
        [self.hero MoveLeft];
    }
    if (touchpos.x==2.5*TILE_WIDTH&&touchpos.y==0.5*TILE_HEIGHT)
    {
        [self.hero MoveRight];
    }
    if (touchpos.x==1.5*TILE_WIDTH&&touchpos.y==0.5*TILE_HEIGHT)
    {
        [self.hero MoveDown];
    }
    if (touchpos.x==1.5*TILE_WIDTH&&touchpos.y==1.5*TILE_HEIGHT)
    {
        [self.hero MoveUp];
    }
    if (touchpos.x==14.5*TILE_WIDTH&&touchpos.y==0.5*TILE_HEIGHT)
    {
        // bomb
        CGPoint pos=self.hero.position;
        pos=[self convertToTilePos:pos];
        
        GameBomb *bomb  = [GameBomb node];
        [bomb setPosition: pos];
        
        [self addChild:bomb];
    }
}

#pragma mark - methods

-(CGPoint) convertToTilePos:(CGPoint) pos
{
    int x=pos.x/TILE_WIDTH;
    int y=pos.y/TILE_HEIGHT;
    return CGPointMake((x+0.5)*TILE_WIDTH, (y+0.5)*TILE_HEIGHT);
}

@end
