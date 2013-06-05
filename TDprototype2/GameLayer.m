//
//  GameLayer.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

@interface GameLayer ()
@property (nonatomic)CGSize winSize;
@end

@implementation GameLayer

@synthesize winSize;

-(void)onEnter
{
    [super onEnter];
    NSLog(@"Game Layer Entered");
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    self.isTouchEnabled = YES;
}

-(void)handleTapGesture:(UIGestureRecognizer*) tapGesture
{
    NSLog(@"hi");
    CGPoint touchLocation = [tapGesture locationInView:[tapGesture view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    CCSprite* sprite = [[CCSprite alloc]initWithFile:(@"Icon-Small.png")];
    [sprite setPosition:touchLocation];
    [sprite setScale:0.5];
    [self addChild:sprite];
//    touchLocation = [self convertToNodeSpace:touchLocation]; //convert to nodeSpace of the gameLayer
    
//    CGPoint isoCoords = [IsoBackground nearestPoint:touchLocation];
}
@end
