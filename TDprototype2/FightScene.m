//
//  FightScene.m
//  TDprototype2
//
//  Created by Javiersu on 6/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FightScene.h"

@implementation FightScene
@synthesize fight_layer;
+(id)sceneWith:(id)boxLayer And:(id)filledList
{
	return [[self alloc]initSceneWith:boxLayer And:filledList];
}

-(id)initSceneWith:(id)boxLayer And:(id)filledList
{
    if (self=[super init]) {
        self.fight_layer = [[FightLayer alloc]initWith:boxLayer];
        NSLog(@"filled list 2: %@",filledList);
        [self.fight_layer setFilledList:filledList];
        [self addChild:self.fight_layer];
    }
    return self;
}

@end
