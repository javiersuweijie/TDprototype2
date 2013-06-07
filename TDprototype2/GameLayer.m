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
    
    CGPoint p=ccp(200, 200);
    NSLog(@"%@",NSStringFromCGPoint(p));
    p=[IsometricOperator nearestPoint:p];
    NSLog(@"%@",NSStringFromCGPoint(p));
    p=[IsometricOperator gridNumber:p];
    NSLog(@"%@",NSStringFromCGPoint(p));
    p=[IsometricOperator gridToCoord:p];
    NSLog(@"%@",NSStringFromCGPoint(p));
    p=[IsometricOperator gridNumber:p];
    NSLog(@"%@",NSStringFromCGPoint(p));
    p=[IsometricOperator gridToCoord:p];
    NSLog(@"%@",NSStringFromCGPoint(p));
}

-(void)handleTapGesture:(UIGestureRecognizer*) tapGesture
{
    CGPoint touchLocation = [tapGesture locationInView:[tapGesture view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    touchLocation = [IsometricOperator nearestPoint:touchLocation];
    
    if ([GameLayer isValid:touchLocation]) {
        Structure* sprite = [[BasicBlock alloc] initWithPosition:touchLocation];
        [sprite setAnchorPoint:ccp(0.5, 0)];
        [sprite setPosition:touchLocation];
        [self addChild:sprite z:-sprite.position.y tag:123];
        [filledList addObject:sprite];
        [sprite release];
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
            NSLog(@"This is a filled space");
            return NO;
        }
    }
    return YES;
}

@end
