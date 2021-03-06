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
#import "GameBomb.h"
#import "NotificationObject.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@interface MainScene ()

@property (nonatomic) NSMutableArray *arrTileArray;
@property (nonatomic) NSMutableArray *arrEnemyArray;
@property (nonatomic) NSMutableArray *arrNullPointArray;
@property (nonatomic) GameController *gameController;

@end

@implementation MainScene
{
    CCSprite *_sprite;
    CCPhysicsNode *_physicsWorld;
}

@synthesize arrTileArray    = _arrTileArray;
@synthesize arrEnemyArray   = _arrEnemyArray;
@synthesize arrNullPointArray   = _arrNullPointArray;
@synthesize iEnemyNum   = _iEnemyNum;
@synthesize gameController  = _gameController;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:NotifyForMainScene object:nil];
    
    _iEnemyNum  = 4;

    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // init background, cache sprite
    CCSpriteFrameCache *frameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"img.plist"];
    
    CCSprite *gr    = [CCSprite spriteWithImageNamed:@"background.png"];
    gr.anchorPoint=ccp(0,0);
    [self addChild:gr];
    
    GameController *gameController=[GameController node];
    self.gameController = gameController;
    [self addChild:gameController];
    
    // Create a physic world
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.collisionDelegate = self;
    _physicsWorld.debugDraw = NO;
    [self addChild:_physicsWorld];
    
    // Shitou
    for (int i=3; i<=SCENE_WIDTH/TILE_WIDTH; i+=2)
    {
        for (int j=2; j<=SCENE_HEIGHT/TILE_HEIGHT; j+=2)
        {
            GameShitou *shitou    = [GameShitou node];
            shitou.position     = ccp((i-0.5)*TILE_WIDTH,(j-0.5)*TILE_HEIGHT);
            [_physicsWorld addChild:shitou];
            
            [self.arrTileArray addObject:shitou];
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
                GameZhuankuai *zhuankuai = [GameZhuankuai node];
                zhuankuai.position=ccp((i-0.5)*TILE_WIDTH,(j-0.5)*TILE_HEIGHT);
                [_physicsWorld addChild:zhuankuai];
                
                [self.arrTileArray addObject:zhuankuai];
            }
            else
            {
                CGPoint point=ccp((i-0.5)*TILE_WIDTH,(j-0.5)*TILE_HEIGHT);
                [self.arrNullPointArray addObject:[NSValue valueWithCGPoint:point]];
            }
        }
    }
    
    // hero
    GameHero *hero  = [[GameHero alloc] init];
    hero.position  = ccp(48,16);
    hero.tileArray  = self.arrTileArray;
    [_physicsWorld addChild:hero];
    
    gameController.hero = hero;
    
    // enemy
    for (int i=0; i<self.iEnemyNum; i++)
    {
        NSValue *point=[self.arrNullPointArray objectAtIndex:arc4random()%self.arrNullPointArray.count];//随即获取一处空位置
        GameEnemy *enemy=[GameEnemy node];
        enemy.position  = [point CGPointValue];
        enemy.tileArray = self.arrTileArray;
        [_physicsWorld addChild:enemy];
        
        [self.arrNullPointArray removeObject:point];
        [self.arrEnemyArray addObject:enemy];
    }
    
    self.gameController.enemyArray  = self.arrEnemyArray;
    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotifyForMainScene object:nil];
}

// -----------------------------------------------------------------------
#pragma mark - Properties
// -----------------------------------------------------------------------

- (NSMutableArray *)arrEnemyArray {
    if (_arrEnemyArray == nil) {
        _arrEnemyArray   = [NSMutableArray array];
    }
    
    return _arrEnemyArray;
}

- (NSMutableArray *)arrTileArray {
    if (_arrTileArray == nil) {
        _arrTileArray   = [NSMutableArray array];
    }
    
    return _arrTileArray;
}

- (NSMutableArray *)arrNullPointArray {
    if (_arrNullPointArray == nil) {
        _arrNullPointArray  = [NSMutableArray array];
    }
    
    return _arrNullPointArray;
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

#pragma mark - notify handler

- (void)handleWhenBombDown:(GameBomb *)bomb {
    for (int i=0; i<self.arrEnemyArray.count; i++)
    {
        GameEnemy *enemy=[self.arrEnemyArray objectAtIndex:i];
        if ((fabs(bomb.position.x-enemy.position.x)<TILE_WIDTH||fabs(bomb.position.y-enemy.position.y)<TILE_HEIGHT)&&ccpDistance(bomb.position, enemy.position)<=TILE_WIDTH*2)
        {
            [self.arrEnemyArray removeObject:enemy];
            [enemy unschedule:@selector(enemyMove)];
            [enemy enemyKill];
            i--;
            
            NotificationObject *noObject    = [[NotificationObject alloc] initWithType:kNotificationMessageTypeDetroyEnemy object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyForGameController object:noObject];
        }
    }
}

- (void)receiveNotification:(NSNotification *)notification {
    id obj = [notification object];
    
    if ([obj isKindOfClass:[NotificationObject class]]) {
        NotificationObject *notifyObject = (NotificationObject *)obj;
        
        switch (notifyObject.notificationType) {
            case kNotificationMessageTypeBombDown: {
                GameBomb *bomb  = (GameBomb *)notifyObject.notificationObject;
                
                [self handleWhenBombDown:bomb];
                
                break;
            }
                
            default:
                break;
        }
    }
    
    // reset observer (tranh duplicate notify)
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotifyForMainScene object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:NotifyForMainScene object:nil];
}

#pragma mark - Collision handler

// -----------------------------------------------------------------------
// hero collision

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heroCollision:(CCNode *)hero enemyCollision:(CCNode *)enemy {
    [self.gameController gameOver];
    
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heroCollision:(CCNode *)hero bombCollision:(CCNode *)bomb {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heroCollision:(CCNode *)hero bombEffectCollision:(CCNode *)bombEffect {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heroCollision:(CCNode *)hero shitouCollision:(CCNode *)shitou {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heroCollision:(CCNode *)hero zhuankuaiCollision:(CCNode *)zhuankuai {
    return NO;
}

// -----------------------------------------------------------------------
// bomb collision

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bombCollision:(CCNode *)bomb enemyCollision:(CCNode *)enemy {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bombCollision:(CCNode *)bomb bombEffectCollision:(CCNode *)bombEffect {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bombCollision:(CCNode *)bomb shitouCollision:(CCNode *)shitou {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bombCollision:(CCNode *)bomb zhuankuaiCollision:(CCNode *)zhuankuai {
    return NO;
}

// -----------------------------------------------------------------------
// bomb effect collision

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bombEffectCollision:(CCNode *)bombEffect enemyCollision:(CCNode *)enemy {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bombEffectCollision:(CCNode *)bombEffect shitouCollision:(CCNode *)shitou {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bombEffectCollision:(CCNode *)bombEffect zhuankuaiCollision:(CCNode *)zhuankuai {
    return NO;
}

// -----------------------------------------------------------------------
// enemy collision

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy shitouCollision:(CCNode *)shitou {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy zhuankuaiCollision:(CCNode *)zhuankuai {
    return NO;
}

// -----------------------------------------------------------------------
// shitou collision

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair shitouCollision:(CCNode *)shitou zhuankuaiCollision:(CCNode *)zhuankuai {
    return NO;
}

@end
