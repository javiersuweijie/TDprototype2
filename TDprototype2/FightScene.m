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
id box_layer;
id filled_list;
id fight_scene;
+(id)loadSceneWith:(id)boxLayer And:(id)filledList
{
    CCScene* loadScene = [FightScene node];
    CCSprite* loading = [CCSprite spriteWithFile:@"loading.png"];
    [loading setAnchorPoint:ccp(0,0)];
    [loadScene addChild:loading];
    box_layer = boxLayer;
    filled_list = filledList;
    
    return loadScene;
}

-(void)transition
{
    NSLog(@"transition");
    [self unscheduleAllSelectors];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:fight_scene withColor:ccBLACK]];
}

-(void)onEnter
{
    [super onEnter];
    fight_scene = [CCScene node];
    self.fight_layer = [[FightLayer alloc]initWith:box_layer];
    [self.fight_layer setFilledList:filled_list];
    [fight_scene addChild:self.fight_layer];
    [self scheduleOnce:@selector(transition) delay:1];
}
//
//+(id)sceneWith:(id)boxLayer And:(id)filledList
//{
//	return [[self alloc]initSceneWith:boxLayer And:filledList];
//}
//
//-(id)initSceneWith:(id)boxLayer And:(id)filledList
//{
//    if (self=[super init]) {
//        self.fight_layer = [[FightLayer alloc]initWith:boxLayer];
//        [self.fight_layer setFilledList:filledList];
//        [self addChild:self.fight_layer];
//    }
//    return self;
//}

@end
