//
//  GameEnemy.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright (c) 2014 Anonymous. All rights reserved.
//

#import "GameEnemy.h"
#import "CCSpriteFrameCache.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "CCAction.h"
#import "CCPhysicsBody.h"

@interface GameEnemy ()

@property (nonatomic, assign) int stepCount;

@end

@implementation GameEnemy

@synthesize kAct    = _kAct;
@synthesize fSpeed  = _fSpeed;
@synthesize stepCount   = _stepCount;
@synthesize tileArray   = _tileArray;

#pragma mark - init

- (id)init {
    CCSpriteFrame *spriteFrame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy1.png"];
    if ([self initWithSpriteFrame:spriteFrame])
    {
        _kAct=arc4random()%2+1;
        _fSpeed = 3.0;
        
        CCSpriteFrame *frame1=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy1.png"];
        CCSpriteFrame *frame2=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy2.png"];
        NSArray *frameArray=[NSArray arrayWithObjects:frame1,frame2, nil];
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frameArray];
        CCActionInterval *actionAnimate  = [CCActionAnimate actionWithAnimation:animation];
        CCActionInterval *repeat=[CCActionRepeatForever actionWithAction:actionAnimate];
        [self runAction:repeat];
        
        self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointMake(5, 5), CGSizeMake(self.contentSize.width - 10, self.contentSize.height - 10)} cornerRadius:0]; // 1
        self.physicsBody.collisionGroup = @"enemyGroup"; // 2
        self.physicsBody.collisionType  = @"enemyCollision";
        
        [self schedule:@selector(enemyMove) interval:1/10.0f];
    }
    
    return self;
}

#pragma mark - methods

-(void) removeEnemy
{
    [self removeFromParentAndCleanup:YES];
}

-(void) enemyKill
{
    CCActionScaleTo *scale=[CCActionScaleTo actionWithDuration:1 scale:0];
    CCActionTintTo *tint=[CCActionTintTo actionWithDuration:1 color:[CCColor colorWithRed:255 green:255 blue:255]];
    [self runAction:tint];
    CCActionSequence *seq=[CCActionSequence actions:scale,[CCActionCallFunc actionWithTarget:self selector:@selector(removeEnemy)], nil];
    [self runAction:seq];
}

-(void) enemyMove
{
    
    if (self.kAct==kEnemyActHorizon)
    {
        CCSprite *tile;
        BOOL leftnEnable=NO;
        BOOL rightnEnable=NO;
        
        if (self.position.x==1.5*TILE_WIDTH)
        {
            leftnEnable=YES;
        }
        if (self.position.x==13.5*TILE_WIDTH)
        {
            rightnEnable=YES;
        }
        
        for (int i=0; i<self.tileArray.count; i++)
        {
            tile=[self.tileArray objectAtIndex:i];
            if (tile.position.y==self.position.y&&self.position.x-tile.position.x==TILE_WIDTH)
            {
                leftnEnable=YES;
            }
            if (tile.position.y==self.position.y&&tile.position.x-self.position.x==TILE_WIDTH)
            {
                rightnEnable=YES;
            }
        }
        
        if (leftnEnable&&rightnEnable)
        {
            self.kAct=kEnemyActVertical;
            return;
        }
        
        for (int i=0; i<self.tileArray.count; i++)
        {
            tile=[self.tileArray objectAtIndex:i];
            if ((self.position.x<tile.position.x)&&tile.position.x-self.position.x<=TILE_WIDTH&&fabs(tile.position.y-self.position.y)<TILE_WIDTH&&self.fSpeed>0)
            {
                self.fSpeed=-self.fSpeed;
                break;
            }

            if (self.position.x>=13.5*TILE_WIDTH)
            {
                self.position=ccp(13.5*TILE_WIDTH,self.position.y);
                self.fSpeed=-self.fSpeed;
                break;
            }
            
            if ((self.position.x>tile.position.x)&&self.position.x-tile.position.x<=TILE_WIDTH&&fabs(tile.position.y-self.position.y)<TILE_WIDTH&&self.fSpeed<0)
            {
                self.fSpeed=-self.fSpeed;
                break;
            }

            if (self.position.x<=1.5*TILE_WIDTH)
            {
                self.position=ccp(1.5*TILE_WIDTH,self.position.y);
                self.fSpeed=-self.fSpeed;
                break;
            }
        }
        
        self.position=ccp(self.position.x+self.fSpeed,self.position.y);
        self.stepCount++;
    }
    
    if(self.kAct==kEnemyActVertical)
    {
        CCSprite *tile;
        BOOL upnEnable=NO;
        BOOL downnEnable=NO;
        if (self.position.y==0.5*TILE_HEIGHT)
        {
            downnEnable=YES;
        }
        if (self.position.y==8.5*TILE_HEIGHT)
        {
            upnEnable=YES;
        }
        for (int i=0; i<self.tileArray.count; i++)
        {
            tile=[self.tileArray objectAtIndex:i];
            if (tile.position.x==self.position.x&&self.position.y-tile.position.y==TILE_HEIGHT)
            {
                downnEnable=YES;
            }
            if (tile.position.x==self.position.x&&tile.position.y-self.position.y==TILE_WIDTH)
            {
                upnEnable=YES;
            }
        }
        if (downnEnable&&upnEnable)
        {
            self.kAct=kEnemyActHorizon;
            return;
        }
        
        for (int i=0; i<self.tileArray.count; i++)
        {
            tile=[self.tileArray objectAtIndex:i];
            if ((self.position.y<tile.position.y)&&tile.position.y-self.position.y<=TILE_HEIGHT&&fabs(tile.position.x-self.position.x)<TILE_WIDTH)
            {
                self.fSpeed=-self.fSpeed;
                break;
            }

            if (self.position.y>=(9-0.5)*TILE_HEIGHT)
            {
                self.position=ccp(self.position.x,(9-0.5)*TILE_HEIGHT);
                self.fSpeed=-self.fSpeed;
                break;
            }
            if ((self.position.y>tile.position.y)&&self.position.y-tile.position.y<=TILE_HEIGHT&&fabs(tile.position.x-self.position.x)<TILE_WIDTH)
            {
                self.fSpeed=-self.fSpeed;
                break;
            }

            if (self.position.y<=0.5*TILE_HEIGHT)
            {
                self.position=ccp(self.position.x,0.5*TILE_HEIGHT);
                self.fSpeed=-self.fSpeed;
                break;
            }
        }
        
        self.position=ccp(self.position.x,self.position.y+self.fSpeed);
        self.stepCount++;
//        NSLog(@"%i",self.stepCount);
    }
    if (self.stepCount>=64/NANDU)
    {
        if ((int)(self.position.x+0.5*TILE_WIDTH)%TILE_WIDTH==0&&self.kAct==kEnemyActHorizon)
        {
            self.kAct=kEnemyActVertical;
            self.stepCount=0;
        }
        else if ((int)(self.position.y+0.5*TILE_HEIGHT)%TILE_HEIGHT==0&&self.kAct==kEnemyActVertical)
        {
            self.kAct=kEnemyActHorizon;
            self.stepCount=0;
        }
    }
}

@end
