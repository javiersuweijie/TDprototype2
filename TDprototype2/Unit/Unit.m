//
//  Unit.m
//  TDprototype2
//
//  Created by Javiersu on 8/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Unit.h"
#import "ShortestPathStep.h"
#import "IsometricOperator.h"
#import "GameLayer.h"
#import "HpBar.h"


@interface Unit () {
    NSMutableArray *spClosedSteps;
    NSMutableArray *spOpenSteps;
    NSMutableArray *shortestPath;
}

@end

@implementation Unit
@synthesize speed,hp,speedMultiplier;

-(id)init
{
    if (self = [super init]){
        self.speed = 30;
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [self scheduleUpdateWithPriority:-10];
    self.speedMultiplier = 1;
    HpBar* hpBar = [[HpBar alloc]initWithChar:self];
    [self addChild:hpBar];
}

-(void)update:(ccTime)dt
{
    [parent_ reorderChild:self z:-self.position.y];
    if (self.hp<0) {
        [[GameLayer getUnitArray] removeObject:self];
        [self removeFromParentAndCleanup:YES];

    }
}

-(NSMutableArray*)moveToward:(CGPoint)target
{
    CGPoint toGrid = [IsometricOperator gridNumber:target];
    CGPoint fromGrid = [IsometricOperator gridNumber:self.position];
    
    if (![GameLayer isValidGrid:toGrid]) {
        NSLog(@"Not valid point");
        return nil;
    }
    spClosedSteps = [[NSMutableArray alloc]init];
    spOpenSteps = [[NSMutableArray alloc]init];
    int numberOfSteps=0;
    [self insertInOpenSteps:[[ShortestPathStep alloc]initWithPosition:fromGrid]];
    ShortestPathStep* currentStep;
    do {
        currentStep=[spOpenSteps objectAtIndex:0];
        [spOpenSteps removeObjectAtIndex:0];
        numberOfSteps++;

        CGPoint currentGrid = currentStep.position;
        [spClosedSteps addObject:currentStep];
        [spOpenSteps removeAllObjects];
        
        if (CGPointEqualToPoint(currentStep.position,toGrid)) {
            NSLog(@"foundPath");
            spOpenSteps = nil;
            spClosedSteps = nil;

            return [self constructPathAndStartAnimationFromStep:currentStep];
            break;
        }
        
        else {
            NSArray* array = [GameLayer walkableAdjGrid:currentGrid];
            for (NSValue* x in array) {
                ShortestPathStep* adjStep = [[ShortestPathStep alloc]initWithPosition:[x CGPointValue]];
                adjStep.hScore = [self computeHScoreFromCoord:adjStep.position toCoord:toGrid];
                adjStep.gScore = currentStep.gScore + [self costToMoveFromStep:currentStep toAdjacentStep:adjStep];
                for (ShortestPathStep* neighbour in [spOpenSteps copy]) {
                    if (adjStep.gScore < neighbour.gScore) {
                        [spOpenSteps removeObject:neighbour];
                    }
                }
                for (ShortestPathStep* neighbour in [spClosedSteps copy]) {
                    if (adjStep.gScore < neighbour.gScore) {
                        [spClosedSteps removeObject:neighbour];
                    }
                }
                if (![spClosedSteps containsObject:adjStep]&&![spOpenSteps containsObject:adjStep]) {
                adjStep.parent = currentStep;
                [self insertInOpenSteps:adjStep];
                }
                adjStep=nil;
            }
            array=nil;
        }
    } while (TRUE);
}

-(void)insertInOpenSteps:(ShortestPathStep *)step
{
    int stepFScore = [step fScore]; // Compute the step's F score
	int count = [spOpenSteps count];
	int i = 0; // This will be the index at which we will insert the step
	for (; i < count; i++) {
		if (stepFScore <= [[spOpenSteps objectAtIndex:i] fScore]) { // If the step's F score is lower or equals to the step at index i
			// Then we found the index at which we have to insert the new step
            // Basically we want the list sorted by F score
			break;
		}
	}
	// Insert the new step at the determined index to preserve the F score ordering
	[spOpenSteps insertObject:step atIndex:i];
}
// Compute the H score from a position to another (from the current position to the final desired position
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord
{
	// Here we use the Manhattan method, which calculates the total number of step moved horizontally and vertically to reach the
	// final desired step from the current step, ignoring any obstacles that may be in the way
    toCoord = [IsometricOperator coordInvTransform:toCoord];
    fromCoord = [IsometricOperator coordInvTransform:fromCoord];
    int score = max(abs(toCoord.x - fromCoord.x),abs(toCoord.y - fromCoord.y));
//    NSLog(@"%d",score);
	return score;
}

- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep
{
	return 1;
}

- (NSMutableArray*)constructPathAndStartAnimationFromStep:(ShortestPathStep *)step
{
	NSMutableArray* sp = [[NSMutableArray alloc]init];
    
	do {
		if (step.parent != nil) { // Don't add the last step which is the start position (remember we go backward, so the last one is the origin position ;-)
			[sp insertObject:step atIndex:0]; // Always insert at index 0 to reverse the path
		}
		step = step.parent; // Go backward
	} while (step != nil); // Until there is no more parents
    
    //    for (ShortestPathStep *s in self.shortestPath) {
    //        NSLog(@"%@", s);
    //    }
    [self runPSA:sp];
    return sp;
}

- (void)runPSA:(NSMutableArray*)array;
{
    if (shortestPath == nil) {
        shortestPath = [array mutableCopy];
        [self popStepAndAnimate];
    }
}

- (void)popStepAndAnimate;
{
	// Check if there remains path steps to go through
    if ([shortestPath count] == 0) {
		shortestPath = nil;
		return;
	}
    
	// Get the next step to move to
	ShortestPathStep *ss = [shortestPath objectAtIndex:0];
    CGPoint s = [IsometricOperator gridToCoord:ss.position];
    float timetaken=ccpDistance(self.position, s)/self.speed;
    
	id moveAction = [CCMoveTo actionWithDuration:timetaken position:s];
	id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(popStepAndAnimate)]; // set the method itself as the callback
    id speeding = [CCSpeed actionWithAction:[CCSequence actions:moveAction, moveCallback, nil] speed:speedMultiplier];
	// Remove the step
	[shortestPath removeObjectAtIndex:0];
    //    [self runAction:[self animate:s.position]];
	[self runAction:speeding];
}

- (void)cancelStep
{
    [self stopAllActions];
    if ([shortestPath count] != 0) {
		shortestPath = nil;
		return;
	}
    return;
}


@end
