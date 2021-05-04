//
//  ClearableSprite.h
//  Try_Split_Blade
//
//  Created by irons on 2015/9/14.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    FIRE_BALL,
    COIN_10,
    COIN_30,
    COIN_50
}CLEARABLE_TPYE;

@interface ClearableSprite : SKSpriteNode

@property CLEARABLE_TPYE type;

@end
