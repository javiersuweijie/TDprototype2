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

@interface GameLayer () {
    CGSize winSize;
    CCLayer* unitAndBoxLayer;
}

@end

@implementation GameLayer
static NSMutableArray* filledList;
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
    
    [IsometricOperator init];
    unitAndBoxLayer = [CCLayer node];
    [self addChild:unitAndBoxLayer];
}

-(void)handleTapGesture:(UIGestureRecognizer*) tapGesture
{
    CGPoint touchLocation = [tapGesture locationInView:[tapGesture view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    
    if ([GameLayer isValid:touchLocation]) {
        BasicBlock* sprite = [[BasicBlock alloc] initWithPosition:touchLocation];
        [unitAndBoxLayer addChild:sprite z:-sprite.position.y];
        [filledList addObject:sprite];
    }

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

- (void)handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer
{
    CCNode *node = aPanGestureRecognizer.node;
    CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
    translation.y *= -1;
    [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
    
    node.position = ccpAdd(node.position, translation);
}

+(BOOL)isValid:(CGPoint)point
{
    CGPoint touchGrid = [IsometricOperator gridNumber:point];
    for (Structure* structure in filledList) {
        if (CGPointEqualToPoint(touchGrid, structure.gridPosition)) {
            return NO;
        }
    }
    return YES;
}

+(BOOL)isValidGrid:(CGPoint)grid
{
    CGPoint point = [IsometricOperator gridToCoord:grid];
    return [GameLayer isValid:point];
}

+(NSArray*)walkableAdjGrid:(CGPoint)grid
{
    NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:8];
    
    // Top
	CGPoint top = ccp(grid.x,grid.y+1);
	if ([GameLayer isValid:top])
    {
		[tmpArray addObject:[NSValue valueWithCGPoint:top]];
        
    }
    // Bottom
    CGPoint bottom = ccp(grid.x,grid.y-1);
    if ([GameLayer isValid:bottom])
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


@end
