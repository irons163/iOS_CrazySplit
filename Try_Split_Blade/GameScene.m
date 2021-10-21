//
//  GameScene.m
//  Try_Split_Blade
//
//  Created by irons on 2015/9/4.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameScene.h"
#import "TextureHelper.h"
#import "CommonUtil.h"
#import "GameViewController.h"
#import "GameCenterUtil.h"
#import "SKBlade.h"
#import "ClearableSprite.h"
#import "MyADView.h"
#import "MyUtils.h"

#define DEFAULT_HP  20

const int stay = 0;
const int left = 1;
const int right = 2;

const int moveDestance = 15;

const static int PLAYER_STAY_LEFT_INDEX = 0;

const int backgroundLayerZPosition = -3;

const int NONE_MODE = -1;
const int INFINITY_MODE = 0;
const int BREAK_GAME_MODE = 1;

@implementation GameScene {
    int walkCount;
    int gameTime;
    float fireballInterval;
    bool isGameRun;
    bool isPressLeftMoveBtn;
    bool isPressRightMoveBtn;
    int key;
    bool isMoving;
    int gamePointX;
    int64_t gameScore;
    
    NSTimer *theGameTimer;
    
    SKSpriteNode *backgroundNode;
    SKLabelNode *clearedMonsterLabel;
    SKSpriteNode *player;
    
    SKSpriteNode *leftKey;
    SKSpriteNode *rightKey;
    SKSpriteNode *rankBtn;
    SKSpriteNode *pauseBtnNode;
    
    NSMutableArray *fireballs;
    NSMutableArray *footbardsByLines;
    
    NSArray *hamsterDefaultArray;
    NSArray *rightNsArray;
    NSArray *leftNsArray;
    
    SKBlade *blade;
    CGPoint _delta;
    
    SKSpriteNode *gamePointSingleNode, *gamePointTenNode,
    *gamePointHunNode, *gamePointTHUNode, *gamePoint10THUNode,
    *gamePoint100THUNode, *gamePoint1MNode, *gamePoint10MNode,
    *gamePoint100MNode, *gamePoint1BNode, *gamePoint10BNode;
    SKSpriteNode *modeBtn;
    
    int willChangeGameMode;
    
    NSMutableArray *musicBtnTextures;
    SKSpriteNode *musicBtn;
    
    MyADView *myAdView;
}

- (void)initTextures {
    hamsterDefaultArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7 sequence:@[@7]];
    
    rightNsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7 sequence:@[@5,@6]];
    
    leftNsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7 sequence:@[@5,@6]];
}

- (void)initGameTimeTextLabel {
    clearedMonsterLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    clearedMonsterLabel.text = @"00:00:00";
    clearedMonsterLabel.fontSize = 20;
    clearedMonsterLabel.color = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    clearedMonsterLabel.position = CGPointMake(clearedMonsterLabel.frame.size.width/2, self.frame.size.height - 100 - clearedMonsterLabel.frame.size.height);
    
    [self addChild:clearedMonsterLabel];
}

- (void)initGamePoint {
    int gamePointNodeWH = 30;
    
    gamePointX = self.frame.size.width - gamePointNodeWH;
    int gamePointY = self.frame.size.height * 6 / 8.0;
    
    gamePointSingleNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:gameScore % 10]];
    gamePointSingleNode.anchorPoint = CGPointMake(0, 0);
    gamePointSingleNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePointSingleNode.position = CGPointMake(gamePointX, gamePointY);
    
    gamePointTenNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore) / 10 % 10]];
    gamePointTenNode.anchorPoint = CGPointMake(0, 0);
    gamePointTenNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePointTenNode.position = CGPointMake(gamePointX - gamePointNodeWH, gamePointY);
    
    gamePointHunNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore) / 100 % 10]];
    gamePointHunNode.anchorPoint = CGPointMake(0, 0);
    gamePointHunNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePointHunNode.position = CGPointMake(gamePointX - gamePointNodeWH*2, gamePointY);
    
    gamePointTHUNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore) / 1000 % 10]];
    gamePointTHUNode.anchorPoint = CGPointMake(0, 0);
    gamePointTHUNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePointTHUNode.position = CGPointMake(gamePointX - gamePointNodeWH*3, gamePointY);
    
    gamePoint10THUNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore) / 10000 % 10]];
    gamePoint10THUNode.anchorPoint = CGPointMake(0, 0);
    gamePoint10THUNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePoint10THUNode.position = CGPointMake(gamePointX - gamePointNodeWH*4, gamePointY);
    
    gamePoint100THUNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore) / 100000 % 10]];
    gamePoint100THUNode.anchorPoint = CGPointMake(0, 0);
    gamePoint100THUNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePoint100THUNode.position = CGPointMake(gamePointX - gamePointNodeWH*5, gamePointY);
    
    gamePoint1MNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore) / 1000000 % 10]];
    gamePoint1MNode.anchorPoint = CGPointMake(0, 0);
    gamePoint1MNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePoint1MNode.position = CGPointMake(gamePointX - gamePointNodeWH * 6, gamePointY);
    
    gamePoint10MNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore) / 10000000 % 10]];
    gamePoint10MNode.anchorPoint = CGPointMake(0, 0);
    gamePoint10MNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePoint10MNode.position = CGPointMake(gamePointX - gamePointNodeWH*7, gamePointY);
    
    gamePoint100MNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore) / 100000000 % 10]];
    gamePoint100MNode.anchorPoint = CGPointMake(0, 0);
    gamePoint100MNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePoint100MNode.position = CGPointMake(gamePointX - gamePointNodeWH * 8, gamePointY);
    
    gamePoint1BNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore) / 1000000000 % 10]];
    gamePoint1BNode.anchorPoint = CGPointMake(0, 0);
    gamePoint1BNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
    gamePoint1BNode.position = CGPointMake(gamePointX - gamePointNodeWH * 9, gamePointY);
    
    [self addChild:gamePointSingleNode];
    [self addChild:gamePointTenNode];
    [self addChild:gamePointHunNode];
    [self addChild:gamePointTHUNode];
    [self addChild:gamePoint10THUNode];
    [self addChild:gamePoint100THUNode];
    [self addChild:gamePoint1MNode];
    [self addChild:gamePoint10MNode];
    [self addChild:gamePoint100MNode];
    [self addChild:gamePoint1BNode];
}

- (void)showGamePoint {
    gamePointSingleNode.hidden = NO;
    gamePointTenNode.hidden = NO;
    gamePointHunNode.hidden = NO;
    gamePointTHUNode.hidden = NO;
    gamePoint10THUNode.hidden = NO;
    gamePoint100THUNode.hidden = NO;
    gamePoint1MNode.hidden = NO;
    gamePoint10MNode.hidden = NO;
    gamePoint100MNode.hidden = NO;
    gamePoint1BNode.hidden = NO;
}

- (void)hidegamePoint {
    gamePointSingleNode.hidden = YES;
    gamePointTenNode.hidden = YES;
    gamePointHunNode.hidden = YES;
    gamePointTHUNode.hidden = YES;
    gamePoint10THUNode.hidden = YES;
    gamePoint100THUNode.hidden = YES;
    gamePoint1MNode.hidden = YES;
    gamePoint10MNode.hidden = YES;
    gamePoint100MNode.hidden = YES;
    gamePoint1BNode.hidden = YES;
}

- (void)showGameTime {
    clearedMonsterLabel.hidden = NO;
}

- (void)hideGameTime {
    clearedMonsterLabel.hidden = YES;
}

- (void)changeGamePoint {
    [[NSUserDefaults standardUserDefaults] setInteger:gameScore forKey:@"gameScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    gamePointSingleNode.texture = [self getTimeTexture:gameScore % 10];
    gamePointTenNode.texture = [self getTimeTexture:(gameScore) / 10 % 10];
    gamePointHunNode.texture = [self getTimeTexture:(gameScore) / 100 % 10];
    gamePointTHUNode.texture = [self getTimeTexture:(gameScore) / 1000 % 10];
    gamePoint10THUNode.texture = [self getTimeTexture:(gameScore) / 10000 % 10];
    gamePoint100THUNode.texture = [self getTimeTexture:(gameScore) / 100000 % 10];
    gamePoint1MNode.texture = [self getTimeTexture:(gameScore) / 1000000 % 10];
    gamePoint10MNode.texture = [self getTimeTexture:(gameScore) / 10000000 % 10];
    gamePoint100MNode.texture = [self getTimeTexture:(gameScore) / 100000000 % 10];
    gamePoint1BNode.texture = [self getTimeTexture:(gameScore) / 1000000000 % 10];
}

- (void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    fireballInterval = 0.4;
    isGameRun = true;
    isMoving = false;
    
    [TextureHelper initTextures];
    
    [self initTextures];
    [self initGameTimeTextLabel];
    [self initGamePoint];
    
    musicBtnTextures = [NSMutableArray array];
    [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music-hd"]];
    [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music_Select-hd"]];
    
    fireballs = [NSMutableArray array];
    footbardsByLines = [NSMutableArray array];
    
    backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"bg02"];
    backgroundNode.size = self.frame.size;
    backgroundNode.anchorPoint = CGPointMake(0, 0);
    backgroundNode.zPosition = backgroundLayerZPosition;
    [self addChild:backgroundNode];
    
    leftKey = [SKSpriteNode spriteNodeWithImageNamed:@"left_keyboard_btn"];
    leftKey.size = CGSizeMake(80, 80);
    leftKey.position = CGPointMake(0, 0);
    leftKey.anchorPoint = CGPointMake(0, 0);
    
    rightKey = [SKSpriteNode spriteNodeWithImageNamed:@"right_keyboard_btn"];
    rightKey.size = CGSizeMake(80, 80);
    rightKey.position = CGPointMake(self.frame.size.width - rightKey.size.width, 0);
    rightKey.anchorPoint = CGPointMake(0, 0);
    
    player = [SKSpriteNode spriteNodeWithTexture:hamsterDefaultArray[PLAYER_STAY_LEFT_INDEX]];
    player.size = CGSizeMake(60, 60);
    player.position = CGPointMake(self.frame.size.width / 2, player.size.height / 2 + 70);
    
    [self addChild:leftKey];
    [self addChild:rightKey];
    [self addChild:player];
    
    leftKey.hidden = YES;
    rightKey.hidden = YES;
    
    pauseBtnNode = [SKSpriteNode spriteNodeWithImageNamed:@"game_resume_btn"];
    pauseBtnNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 100);
    pauseBtnNode.size = CGSizeMake(50, 50);
    pauseBtnNode.hidden = true;
    [self addChild:pauseBtnNode];
    
    [self initGameTimer];
    
    myAdView = [MyADView spriteNodeWithTexture:nil];
    myAdView.size = CGSizeMake(self.frame.size.width, self.frame.size.width / 5.0f);
    myAdView.position = CGPointMake(self.frame.size.width / 2, 0);
    [myAdView startAd];
    myAdView.zPosition = 1;
    myAdView.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:myAdView];
    
    rankBtn = [SKSpriteNode spriteNodeWithImageNamed:@"leader_board_btn"];
    rankBtn.size = CGSizeMake(42,42);
    rankBtn.anchorPoint = CGPointMake(0, 0);
    rankBtn.position = CGPointMake(self.frame.size.width - rankBtn.size.width, self.frame.size.height / 2);
    [self addChild:rankBtn];
    
    modeBtn = [SKSpriteNode spriteNodeWithImageNamed:@"images"];
    modeBtn.size = CGSizeMake(42,42);
    modeBtn.anchorPoint = CGPointMake(0, 0);
    modeBtn.position = CGPointMake(self.frame.size.width - modeBtn.size.width, self.frame.size.height / 2 - modeBtn.size.height * 2);
    [self addChild:modeBtn];
    
    musicBtn = [SKSpriteNode spriteNodeWithImageNamed:@"btn_Music-hd"];
    musicBtn.size = CGSizeMake(42,42);
    musicBtn.anchorPoint = CGPointMake(0, 0);
    musicBtn.position = CGPointMake(self.frame.size.width - musicBtn.size.width, self.frame.size.height / 2 - 42);
    [self addChild:musicBtn];
    
    NSArray* musics = [NSArray arrayWithObjects:@"am_white.mp3", @"biai.mp3", @"cafe.mp3", @"deformation.mp3", nil];
    
    int index = arc4random_uniform(4);
    [MyUtils preparePlayBackgroundMusic:musics[index]];
    
    id isPlayMusicObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"isPlayMusic"];
    BOOL isPlayMusic = true;
    if (isPlayMusicObject == nil) {
        isPlayMusicObject = false;
    } else {
        isPlayMusic = [isPlayMusicObject boolValue];
    }
    
    if (isPlayMusic) {
        [MyUtils backgroundMusicPlayerPlay];
        musicBtn.texture = musicBtnTextures[0];
    } else {
        [MyUtils backgroundMusicPlayerPause];
        musicBtn.texture = musicBtnTextures[1];
    }
    
    willChangeGameMode = NONE_MODE;
    
    if (self.gameMode == INFINITY_MODE) {
        [self changeToInfiniteMode];
    } else if (self.gameMode == BREAK_GAME_MODE) {
        [self changeToBreakGameMode];
    }
}

- (void)setGameTimeNodeText {
    NSString *s = [CommonUtil timeFormatted:gameTime];
    
    clearedMonsterLabel.text = s;
    clearedMonsterLabel.position = CGPointMake(clearedMonsterLabel.frame.size.width/2, self.frame.size.height - 100 - clearedMonsterLabel.frame.size.height);
}

- (void)initGameTimer {
    theGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(countGameTime)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)countGameTime {
    if (!isGameRun) {
        return;
    }
    
    gameTime++;
    
    if (gameTime == 20) {
        fireballInterval = 0.35;
    } else if (gameTime == 40) {
        fireballInterval = 0.3;
    } else if (gameTime == 60) {
        fireballInterval = 0.25;
    } else if (gameTime == 90) {
        fireballInterval = 0.2;
    } else if (gameTime == 140) {
        fireballInterval = 0.15;
    } else if (gameTime == 200) {
        fireballInterval = 0.1;
    } else if (gameTime == 260) {
        fireballInterval = 0.06;
    } else if (gameTime == 360) {
        fireballInterval = 0.04;
    }
    
    [self setGameTimeNodeText];
}

- (void)hitEnemy:(SKSpriteNode *)enemy withLocation:(CGPoint)position {
    SKTexture * rainTexture = [SKTexture textureWithImageNamed:@"bubble_1.png"];
    SKEmitterNode * emitterNode = [[SKEmitterNode alloc] init];
    emitterNode.particleTexture = rainTexture;
    emitterNode.particleBirthRate = 80.0;
    emitterNode.particleColor = [UIColor whiteColor];
    emitterNode.particleSpeed = -450;
    emitterNode.particleSpeedRange = 150;
    emitterNode.particleLifetime = 2.0;
    emitterNode.particleScale = 0.2;
    emitterNode.particleAlpha = 0.75;
    emitterNode.particleAlphaRange = 0.5;
    emitterNode.particleColorBlendFactor = 1;
    emitterNode.particleScale = 0.2;
    emitterNode.particleScaleRange = 0.5;
    emitterNode.position = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) + 10);
    emitterNode.particlePositionRange = CGVectorMake(CGRectGetMaxX(self.frame),0);
    
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"MySpark" ofType:@"sks"];
    SKEmitterNode *rainEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    rainEmitter.position = position;
    [self addChild:rainEmitter];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        [myAdView touchesBegan:touches withEvent:event];
        
        if (pauseBtnNode.hidden == false) {
            if (CGRectContainsPoint(pauseBtnNode.calculateAccumulatedFrame, location)) {
                [self setGameRun:YES];
                [self setPaused:false];
            }
        } else if (CGRectContainsPoint(leftKey.calculateAccumulatedFrame, location)) {
            isPressLeftMoveBtn = true;
            key = left;
        } else if (CGRectContainsPoint(rightKey.calculateAccumulatedFrame, location)) {
            isPressRightMoveBtn = true;
            key = right;
        } else if (CGRectContainsPoint(rankBtn.calculateAccumulatedFrame, location)) {
            [self.gameDelegate showRankView];
        } else if (CGRectContainsPoint(modeBtn.calculateAccumulatedFrame, location)) {
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"InfinityMode", @""),NSLocalizedString(@"BreakthroughMode", @""), nil];
            [actionSheet showInView:self.view];
        } else if (CGRectContainsPoint(musicBtn.calculateAccumulatedFrame, location)) {
            if ([MyUtils isBackgroundMusicPlayerPlaying]) {
                [MyUtils backgroundMusicPlayerPause];
                musicBtn.texture = musicBtnTextures[1];
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isPlayMusic"];
            } else {
                [MyUtils backgroundMusicPlayerPlay];
                musicBtn.texture = musicBtnTextures[0];
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isPlayMusic"];
            }
        }
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    [self presentBladeAtPosition:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if(isPressLeftMoveBtn && isPressRightMoveBtn){
            
            if(CGRectContainsPoint(leftKey.calculateAccumulatedFrame, location)){
                isPressLeftMoveBtn = false;
                key = right;
            }else if(CGRectContainsPoint(rightKey.calculateAccumulatedFrame, location)){
                isPressRightMoveBtn = false;
                key = left;
            }
            
        } else if (isPressLeftMoveBtn || isPressRightMoveBtn) {
            
            if(CGRectContainsPoint(leftKey.calculateAccumulatedFrame, location) || CGRectContainsPoint(rightKey.calculateAccumulatedFrame, location)){
                
                if (isPressLeftMoveBtn) {
                    isPressLeftMoveBtn = !isPressLeftMoveBtn;
                } else if (isPressRightMoveBtn) {
                    isPressRightMoveBtn = !isPressRightMoveBtn;
                }
                
                [player removeAllActions];
                
                if (key == left) {
                    player.texture = hamsterDefaultArray[PLAYER_STAY_LEFT_INDEX];
                } else if(key == right) {
                    player.texture = hamsterDefaultArray[PLAYER_STAY_LEFT_INDEX];
                }
                
                key = stay;
                isMoving = false;
                player.xScale = 1;
            }
            
        }
    }
    
    [self removeBlade];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self removeBlade];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint _currentPoint = [[touches anyObject] locationInNode:self];
    CGPoint _previousPoint = [[touches anyObject] previousLocationInNode:self];
    _delta = CGPointMake(_currentPoint.x - _previousPoint.x, _currentPoint.y - _previousPoint.y);
}

#pragma mark - SKBlade Functions

- (void)presentBladeAtPosition:(CGPoint)position {
    blade = [[SKBlade alloc] initWithPosition:position TargetNode:self Color:[UIColor redColor]];
    [self addChild:blade];
}

- (void)removeBlade {
    _delta = CGPointZero;
    [blade removeFromParent];
    blade = nil;
}

- (void)setGameRun:(bool)isrun {
    [self setViewRun:isrun];
    [self setPauseBtnHidden:isrun];
}

- (void)setPauseBtnHidden:(bool)isrun {
    pauseBtnNode.hidden = isrun;
}

- (void)setViewRun:(bool)isrun {
    isGameRun = isrun;
    
    for (int i = 0; i < [self children].count; i++) {
        SKNode *n = [self children][i];
        n.paused = !isrun;
    }
}

- (void)beHited {
    [self setViewRun:false];
    [self reportBreakGameModeScore];
    [self.gameDelegate showGameOver];
}

- (void)checkPlayerMoved {
    [player removeAllActions];
    
    if (key == left) {
        player.xScale = 1;
        
        if(!isMoving){
            isMoving = true;
            SKAction *move = [SKAction animateWithTextures:leftNsArray timePerFrame:0.2];
            SKAction *moveL = [SKAction runBlock:^{
                
                if(player.position.x - moveDestance < 0){
                    key = right;
                    [self checkPlayerMoved ];
                    return;
                }
                player.position = CGPointMake(player.position.x - moveDestance, player.position.y);
            }];
            SKAction *sequence = [SKAction sequence:@[moveL, move]];
            [player runAction:[SKAction repeatActionForever:sequence]];
        }
    } else if(key == right) {
        player.xScale = -1;
        
        if(!isMoving){
            isMoving = true;
            SKAction *move = [SKAction animateWithTextures:rightNsArray timePerFrame:0.2];
            SKAction *moveR = [SKAction runBlock:^{
                if(player.position.x + moveDestance > self.frame.size.width - player.size.width){
                    key = left;
                    [self checkPlayerMoved ];
                    return;
                }
                player.position = CGPointMake(player.position.x + moveDestance, player.position.y);
            }];
            SKAction *sequence = [SKAction sequence:@[moveR,move]];
            [player runAction:[SKAction repeatActionForever:sequence]];
        }
    }
}

- (void)clearFireballAfterHitFootboard:(NSMutableArray *)fireballWillClear {
    for (SKSpriteNode *fireball in fireballWillClear) {
        [fireball removeFromParent];
        [fireballs removeObject:fireball];
    }
    [fireballWillClear removeAllObjects];
}

- (void)clearFireball {
    for (SKSpriteNode *fireball in fireballs) {
        [fireball removeFromParent];
        [fireballs removeObject:fireball];
    }
}

- (int)gameTime {
    return gameTime;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.lastSpawnTimeInterval += timeSinceLast;
    self.lastSpawnMoveTimeInterval += timeSinceLast;
    self.lastSpawnCreateFootboardTimeInterval += timeSinceLast;
    
    for (int i = 0; i < fireballs.count; i++) {
        SKSpriteNode * fireballForCheck = fireballs[i];
        CGRect playerFreme = player.calculateAccumulatedFrame;
        CGRect fireballFreme = fireballForCheck.calculateAccumulatedFrame;
        float collisionWdith = fireballFreme.size.width/3;
        float collisionHeight = fireballFreme.size.height/2;
        CGRect fireballCollisionFrame = CGRectMake(fireballFreme.origin.x + fireballFreme.size.width/2 - collisionWdith/2, fireballFreme.origin.y + collisionHeight/3*2, collisionWdith, collisionHeight);
        
        if (self.gameMode==BREAK_GAME_MODE && CGRectIntersectsRect(fireballCollisionFrame, playerFreme)) {
            [self beHited];
        }
    }
    
    if (self.lastSpawnMoveTimeInterval > 0.8) {
        self.lastSpawnMoveTimeInterval = 0;
        
        int random = arc4random_uniform(2);
        
        if(random==0){
            key = left;
        }else{
            key = right;
        }
        
        isMoving = false;
        [self checkPlayerMoved];
    }
    
    if (self.lastSpawnTimeInterval > fireballInterval) {
        self.lastSpawnTimeInterval = 0;
        
        ClearableSprite * fireball;
        if(self.gameMode == INFINITY_MODE){
            int random = arc4random_uniform(3);
            switch (random) {
                case 0:
                    fireball = [ClearableSprite spriteNodeWithImageNamed:@"coin_10_btn01"];
                    fireball.type = COIN_10;
                    break;
                case 1:
                    fireball = [ClearableSprite spriteNodeWithImageNamed:@"coin_30_btn01"];
                    fireball.type = COIN_30;
                    break;
                case 2:
                    fireball = [ClearableSprite spriteNodeWithImageNamed:@"coin_50_btn01"];
                    fireball.type = COIN_50;
                    break;
                default:
                    break;
            }
            fireball.size = CGSizeMake(70, 70);
        }else{
            fireball = [ClearableSprite spriteNodeWithImageNamed:@"fireball"];
            fireball.type = FIRE_BALL;
            fireball.size = CGSizeMake(50, 70);
        }
        
        
        int x = arc4random_uniform(self.frame.size.width - fireball.size.width);
        fireball.anchorPoint = CGPointMake(0, 0);
        fireball.position = CGPointMake(x, self.frame.size.height);
        
        [self addChild:fireball];
        [fireballs addObject:fireball];
        
        SKAction * move = [SKAction moveToY:0 duration:1.5];
        SKAction * end = [SKAction runBlock:^{
            [fireball removeFromParent];
            [fireballs removeObject:fireball];
        }];
        
        [fireball runAction:[SKAction sequence:@[move, end]]];
    }
    
    if (self.lastSpawnCreateFootboardTimeInterval > 0.1) {
        self.lastSpawnCreateFootboardTimeInterval = 0;
        
        if (willChangeGameMode != NONE_MODE) {
            self.gameMode = willChangeGameMode;
            switch (self.gameMode) {
                case INFINITY_MODE:
                    [self changeToInfiniteMode];
                    break;
                case BREAK_GAME_MODE:
                    [self changeToBreakGameMode];
                    break;
                default:
                    break;
            }
            willChangeGameMode = NONE_MODE;
            return;
        }
    }
}

- (void)update:(CFTimeInterval)currentTime {
    if(!isGameRun){
        [self setViewRun:false];
        return;
    }
    
    blade.position = CGPointMake(blade.position.x + _delta.x, blade.position.y + _delta.y);
    
    for (int i = 0; i < fireballs.count ; i++) {
        if (CGRectContainsPoint([fireballs[i] calculateAccumulatedFrame], blade.position)) {
            [self hitEnemy:nil withLocation:blade.position];
            [self doKill:fireballs[i]];
            i--;
            
            if (self.gameMode == INFINITY_MODE) {
                [[NSUserDefaults standardUserDefaults] setInteger:gameScore forKey:@"score"];
                [self reportInfinityModeScore];
            }
            
            break;
        }
    }
    
    _delta = CGPointZero;
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)doKill:(ClearableSprite *)target {
    switch (target.type) {
        case FIRE_BALL:
            [self runHitAction:target];
            break;
        case COIN_10:
            gameScore += 10;
            [self changeGamePoint];
            [self runHitAction:target];
            break;
        case COIN_30:
            gameScore += 30;
            [self changeGamePoint];
            [self runHitAction:target];
            break;
        case COIN_50:
            gameScore += 50;
            [self changeGamePoint];
            [self runHitAction:target];
            break;
        default:
            break;
    }
}

- (void)reportInfinityModeScore {
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:gameScore forCategory:@"com.irons.CrazySplitMoney"];
}

- (void)reportBreakGameModeScore {
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:gameTime forCategory:@"com.irons.CrazySplitTime"];
}

- (void)runHitAction:(SKSpriteNode *)bug {
    [bug removeAllActions];
    [fireballs removeObject:bug];
    
    SKAction *wait = [SKAction waitForDuration:0.1];
    SKAction *end = [SKAction runBlock:^{
        [bug removeFromParent];
    }];
    
    [bug runAction:[SKAction sequence:@[wait, end]]];
}

- (SKTexture *)getTimeTexture:(int)time {
    SKTexture *texture;
    switch (time) {
        case 0:
            texture = [TextureHelper timeTextures][0];
            break;
        case 1:
            texture = [TextureHelper timeTextures][1];
            break;
        case 2:
            texture = [TextureHelper timeTextures][2];
            break;
        case 3:
            texture = [TextureHelper timeTextures][3];
            break;
        case 4:
            texture = [TextureHelper timeTextures][4];
            break;
        case 5:
            texture = [TextureHelper timeTextures][5];
            break;
        case 6:
            texture = [TextureHelper timeTextures][6];
            break;
        case 7:
            texture = [TextureHelper timeTextures][7];
            break;
        case 8:
            texture = [TextureHelper timeTextures][8];
            break;
        case 9:
            texture = [TextureHelper timeTextures][9];
            break;
    }
    return texture;
}

- (void)setModeByGameMode {
    if (self.gameMode == INFINITY_MODE) {
        [self initInfiniteMode];
    } else if(self.gameMode == BREAK_GAME_MODE) {
        [self initBreakGameMode];
    }
}

- (void)initInfiniteMode {
    
}

- (void)initBreakGameMode {
    [self showGamePoint];
    [self hideGameTime];
}

- (void)changeToInfiniteMode {
    self.gameMode = INFINITY_MODE;
    [theGameTimer invalidate];
    [self initGameTimer];
    
    gameScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    [self changeGamePoint];
    
    gameTime = 0;
    [self showGamePoint];
    [self hideGameTime];
    player.hidden = YES;
}

- (void)changeToBreakGameMode {
    self.gameMode = BREAK_GAME_MODE;
    [theGameTimer invalidate];
    [self initGameTimer];
    
    [self hidegamePoint];
    [self showGameTime];
    player.hidden = NO;
    
    for (SKSpriteNode *node in fireballs) {
        [node removeFromParent];
    }
    [fireballs removeAllObjects];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        willChangeGameMode = INFINITY_MODE;
    } else if (buttonIndex==1) {
        willChangeGameMode = BREAK_GAME_MODE;
    }
}

@end
