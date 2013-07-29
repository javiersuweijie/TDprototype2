//
//  ParticlesIceBeam.m
//  TDprototype2
//
//  Created by Javiersu on 14/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ParticlesIceBeam.h"


@implementation ParticlesIceBeam
-(id) init
{
	return [self initWithTotalParticles:100];
}

-(id) initWithTotalParticles:(NSUInteger)p
{
	if( (self=[super initWithTotalParticles:p]) ) {
		// duration
		duration = kCCParticleDurationInfinity;
        
		// Gravity Mode
		self.emitterMode = kCCParticleModeGravity;
        
		// Gravity Mode: gravity
		self.gravity = ccp(0,0);
        
		// Gravity Mode:  radial
		self.radialAccel = 0;
		self.radialAccelVar = 0;
        
		//  Gravity Mode: speed of particles
		self.speed = 250;
		self.speedVar = 10;
        
		// angle
		angle = 90;
		angleVar = 0;
        
		// life of particles
		life = 0.3;
		lifeVar = 0;
        
		// emits per frame
		emissionRate = 0.9*totalParticles/life;
        
		// color of particles
		startColor.r = 0;
		startColor.g = 0.26f;
		startColor.b = 1.0f;
		startColor.a = 1.0f;
		startColorVar.r = 0;
		startColorVar.g = 0;
		startColorVar.b = 0;
		startColorVar.a = 0;
		endColor.r = 0;
		endColor.g = 0.26f;
		endColor.b = 1.0f;
		endColor.a = 0.9f;
		endColorVar.r = 0;
		endColorVar.g = 0;
		endColorVar.b = 0;
		endColorVar.a = 0;
        
		// size, in pixels
		startSize = 10.0f;
		startSizeVar = 1.0f;
		endSize = kCCParticleStartSizeEqualToEndSize;
        endSizeVar = 1.0f;
        self.positionType = kCCPositionTypeGrouped;
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"particleFire.png"];
        
		// additive
		self.blendAdditive = NO;
	}
	return self;
}
@end
