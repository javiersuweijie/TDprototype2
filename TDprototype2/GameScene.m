//
//  GameScene.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
@property (nonatomic) CGSize winSize;

@end

@implementation GameScene
@synthesize winSize;
+(id) scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	return scene;
}

-(void)onEnter
{
    [super onEnter];
    winSize = [[CCDirector sharedDirector] winSize];
    
    //Init user interface
    UILayer* userinterface = [UILayer node];
    [self addChild:userinterface z:10];
    
    //init game layer
    GameLayer* gameLayer = [GameLayer node];
    [self addChild:gameLayer z:5];
}
@end
