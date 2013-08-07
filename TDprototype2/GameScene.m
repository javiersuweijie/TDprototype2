//
//  GameScene.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "UILayer.h"
#import "GameLayer.h"
#import "BuildLayer.h"
@interface GameScene ()
@property (nonatomic) CGSize winSize;
@end

@implementation GameScene
@synthesize winSize;
+(id)sceneWith:(id)boxLayer and:(id)filledList
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
    [layer createBuildLayerWith:boxLayer and:filledList];
	[scene addChild: layer];
	return scene;
}

-(void)createBuildLayerWith:(id)boxLayer and:(id)filledList
{
    if (boxLayer!=nil&&filledList!=nil) {
        BuildLayer* build_layer = [[BuildLayer alloc] initWith:boxLayer and:filledList];
        [self addChild:build_layer z:5 tag:1];
    }
    else {
        BuildLayer* build_layer = [[BuildLayer alloc] initFirst];
        [self addChild:build_layer z:5 tag:1];
    }
}
-(void)onEnter
{
    [super onEnter];
    winSize = [[CCDirector sharedDirector] winSize];
    
    //init game layer
//    GameLayer* gameLayer = [GameLayer node];
//    [self addChild:gameLayer z:5 tag:1];
    
    //Init user interface
    UILayer* userinterface = [UILayer node];
    [self addChild:userinterface z:10 tag:2];
}


@end
