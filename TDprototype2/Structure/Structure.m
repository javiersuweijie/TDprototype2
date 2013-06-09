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
    UIGestureRecognizer* pan;
    CCSprite* downArrows;
}
@end

@implementation Structure
@synthesize gridPosition;

-(void)onEnter
{
    [super onEnter];
    
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:pan];
    [pan setEnabled:YES];
    pan.delegate = self;

    
    if (canBeMoved) {
        self.isTouchEnabled = YES;
        downArrows = [CCSprite spriteWithFile:@"arrowAI.png"];
        [downArrows setAnchorPoint:ccp(0, 0.5)];
        [downArrows setPosition:ccp(0, self.contentSize.height/2)];
        [self addChild:downArrows];
        [self setOpacity:100];
        isSelected = YES;
        tempPosition = self.position;
    }
}

-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    if (canBeMoved) {
        if (isSelected) {
            [self setOpacity:255];
            [downArrows setVisible:NO];
            isSelected = NO;
            [pan setEnabled:NO];
        }
        else {
            [self setOpacity:100];
            [downArrows setVisible:YES];
            isSelected = YES;
            [pan setEnabled:YES];
        }
    }
    else return;
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)gesture
{
    if (isSelected) {
        CGPoint translation = [gesture translationInView:gesture.view];
        translation.y *= -1;
        [gesture setTranslation:CGPointZero inView:gesture.view];
        tempPosition = ccpAdd(tempPosition, translation);
        CGPoint newPoint = [IsometricOperator nearestPoint:tempPosition];
        if (!CGPointEqualToPoint(newPoint,self.position)) {
            if ([GameLayer isValid:newPoint]) {
                [self setPosition:newPoint];
                [[self parent] reorderChild:self z:-self.position.y];
            }
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

-(void)setCanBeMoved:(BOOL)b
{
    canBeMoved = b;
}
@end
