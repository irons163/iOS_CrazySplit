//
//  GameScene.h
//  Try_Split_Blade
//

//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol gameDelegate;

@interface GameScene : SKScene<UIActionSheetDelegate>

@property (weak) id<gameDelegate> gameDelegate;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnMoveTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnCreateFootboardTimeInterval;

@property int gameMode;

- (void)setGameRun:(bool)isrun;
- (int)gameTime;

@end
