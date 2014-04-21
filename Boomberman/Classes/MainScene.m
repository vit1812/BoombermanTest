//
//  HelloWorldScene.m
//  Boomberman
//
//  Created by LionKing on 4/21/14.
//  Copyright Anonymous 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "MainScene.h"
#import "IntroScene.h"
#import "CCSprite.h"
#import "CCSpriteFrameCache.h"
#import "GameController.h"
#import "GameHero.h"
#import "GameEnemy.h"
#import "GameShitou.h"
#import "GameZhuankuai.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation MainScene
{
    CCSprite *_sprite;
    CCPhysicsNode *_physicsWorld;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (MainScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    CCSpriteFrameCache *frameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"img.plist"];
    
    CCSprite *gr    = [CCSprite spriteWithImageNamed:@"background.png"];
    gr.anchorPoint=ccp(0,0);
    [self addChild:gr];
    
    GameController *gameController=[GameController node];
    [self addChild:gameController];
    
    // Create a physic world
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // hero
    GameHero *hero  = [[GameHero alloc] init]; //[[GameHero alloc] init];
    hero.position  = ccp(48,16);
    hero.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, hero.contentSize} cornerRadius:0]; // 1
    hero.physicsBody.collisionGroup = @"heroGroup"; // 2
    hero.physicsBody.collisionType  = @"heroCollision";
    [_physicsWorld addChild:hero];
    
    gameController.hero = hero;
    
    // enemy
    for (int i=0; i<4; i++)
    {
        GameEnemy *enemy=[GameEnemy node];
        enemy.position  = ccp((arc4random()%10) * 10, 200);
        enemy.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, enemy.contentSize} cornerRadius:0]; // 1
        enemy.physicsBody.collisionGroup = @"enemyGroup"; // 2
        enemy.physicsBody.collisionType  = @"enemyCollision";
        [_physicsWorld addChild:enemy];
    }
    
    // Shitou
    for (int i=3; i<=SCENE_WIDTH/TILE_WIDTH; i+=2)
    {
        for (int j=2; j<=SCENE_HEIGHT/TILE_HEIGHT; j+=2)
        {
            CCSprite *shitou    = [GameShitou node];
            shitou.position     = ccp((i-0.5)*TILE_WIDTH,(j-0.5)*TILE_HEIGHT);
            shitou.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, shitou.contentSize} cornerRadius:0]; // 1
            shitou.physicsBody.collisionGroup = @"shitouGroup"; // 2
            shitou.physicsBody.collisionType  = @"shitouCollision";
            [_physicsWorld addChild:shitou];
        }
    }
    
    // Zhuankuai
    for (int i=2; i<=SCENE_WIDTH/TILE_WIDTH+1; i+=1)
    {
        for (int j=1; j<=SCENE_HEIGHT/TILE_HEIGHT+1; j+=2)
        {
            if ((i==2&&j==1)||(i==2&&j==2)||(i==3&&j==1))
            {
                continue;
            }
            if (arc4random()%10<1)
            {
                CCSprite *zhuankuai = [GameZhuankuai node];
                zhuankuai.position=ccp((i-0.5)*TILE_WIDTH,(j-0.5)*TILE_HEIGHT);
                zhuankuai.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, zhuankuai.contentSize} cornerRadius:0]; // 1
                zhuankuai.physicsBody.collisionGroup = @"zhuankuaiGroup"; // 2
                zhuankuai.physicsBody.collisionType  = @"zhuankuaiCollision";
                [_physicsWorld addChild:zhuankuai];
            }
        }
    }

    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
