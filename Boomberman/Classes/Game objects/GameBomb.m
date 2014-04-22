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
//            score+=10;
            i--;
//            scoreLabel.string=[NSString stringWithFormat:@"score: %i",score];
        }
//        if (self.tileArray.count==28&&!isKey)//贴图数为28 即砖块数为0-23为石块 24-26为砖块 27 为炸弹
//        {
//            key=[CCSprite spriteWithFile:@"yaoshi.png"];
//            [self addChild:key z:-1];
//            CCSprite *tile=[tileArray objectAtIndex:arc4random()%3+24];//在三个砖块随机生成一个位置
//            key.position=tile.position;
//            isKey=YES;
//            
//        }
        
    }
    
//    for (int i=0; i<enemyArray.count; i++)
//    {
//        GameEnemy *enemy=[enemyArray objectAtIndex:i];
//        if ((fabs(bomb.position.x-enemy.position.x)<TileWidth||fabs(bomb.position.y-enemy.position.y)<TileHeight)&&ccpDistance(bomb.position, enemy.position)<=TileWidth*2) //如果敌人与炸弹在一条直线上并且距离小于两个单位
//        {
//            [enemyArray removeObject:enemy];
//            [enemy unschedule:@selector(enemyMove)];
//            [enemy enemyKill];
//            score+=100;
//            i--;
//            scoreLabel.string=[NSString stringWithFormat:@"score: %i",score];
//            
//        }
//    }
    
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
//    bombEffect.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, bombEffect.contentSize} cornerRadius:0]; // 1
//    bombEffect.physicsBody.collisionGroup = @"bombEffectGroup"; // 2
//    bombEffect.physicsBody.collisionType  = @"bombEffectCollision";
    [self.parent addChild:bombEffect z:-1];
//    [self.parent addChild:bombEffect];
}

@end
