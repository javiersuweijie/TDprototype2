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

@interface Unit () {
    NSMutableArray *spClosedSteps;
    NSMutableArray *spOpenSteps;
    NSMutableArray *shortestPath;
}

@end

@implementation Unit
@synthesize speed,hp;

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
    [self schedule:@selector(updateZ:)];
}

-(void)updateZ:(ccTime)dt
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
        if ([spOpenSteps count]>3) {
            //            NSLog(@"%@,%@,%@",[[spOpenSteps objectAtIndex:0] description],[[spOpenSteps objectAtIndex:1] description],[[spOpenSteps objectAtIndex:2]description]);
        }
        currentStep=[spOpenSteps objectAtIndex:0];
        [spOpenSteps removeObjectAtIndex:0];
        numberOfSteps++;
        //        NSLog(@"NoS:%d Target:%@ Point:%@ gScore:%d, hScore:%d",numberOfSteps,NSStringFromCGPoint(toGrid),NSStringFromCGPoint(currentStep.position),currentStep.gScore,currentStep.hScore);
        CGPoint currentGrid = currentStep.position;
        [spClosedSteps addObject:currentStep];
        [spOpenSteps removeAllObjects];
        
        if (CGPointEqualToPoint(currentStep.position,toGrid)) {
            NSLog(@"foundPath");
            spOpenSteps = nil;
            spClosedSteps = nil;
            //            NSLog(@"%@",[currentStep description]);
            return [self constructPathAndStartAnimationFromStep:currentStep];
            break;
        }
        
        else {
            NSArray* array = [GameLayer walkableAdjGrid:currentGrid];
            for (NSValue* x in array) {
                ShortestPathStep* adjStep = [[ShortestPathStep alloc]initWithPosition:[x CGPointValue]];
                if ([spClosedSteps containsObject:adjStep]) {
                    adjStep = nil;
                    continue;
                }
                adjStep.hScore = [self computeHScoreFromCoord:adjStep.position toCoord:toGrid];
                adjStep.gScore = currentStep.gScore + [self costToMoveFromStep:currentStep toAdjacentStep:adjStep];
                adjStep.parent = currentStep;
                [self insertInOpenSteps:adjStep];
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
	return 11*max(abs(toCoord.x - fromCoord.x),abs(toCoord.y - fromCoord.y));
}

- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep
{
	// Because we can't move diagonally and because terrain is just walkable or unwalkable the cost is always the same.
	// But it have to be different if we can move diagonally and/or if there is swamps, hills, etc...
	return ((fromStep.position.x != toStep.position.x) && (fromStep.position.y != toStep.position.y)) ? 20 : 10;
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
    
	// Remove the step
	[shortestPath removeObjectAtIndex:0];
    //    [self runAction:[self animate:s.position]];
	[self runAction:[CCSequence actions:moveAction, moveCallback, nil]];
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
