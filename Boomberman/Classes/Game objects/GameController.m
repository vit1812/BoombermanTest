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
#import "GameInfo.h"
#import "IntroScene.h"

@implementation GameController {

}

@synthesize hero    = _hero;
@synthesize enemyArray  = _enemyArray;

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
        
        // setup game info
        GameInfo *gameinf = [GameInfo sharedGameInf];
        level = gameinf.level;
        score = gameinf.score;
        time  = 120;

        [self initGameInfo];
    }
    return self;
}

#pragma mark - methods

- (void)initGameInfo
{
    scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"score: %i",score] fontName:@"Marker Felt" fontSize:32];
    scoreLabel.position = ccp(11.5*TILE_WIDTH,WIN_HEIGHT-TILE_HEIGHT/2);
    
    levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"level: %i",level] fontName:@"Marker Felt" fontSize:32];
    levelLabel.position = ccp(2.5*TILE_WIDTH,WIN_HEIGHT-TILE_HEIGHT/2);
    
    timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"time: %i",time] fontName:@"Marker Felt" fontSize:32];
    timeLabel.position = ccp(7*TILE_WIDTH,WIN_HEIGHT-TILE_HEIGHT/2);
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ X ]" fontName:@"Marker Felt" fontSize:22];
    backButton.position = ccp(455, 305); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    
    [self addChild:backButton];
    [self addChild:scoreLabel];
    [self addChild:levelLabel];
    [self addChild:timeLabel];
}

-(void) checkGameState
{
    if (self.enemyArray.count==0)
    {
        [self gameWin];
    }

    if (time<=0)
    {
        [self gameOver];
    }
}

-(void) gameOver
{
    [self unschedule:@selector(gameUpdate)];
    
    CCScene *scene=[MainScene scene];
    CCTransition *transitionScene   = [CCTransition transitionCrossFadeWithDuration:1];
    
    [[CCDirector sharedDirector] replaceScene:scene withTransition:transitionScene];
}

-(void) gameWin
{
    [self unschedule:@selector(gameUpdate)];
    
    [self loadNextlevel];
}

-(void) loadNextlevel
{
    GameInfo *gameinf=[GameInfo sharedGameInf];
    gameinf.score=score;
    gameinf.level=++level;
    
    CCScene *scene=[MainScene scene];
    CCTransition *transitionScene   = [CCTransition transitionCrossFadeWithDuration:1];
    
    [[CCDirector sharedDirector] replaceScene:scene withTransition:transitionScene];
}

-(void) gameUpdate
{
    [self checkHeroState];
    [self updateTimePlay];
    [self checkGameState];
}

- (void)updateTimePlay
{
    static int i=0;
    if (i==10)
    {
        time--;
        timeLabel.string = [NSString stringWithFormat:@"time: %i",time];
        i=0;
    }
    i++;
    
}

- (void)updateScoreWithAddScore:(int)iAddScore {
    score   = score + iAddScore;
    scoreLabel.string   = [NSString stringWithFormat:@"score: %i",score];
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
                
            case kNotificationMessageTypeDetroyTile: {
                [self updateScoreWithAddScore:TILE_SCORE];
                
                break;
            }
                
            case kNotificationMessageTypeDetroyEnemy: {
                [self updateScoreWithAddScore:ENEMY_SCORE];
                
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

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

#pragma mark - memory

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotifyForGameController object:nil];
}

@end
