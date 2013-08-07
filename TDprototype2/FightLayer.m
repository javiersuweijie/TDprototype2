//
//  FightLayer.m
//  TDprototype2
//
//  Created by Javiersu on 6/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FightLayer.h"
#import "IsometricOperator.h"
#import "GameLayer.h"
#import "IOOObject.h"
#import "ImportUnits.h"
#import "Structure.h"
#import "GameScene.h"

@implementation FightLayer
static CGMutablePathRef path;
static CGMutablePathRef unitPath;
CGPoint vert[4];
CGPoint vert2[4];
CGSize winSize;
CGContextRef context;
CGPoint unitEndPoint;
CGPoint unitStartPoint;

id unitAndBoxLayer;
NSMutableArray* unitList;
id ioObject;

@synthesize filledList;

-(id)initWith:(id)boxLayer
{
    if (self=[super init]) {
        
        float translate = 22.627*14;
        float tileHeight = 16;
        vert2[0] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, -tileHeight)]);
        vert2[1] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width/2, -tileHeight)]);
        vert2[2] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width/2, winSize.height*0.75+tileHeight)]);
        vert2[3] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, winSize.height*0.75+tileHeight)]);
        
        vert[0] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, 0)]);
        vert[1] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width/2, 0)]);
        vert[2] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(winSize.width/2, winSize.height*0.75)]);
        vert[3] = ccpAdd(ccp(0,translate),[IsometricOperator coordTransform:ccp(0, winSize.height*0.75)]);

        context = UIGraphicsGetCurrentContext();
        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, vert[0].x, vert[0].y);
        CGPathAddLineToPoint(path, NULL, vert[1].x, vert[1].y);
        CGPathAddLineToPoint(path, NULL, vert[2].x, vert[2].y);
        CGPathAddLineToPoint(path, NULL, vert[3].x, vert[3].y);
        CGPathCloseSubpath(path);
        
        unitPath = CGPathCreateMutable();
        CGPathMoveToPoint(unitPath, NULL, vert2[0].x, vert2[0].y);
        CGPathAddLineToPoint(unitPath, NULL, vert2[1].x, vert2[1].y);
        CGPathAddLineToPoint(unitPath, NULL, vert2[2].x, vert2[2].y);
        CGPathAddLineToPoint(unitPath, NULL, vert2[3].x, vert2[3].y);
        CGPathCloseSubpath(unitPath);
        
        CCSprite* background = [CCSprite spriteWithFile:@"background2.png"];
        [background setPosition:vert[0]];
        [background setAnchorPoint:ccp(0,0.5)];
        [self addChild:background z:-1000];
        
        [self setContentSize:CGSizeMake(winSize.width*2, winSize.height*2)];
        [self setAnchorPoint:ccp(0,0)];
        [self setPosition:ccp(0,-151)];
        
        unitList = [[NSMutableArray alloc]init];
        ioObject = [[IOOObject alloc]init];
        
        unitEndPoint = [IsometricOperator gridToCoord:ccp(-6,29)];
        unitStartPoint = [IsometricOperator gridToCoord:ccp(-6,13)];
        
        [boxLayer removeFromParentAndCleanup:NO];
        unitAndBoxLayer = boxLayer;
        [unitAndBoxLayer setAnchorPoint:ccp(0,0)];
        [self addChild:unitAndBoxLayer];
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [self loadUnit];
   
}

-(BOOL)isValidUnitGrid:(CGPoint)grid
{
    if (!CGPathContainsPoint(unitPath, NULL, [IsometricOperator gridToCoord:grid], NO) ) {
        return NO;
    }
    for (Structure* structure in self.filledList) {
        for (NSValue* value in structure.gridPosition) {
            if (CGPointEqualToPoint(grid, [value CGPointValue])) {
                return NO;
            }
            
        }
    }
    return YES;
}

-(NSArray*)walkableAdjUnitGrid:(CGPoint)grid
{
    
    
    NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:8];
    
    // Top
	CGPoint top = ccp(grid.x,grid.y+1);
    
    // Bottom
    CGPoint bottom = ccp(grid.x,grid.y-1);
    
	// Left
    CGPoint left = ccp(grid.x-1,grid.y);
    if ([self isValidUnitGrid:left])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:left]];
        if ([self isValidUnitGrid:top]) {
            CGPoint topleft = ccp(grid.x-1,grid.y+1);
            if ([self isValidUnitGrid:topleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topleft]];
            }
        }
        if ([self isValidUnitGrid:bottom]) {
            CGPoint bottomleft = ccp(grid.x-1,grid.y-1);
            if ([self isValidUnitGrid:bottomleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomleft]];
            }
        }
    }
    
    if ([self isValidUnitGrid:bottom])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:bottom]];
        
    }
    
    if ([self isValidUnitGrid:top])
    {
		[tmpArray addObject:[NSValue valueWithCGPoint:top]];
        
    }
    
	// Right
    CGPoint right = ccp(grid.x+1,grid.y);
    if ([self isValidUnitGrid:right])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:right]];
        if ([self isValidUnitGrid:top]) {
            CGPoint topright = ccp(grid.x+1,grid.y+1);
            if ([self isValidUnitGrid:topright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topright]];
            }
        }
        if ([self isValidUnitGrid:bottom]) {
            CGPoint bottomright = ccp(grid.x+1,grid.y-1);
            if ([self isValidUnitGrid:bottomright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomright]];
            }
        }
    }
    
	return [NSArray arrayWithArray:tmpArray];
    
}

-(void)spawnUnit:(NSString*)unitName
{
    Unit* unit = [[NSClassFromString(unitName) alloc]initWithPosition:unitStartPoint moveTo:unitEndPoint];
    [unitAndBoxLayer addChild:unit];
    [unitList addObject:unit];
}

-(void)loadUnit
{
    NSArray* loadUnits = [ioObject loadUnits];
    float time = 0;
    for (int i=0;i<[loadUnits count];i++) {
        NSDictionary * unitInfo = [loadUnits objectAtIndex:i];
        NSString* unit = [unitInfo objectForKey:@"name"];
        if ([unit isEqualToString:@"end"]) {
            NSLog(@"All Units are scheduled to spawn");
            [self schedule:@selector(checkLastUnit)];
            return;
        }
        NSNumber* delay = [unitInfo objectForKey:@"delay"];
        time += [delay floatValue];
        [self performSelector:@selector(spawnUnit:) withObject:unit afterDelay:time];
    }
}

-(void)checkLastUnit
{
    if ([unitList count]==0) {
        NSLog(@"last unit dead");
        [self unschedule:@selector(checkLastUnit)];
        [[CCDirector sharedDirector]replaceScene:[GameScene sceneWith:unitAndBoxLayer and:[filledList mutableCopy]]];
    }
}

-(NSMutableArray*)getUnitArray
{
    return unitList;
}

-(NSString*)fightOrBuild
{
    return @"fight";
}
@end
