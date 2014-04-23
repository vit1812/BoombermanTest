//
//  GameBomb.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameBomb.h"
#import "CCSpriteFrameCache.h"
#import "CCPhysicsBody.h"
#import "GameShitou.h"
#import "GameZhuankuai.h"
#import "GameHero.h"
#import "NotificationObject.h"

@implementation GameBomb

@synthesize fTimer  = _fTimer;
@synthesize fBomcActionEffectDuration   = _fBomcActionEffectDuration;
@synthesize tileArray   = _tileArray;
@synthesize hero    = _hero;

#pragma mark - init

- (id)init {
    CCSpriteFrame *spriteFrame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bomb.png"];
    
    self    = [super initWithSpriteFrame:spriteFrame];
    
    if (self)
    {
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0]; // 1
        self.physicsBody.collisionGroup = @"bombGroup";
        self.physicsBody.collisionType  = @"bombCollision";
        
        CCActionInterval *scale1=[CCActionScaleTo actionWithDuration:0.5 scale:1.2];
        CCActionInterval *scale2=[CCActionScaleTo actionWithDuration:0.5 scale:0.8];
        CCActionInterval *seq=[CCActionSequence actions:scale1,scale2, nil];
        CCActionInterval *repeat=[CCActionRepeatForever actionWithAction:seq];
        [self runAction:repeat];
        
        _fTimer = 3.0;
        _fBomcActionEffectDuration  = 0.3;
    }
    
    return self;
}

#pragma mark - methods

-(void) bombDown
{
    CCSprite *tile;

    for (int i=0; i<self.tileArray.count; i++)
    {
        tile=[self.tileArray objectAtIndex:i];
        
        NSLog(@"ccpDistance(tile.position, self.position) - %f", ccpDistance(tile.position, self.position));
        
        if (ccpDistance(tile.position, self.position)<=(TILE_HEIGHT+4)&& [tile isKindOfClass:[GameZhuankuai class]])
        {
            [self.tileArray removeObject:tile];
            
            [tile removeFromParentAndCleanup:NO];
            i--;
            
            NotificationObject *noObject    = [[NotificationObject alloc] initWithType:kNotificationMessageTypeDetroyTile object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyForGameController object:noObject];
        }
    }
    
    NotificationObject *noObject    = [[NotificationObject alloc] initWithType:kNotificationMessageTypeBombDown object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyForMainScene object:noObject];
    
    if ((fabs(self.position.x-self.hero.position.x)<TILE_WIDTH||fabs(self.position.y-self.hero.position.y)<TILE_HEIGHT)&&ccpDistance(self.position, self.hero.position)<TILE_WIDTH*2)
    {
        NSTimeInterval delay_in_seconds = 0.3;
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW,delay_in_seconds*NSEC_PER_SEC);
        dispatch_after(delay, dispatch_get_main_queue(), ^{
            NotificationObject *noObject    = [[NotificationObject alloc] initWithType:kNotificationMessageTypeGameeOver object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyForGameController object:noObject];
        });
    }
    
    [self putBombEffect];
    [self unschedule:@selector(bombDown)];
    [self removeFromParent];
}

-(void) putBombEffect
{
    CCActionScaleTo *scale=[CCActionScaleTo actionWithDuration:self.fBomcActionEffectDuration scale:1];
    CCActionSequence *seq=[CCActionSequence actions:scale,[CCActionRemove action], nil];
    
    CCSprite *bombEffect=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bombEffects.png"]];
    bombEffect.scale=0.333;
    [bombEffect runAction:seq];
    [bombEffect setPosition:self.position];
//    bombEffect.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, CGSizeMake(5, 5)} cornerRadius:0]; // 1
//    bombEffect.physicsBody.collisionGroup = @"bombEffectGroup"; // 2
//    bombEffect.physicsBody.collisionType  = @"bombEffectCollision";
    [self.parent addChild:bombEffect z:-1];
}

@end
