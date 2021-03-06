//
//  CanonTower.m
//  TDprototype2
//
//  Created by Javiersu on 10/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CanonTower.h"
#import "FightLayer.h"
#define k_cooldown 75

@interface CanonTower ()

@end

@implementation CanonTower
@synthesize projectile;
Unit* unit;
int coolDown;
BOOL isShooting;
CGPoint currentPoint;
CGPoint prevPoint;
float airTime; //air time of the projectile
float dmg;
static int cost = 500;
id fightLayer;

-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"Canon.png"]]) {
        [self setSpriteFile:@"Canon.png"];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setSize:CGSizeMake(2, 2)];
        [self setCost:cost];
        [self setName:@"CanonTower"];
        [self setTempPosition:point];
        [self setPosition:self.tempPosition];

    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    projectile = [[CCSprite alloc]initWithFile:@"redbox.png"];
    [projectile setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    fightLayer = [[self parent]parent];
    [self scheduleUpdate];
    coolDown = 0;
    isShooting = NO;
    airTime = 0.5;
    dmg = 50;
}

-(void)onExit
{
    [super onExit];
}

-(void)update:(ccTime)dt
{   
    
    if ([self.array count]>0) {
        for (Unit* unitt in [self.array copy]) {
            if (ccpDistance(self.position,unitt.position)<75) {
                if ([unitt unitType]==Flying) {
                    continue;
                }
                unit = unitt;
                currentPoint = unit.position;
                break;
            }
            else if ([self.array indexOfObject:unitt]==[self.array count]-1) {
                unit= nil;
                isShooting = NO;
            }
        }
        if (unit!=nil)[self attackTarget:unit];
    }
    else
        unit=nil;
    if (isShooting&&coolDown>0)
        coolDown--;

}

-(void)attackTarget:(Unit*)unit
{
    isShooting=YES;
    if (CGPointEqualToPoint(prevPoint, CGPointZero)) {
        prevPoint = currentPoint;
        return;
    }
    if (coolDown==0) {
        coolDown=k_cooldown;
        [projectile setScale:0.5];
        CGPoint mid = ccpMidpoint(ccp(0,0), ccpSub(unit.position,self.position));
        CGPoint end = ccpAdd(ccpMult(ccpSub(currentPoint, prevPoint),unit.speed*airTime),ccpSub(unit.position,self.position));
        end = ccp(end.x+unit.contentSize.width/2, end.y);
        ccBezierConfig benzier1;
        benzier1.controlPoint_1 = ccp(mid.x,mid.y+100);//should be based on how far the unit is from the tower
        benzier1.controlPoint_2 = ccp(mid.x,mid.y+100);
        benzier1.endPosition = end;
        id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(setInvisible)];
        id action = [CCBezierTo actionWithDuration:airTime bezier:benzier1];
        if (ccpDistance(prevPoint, currentPoint)>2) {
            return;
        }
        [self addChild:projectile];
        [projectile runAction:[CCSequence actions:action,moveCallback, nil]];
        
    }
    prevPoint = currentPoint;
}

-(void)setInvisible
{
    if ([self.array count]>0) {
        for (Unit* unitt in self.array) {
            if (ccpDistance(ccpAdd(projectile.position,self.position),unitt.position)<15) {
//                NSLog(@"hit");
                unitt.hp -= dmg;
            }
        }
    }

    [projectile removeFromParentAndCleanup:NO];
    [projectile setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2)];
}

+(int)cost
{
    return cost;
}

-(float)dps
{
    return (float)dmg/k_cooldown;
}

-(NSString*)aoe
{
    return @"15";
}
@end
