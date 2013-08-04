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
#import "ResourceLabel.h"

#import "HpBar.h"


@interface Unit () {
    NSMutableArray *spClosedSteps;
    NSMutableArray *spOpenSteps;
    NSMutableArray *shortestPath;
}

@end

@implementation Unit
@synthesize speed,hp,speedMultiplier,unitType,bounty;

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

-(NSMutableArray*)moveToward:(NSValue*)target
{
    NSDate *start = [NSDate date];
    CGPoint toGrid = [IsometricOperator gridNumber:[target CGPointValue]];
    CGPoint fromGrid = [IsometricOperator gridNumber:self.position];
    if (![GameLayer isValidUnitGrid:toGrid]) {  //check if destination is valid
        NSLog(@"Not valid point");
        return nil;
    }
    spClosedSteps = [[NSMutableArray alloc]init];
    spOpenSteps = [[NSMutableArray alloc]init];
    [self insertInOpenSteps:[[ShortestPathStep alloc]initWithPosition:fromGrid]]; //add the first step into OPEN
    do {
        // Get the lowest F cost step
        // Because the list is ordered, the first step is always the one with the lowest F cost
        ShortestPathStep *currentStep = [spOpenSteps objectAtIndex:0];
        
        // Add the current step to the closed set
        [spClosedSteps addObject:currentStep];
        
        // Remove it from the open list
        // Note that if we wanted to first removing from the open list, care should be taken to the memory
        [spOpenSteps removeObjectAtIndex:0];
        
        // If the currentStep is the desired tile coordinate, we are done!
        if (CGPointEqualToPoint(currentStep.position, toGrid)) {
            
            NSLog(@"PATH FOUND : %f",-[start timeIntervalSinceNow]);
            [self constructPathAndStartAnimationFromStep:currentStep];
            
            spOpenSteps = nil; // Set to nil to release unused memory
            spClosedSteps = nil; // Set to nil to release unused memory
            
        }
        
        // Get the adjacent tiles coord of the current step
        NSArray *adjSteps = [GameLayer walkableAdjUnitGrid:currentStep.position];
        for (NSValue *v in adjSteps) {
            ShortestPathStep *step = [[ShortestPathStep alloc] initWithPosition:[v CGPointValue]];
            
            // Check if the step isn't already in the closed set
            if ([spClosedSteps containsObject:step]) {
                 // Must releasing it to not leaking memory ;-)
                continue; // Ignore it
            }
            
            // Compute the cost from the current step to that step
            int moveCost = [self costToMoveFromStep:currentStep toAdjacentStep:step];
            
            // Check if the step is already in the open list
            NSUInteger index = [spOpenSteps indexOfObject:step];
            
            if (index == NSNotFound) { // Not on the open list, so add it
                
                // Set the current step as the parent
                step.parent = currentStep;
                
                // The G score is equal to the parent G score + the cost to move from the parent to it
                step.gScore = currentStep.gScore + moveCost;
                
                // Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
                step.hScore = [self computeHScoreFromCoord:step.position toCoord:toGrid];
                
                // Adding it with the function which is preserving the list ordered by F score
                [self insertInOpenSteps:step];
                
                // Done, now release the step
            }
            else { // Already in the open list
                
                 // Release the freshly created one
                step = [spOpenSteps objectAtIndex:index]; // To retrieve the old one (which has its scores already computed ;-)
                
                // Check to see if the G score for that step is lower if we use the current step to get there
                if ((currentStep.gScore + moveCost) < step.gScore) {
                    
                    // The G score is equal to the parent G score + the cost to move from the parent to it
                    step.gScore = currentStep.gScore + moveCost;
                    
                    // Because the G Score has changed, the F score may have changed too
                    // So to keep the open list ordered we have to remove the step, and re-insert it with
                    // the insert function which is preserving the list ordered by F score
                    
                    // We have to retain it before removing it from the list
                    
                    // Now we can removing it from the list without be afraid that it can be released
                    [spOpenSteps removeObjectAtIndex:index];
                    
                    // Re-insert it with the function which is preserving the list ordered by F score
                    [self insertInOpenSteps:step];
                    
                    // Now we can release it because the oredered list retain it
                }
            }
        }
        
    } while ([spOpenSteps count] > 0);
    return nil;
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
    toCoord = [IsometricOperator gridToCoord:toCoord];
    fromCoord = [IsometricOperator gridToCoord:fromCoord];
    toCoord = [IsometricOperator coordInvTransform:toCoord];
    fromCoord = [IsometricOperator coordInvTransform:fromCoord];
//    int score = max(abs(toCoord.x - fromCoord.x),abs(toCoord.y - fromCoord.y));
    int score = (abs(toCoord.x - fromCoord.x)+abs(toCoord.y - fromCoord.y));
//    NSLog(@"%d",score);
	return score;
}

- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep
{
//    if (fromStep.position.x==toStep.position.x||fromStep.position.y==toStep.position.y) {
//        return 10;
//    }
	return 48;
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
    if ([shortestPath count] == 1) {
        ShortestPathStep *ss = [shortestPath objectAtIndex:0];
        CGPoint s = [IsometricOperator gridToCoord:ss.position];
        int r1 = (arc4random() % 16)-8;
        int r2 = (arc4random() % 16)-8;
        s = ccpAdd(s, ccp(r1,r2));
        float timetaken=ccpDistance(self.position, s)/self.speed;
        
        id moveAction = [CCMoveTo actionWithDuration:timetaken position:s];
        id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(reachEnd)]; // set the method itself as the callback
        id speeding = [CCSpeed actionWithAction:[CCSequence actions:moveAction, moveCallback, nil] speed:speedMultiplier];
        // Remove the step
        [shortestPath removeObjectAtIndex:0];
        //    [self runAction:[self animate:s.position]];
        [self runAction:speeding];
		return;
	}
    
	// Get the next step to move to
	ShortestPathStep *ss = [shortestPath objectAtIndex:0];
    CGPoint s = [IsometricOperator gridToCoord:ss.position];
    int r1 = (arc4random() % 16)-8;
    int r2 = (arc4random() % 16)-8;
    s = ccpAdd(s, ccp(r1,r2));
    float timetaken=ccpDistance(self.position, s)/self.speed;
    
	id moveAction = [CCMoveTo actionWithDuration:timetaken position:s];
	id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(popStepAndAnimate)]; // set the method itself as the callback
    id speeding = [CCSpeed actionWithAction:[CCSequence actions:moveAction, moveCallback, nil] speed:speedMultiplier];
	// Remove the step
	[shortestPath removeObjectAtIndex:0];
    //    [self runAction:[self animate:s.position]];
	[self runAction:speeding];
}

- (void)reachEnd
{
    NSLog(@"last");
    shortestPath = nil;
    [ResourceLabel subtractTechBy:1];
    [self removeFromParentAndCleanup:YES];
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

-(void)onExit
{
    if (self.hp <= 0) {
        [ResourceLabel addGoldBy:self.bounty];
    }
    [super onExit];
}
@end
