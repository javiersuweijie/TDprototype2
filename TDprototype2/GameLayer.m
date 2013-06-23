//
//  GameLayer.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "IsometricOperator.h"
#import "BasicBlock.h"
#import "testPerson.h"
#import "FireTower.h"
#import "WorldTree.h"
#import "CanonTower.h"
#import "IceBeamTower.h"

@interface GameLayer () {

    
}

@end

@implementation GameLayer
static NSMutableArray* filledList;
static NSMutableArray* unitList;
static CCLayer* unitAndBoxLayer;
static CGSize winSize;

BOOL buildingMode = NO;
CCLayer* buildingLayer;
-(void)onEnter
{
    [super onEnter];

    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
    UIGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:pinchGestureRecognizer];
    [pinchGestureRecognizer release];
    
    UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
    
    self.isTouchEnabled = YES;
    
    filledList = [[NSMutableArray alloc]init];
    unitList = [[NSMutableArray alloc]init];
    [IsometricOperator init];
    unitAndBoxLayer = [CCLayer node];
    [self addChild:unitAndBoxLayer];
    
    WorldTree* tree = [[WorldTree alloc]initWithPosition:[IsometricOperator nearestPoint:ccp(160, 200)]];
    [unitAndBoxLayer addChild:tree];
//    [filledList addObject:tree]; //commented out else units cant find path
    
    winSize = [[CCDirector sharedDirector] winSize];
}

-(void)handleTapGesture:(UIGestureRecognizer*) tapGesture
{
    CGPoint touchLocation = [tapGesture locationInView:[tapGesture view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer*) gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        if ([gesture numberOfTouches]<2) {
            return;
        }
        
        CGPoint touch1 = [gesture locationOfTouch:0 inView:[gesture view]];
        CGPoint touch2 = [gesture locationOfTouch:1 inView:[gesture view]];
        touch1 = [[CCDirector sharedDirector] convertToGL:touch1];
        touch2 = [[CCDirector sharedDirector] convertToGL:touch2];
        
        CGPoint mid = ccpMidpoint(touch1, touch2);
        mid=[self convertToNodeSpace:mid];
        float scale = gesture.scale;
        if ((scale>1 && self.scale>5.0)||(scale<1 && self.scale<0.8));
        else {
            self.scale *= scale;
        }
    gesture.scale = 1;
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer
{
    if (buildingMode) {
        CGPoint touch = [aPanGestureRecognizer locationInView:[aPanGestureRecognizer view]];
        touch = [[CCDirector sharedDirector]convertToGL:touch];
        touch = [IsometricOperator nearestPoint:touch];
        if ([GameLayer isValid:touch]) {
            [self placeBlueTileAt:touch];
        }
    }
    else {
        CCNode *node = aPanGestureRecognizer.node;
        CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
        translation.y *= -1;
        [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
        node.position = ccpAdd(node.position, translation);
    }
    if ([aPanGestureRecognizer state]==UIGestureRecognizerStateEnded) {
        buildingMode = NO;
    }
}

+(BOOL)isValid:(CGPoint)point
{
    CGPoint touchGrid = [IsometricOperator gridNumber:point];
    return [GameLayer isValidGrid:touchGrid];
}

+(BOOL)isValidGrid:(CGPoint)grid
{
    for (Structure* structure in filledList) {
        for (NSValue* value in structure.gridPosition) {
            if (CGPointEqualToPoint(grid, [value CGPointValue])) {
                return NO;
            }
        
        }
    }
    return YES;
}

+(NSArray*)walkableAdjGrid:(CGPoint)grid
{
    NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:8];
    
    // Top
	CGPoint top = ccp(grid.x,grid.y+1);
	if ([GameLayer isValidGrid:top])
    {
		[tmpArray addObject:[NSValue valueWithCGPoint:top]];
        
    }
    // Bottom
    CGPoint bottom = ccp(grid.x,grid.y-1);
    if ([GameLayer isValidGrid:bottom])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:bottom]];
        
    }
	// Left
    CGPoint left = ccp(grid.x-1,grid.y);
    if ([GameLayer isValidGrid:left])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:left]];
        if ([GameLayer isValidGrid:top]) {
            CGPoint topleft = ccp(grid.x-1,grid.y+1);
            if ([GameLayer isValidGrid:topleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topleft]];
            }
        }
        if ([GameLayer isValidGrid:bottom]) {
            CGPoint bottomleft = ccp(grid.x-1,grid.y-1);
            if ([GameLayer isValidGrid:bottomleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomleft]];
            }
        }
    }
    
	// Right
    CGPoint right = ccp(grid.x+1,grid.y);
    if ([GameLayer isValidGrid:right])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:right]];
        if ([GameLayer isValidGrid:top]) {
            CGPoint topright = ccp(grid.x+1,grid.y+1);
            if ([GameLayer isValidGrid:topright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topright]];
            }
        }
        if ([GameLayer isValidGrid:bottom]) {
            CGPoint bottomright = ccp(grid.x+1,grid.y-1);
            if ([GameLayer isValidGrid:bottomright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomright]];
            }
        }
    }
    
    
	return [NSArray arrayWithArray:tmpArray];
    
}

-(void)testSP
{
    testPerson* person = [[testPerson alloc]initWithPosition:[IsometricOperator nearestPoint:ccp(2, 4)] moveTo:[IsometricOperator nearestPoint:ccp(160, 200)]];
    [unitAndBoxLayer addChild:person];
    [unitList addObject:person];
}

-(void)placeBlueTileAt:(CGPoint)point
{
    CGPoint ppoint = [unitAndBoxLayer convertToNodeSpace:point];
    BasicBlock* sprite = [[BasicBlock alloc] initWithPosition:ppoint];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
}
-(void)placeBlueTile
{
    buildingMode = YES;
    buildingLayer = [CCLayer node];
    [self addChild:buildingLayer];
//    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
//    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
//    BasicBlock* sprite = [[BasicBlock alloc] initWithPosition:touchLocation];
//    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
//    [filledList addObject:sprite];
}

-(void)placeFireTower
{
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    FireTower* sprite = [[FireTower alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
}

-(void)placeCanon
{
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    CanonTower* sprite = [[CanonTower alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
}

-(void)placeIce
{
    CGPoint touchLocation = ccp(winSize.width/2,winSize.height/2);
    touchLocation = [unitAndBoxLayer convertToNodeSpace:touchLocation];
    IceBeamTower* sprite = [[IceBeamTower alloc] initWithPosition:touchLocation];
    [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
    [filledList addObject:sprite];
}
+(NSMutableArray*)getUnitArray
{
    return unitList;
}

@end
