//
//  CanonTower.m
//  TDprototype2
//
//  Created by Javiersu on 10/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CanonTower.h"

#define k_cooldown 75

@interface CanonTower ()

@end

@implementation CanonTower
@synthesize projectile;
NSMutableArray* array;
Unit* unit;
int coolDown;
BOOL isShooting;
CGPoint currentPoint;
CGPoint prevPoint;
float airTime; //air time of the projectile

-(id)initWithPosition:(CGPoint)point
{
    if ([super initWithFile:[NSString stringWithFormat:@"redbox.png"]]) {
        [self setColor:ccGREEN];
        [self setAnchorPoint:ccp(0.5,0)];
        [self setPosition:point];
        [self setName:@"canontower"];
        [self setCanBeMoved:YES];
        projectile = [[CCSprite alloc]initWithFile:@"redbox.png"];
        [self scheduleUpdate];

    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    array = [GameLayer getUnitArray];
    coolDown = 0;
    isShooting = NO;
    airTime = 0.5;
}

-(void)update:(ccTime)dt
{   
    
    if ([array count]>0) {
        for (Unit* unitt in array) {
            if (ccpDistance(self.position,unitt.position)<75) {
                unit = unitt;
                currentPoint = unit.position;
                break;
            }
            else if ([array indexOfObject:unitt]==[array count]-1) {
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
        benzier1.controlPoint_1 = ccp(mid.x,mid.y+100);
        benzier1.controlPoint_2 = ccp(mid.x,mid.y+100);
        benzier1.endPosition = end;
        id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(setInvisible)];
        id action = [CCBezierTo actionWithDuration:airTime bezier:benzier1];
        if (ccpDistance(prevPoint, currentPoint)>1) {
            return;
        }
        [self addChild:projectile];
        [projectile runAction:[CCSequence actions:action,moveCallback, nil]];
//    unit.hp--;
    }
    prevPoint = currentPoint;
}

-(void)setInvisible
{
    NSLog(@"projectile:%@",NSStringFromCGPoint(ccpAdd(projectile.position,self.position)));
    
    if ([array count]>0) {
        for (Unit* unitt in array) {
            NSLog(@"%@",NSStringFromCGPoint(unitt.position));
            if (ccpDistance(ccpAdd(projectile.position,self.position),unitt.position)<35) {
                NSLog(@"hit");
                unitt.hp -= 100;
            }
        }
    }

    [projectile removeFromParentAndCleanup:NO];
    [projectile setPosition:ccp(self.contentSize.width/2, 0)];
}
@end
