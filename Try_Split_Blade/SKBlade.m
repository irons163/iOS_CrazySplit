//
//  SKBlade.m
//  SKBlade
//
//  Created by Julio Montoya on 26/04/14.
//  Copyright (c) 2014 Julio Montoya. All rights reserved.
//
//
//  Copyright (c) <2014> <Julio Montoya>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "SKBlade.h"

@implementation SKBlade

- (instancetype)initWithPosition:(CGPoint)position TargetNode:(SKNode *)target Color:(UIColor *)color
{
    if (self = [super init])
    {
        self.position = position;
        
        SKSpriteNode *tip = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(25, 25)];
        tip.zRotation = 0.785398163;
        tip.zPosition = 10;
        [self addChild:tip];
        
        SKEmitterNode *_emitter = [self EmitterNodeWithColor:color];
        _emitter.targetNode = target;
        _emitter.zPosition = 0;
        [tip addChild:_emitter];
        
        [self setScale:0.5];
    }
    
    return self;
}

- (void)enablePhysicsWithCategoryBitmask:(uint32_t)category ContactTestBitmask:(uint32_t)contact CollisionBitmask:(uint32_t)collision
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:16];
    self.physicsBody.categoryBitMask = category;
    self.physicsBody.contactTestBitMask = contact;
    self.physicsBody.collisionBitMask = collision;
    self.physicsBody.dynamic = NO;
}

- (SKEmitterNode *)EmitterNodeWithColor:(UIColor *)color
{
    SKEmitterNode *emitterNode = [SKEmitterNode new];
    emitterNode.particleTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"spark.png"]];
    emitterNode.particleBirthRate = 3000;
    
    emitterNode.particleLifetime = 0.2;
    emitterNode.particleLifetimeRange = 0;
    
    emitterNode.particlePositionRange = CGVectorMake(0.0, 0.0);
    
    emitterNode.particleSpeed = 0.0;
    emitterNode.particleSpeedRange = 0.0;
    
    emitterNode.particleAlpha = 0.8;
    emitterNode.particleAlphaRange = 0.2;
    emitterNode.particleAlphaSpeed = -0.45;
    
    emitterNode.particleScale = 0.5;
    emitterNode.particleScaleRange = 0.001;
    emitterNode.particleScaleSpeed = -1;
    
    emitterNode.particleRotation = 0;
    emitterNode.particleRotationRange = 0;
    emitterNode.particleRotationSpeed = 0;
    
    emitterNode.particleColorBlendFactor = 1;
    emitterNode.particleColorBlendFactorRange = 0;
    emitterNode.particleColorBlendFactorSpeed = 0;
    
    emitterNode.particleColor = color;
    emitterNode.particleBlendMode = SKBlendModeAdd;
    
    return emitterNode;
}

@end