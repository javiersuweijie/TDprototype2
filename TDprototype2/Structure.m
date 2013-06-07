//
//  Structure.m
//  TDprototype2
//
//  Created by Javiersu on 7/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Structure.h"
#import "IsometricOperator.h"

@interface Structure () {
    NSString* name;
    CGPoint tempPosition; //used for snapping to grid
    BOOL canBeMoved;
    BOOL isSelected;
}
@end

@implementation Structure
@synthesize gridPosition;
-(void)onEnter
{
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
    UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
    
    self.isTouchEnabled = YES;
    isSelected = NO;
    tempPosition = self.position;
}

-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    if (isSelected) {
        [self setOpacity:255];
        isSelected = NO;
    }
    else {
        [self setOpacity:100];
        isSelected = YES;
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)gesture
{
    if (isSelected) {
        CGPoint translation = [gesture translationInView:gesture.view];
        translation.y *= -1;
        [gesture setTranslation:CGPointZero inView:gesture.view];
        tempPosition = ccpAdd(tempPosition, translation);
        if (!CGPointEqualToPoint([IsometricOperator nearestPoint:tempPosition],self.position)) {
            [self setPosition:[IsometricOperator nearestPoint:tempPosition]];
            [[self parent] reorderChild:self z:-self.position.y];
        }
        if(gesture.state == UIGestureRecognizerStateEnded)
        {
            NSLog(@"dragging has ended");
        }
    }
    
    else {
        
    }
}

-(void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    self.gridPosition = [IsometricOperator gridNumber:self.position];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%f,%f,%@",self.position.x,self.position.y,name];
}

-(void)setName:(NSString*)n
{
    name = n;
}
@end
