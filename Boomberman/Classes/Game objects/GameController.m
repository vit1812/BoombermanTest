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
#import "MainScene.h"
#import "NotificationObject.h"

@implementation GameController {

}

@synthesize hero    = _hero;

#pragma mark - init

-(id) init
{
    if (self=[super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:NotifyForGameController object:nil];
        
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
        
        [self schedule:@selector(gameUpdate) interval:1/10.0];
    }
    return self;
}

#pragma mark - methods

-(void) gameUpdate
{
    [self checkHeroState];
}

-(void) checkHeroState
{
    switch (self.hero.kAct)
    {
        case kHeroActUp:
            [self.hero MoveUp];
            break;
        case kHeroActLeft:
            [self.hero MoveLeft];
            break;
        case kHeroActRight:
            [self.hero MoveRight];
            break;
        case kHeroActDown:
            [self.hero MoveDown];
            break;
        case kHeroActFire:
            [self.hero putBomb];
            break;
        case kHeroActStay:
            [self.hero OnStay];
            break;
        default:
            break;
    }
}

-(void) gameOver
{
    [self unschedule:@selector(gameUpdate)];

    CCScene *scene=[MainScene scene];
    CCTransition *transitionScene   = [CCTransition transitionCrossFadeWithDuration:1];
    
    [[CCDirector sharedDirector] replaceScene:scene withTransition:transitionScene];
}

#pragma mark - notify handler

- (void)receiveNotification:(NSNotification *)notification {
    id obj = [notification object];
    
    if ([obj isKindOfClass:[NotificationObject class]]) {
        NotificationObject *notifyObject = (NotificationObject *)obj;
        
        switch (notifyObject.notificationType) {
            case kNotificationMessageTypeGameeOver: {
                [self gameOver];
                
                break;
            }
                
            default:
                break;
        }
    }
    
    // reset observer (tranh duplicate notify)
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotifyForGameController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:NotifyForGameController object:nil];
}

#pragma mark - touch handler

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location=[touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL: location];
    CGPoint touchpos=[Utils convertToTilePos:location];
    
    if (touchpos.x==0.5*TILE_WIDTH&&touchpos.y==0.5*TILE_HEIGHT)
    {
        self.hero.kAct  = kHeroActLeft;
    }
    if (touchpos.x==2.5*TILE_WIDTH&&touchpos.y==0.5*TILE_HEIGHT)
    {
        self.hero.kAct  = kHeroActRight;
    }
    if (touchpos.x==1.5*TILE_WIDTH&&touchpos.y==0.5*TILE_HEIGHT)
    {
        self.hero.kAct  = kHeroActDown;
    }
    if (touchpos.x==1.5*TILE_WIDTH&&touchpos.y==1.5*TILE_HEIGHT)
    {
        self.hero.kAct  = kHeroActUp;
    }
    if (touchpos.x==14.5*TILE_WIDTH&&touchpos.y==0.5*TILE_HEIGHT)
    {
        self.hero.kAct  = kHeroActFire;
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    self.hero.kAct  = kHeroActStay;
}

#pragma mark - memory

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotifyForGameController object:nil];
}

@end
