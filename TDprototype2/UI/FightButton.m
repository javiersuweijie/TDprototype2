//
//  FightButton.m
//  TDprototype2
//
//  Created by Javiersu on 27/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FightButton.h"
#import "CustomMenuItem.h"
#import "GameLayer.h"

@implementation FightButton
id game_layer;
-(id)init
{
    if (self = [super init])
    {
        id fight_button = [CustomMenuItem menuItemWithOnlyImage:@"fight_button.png" target:self selector:@selector(buttonPressed)];
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        [fight_button setAnchorPoint:ccp(1,0)];
//        NSLog(@"%d",[self ignoreAnchorPointForPosition]);
        [fight_button setPosition:ccp(winSize.width/20*19, winSize.height/15)];
        [self addChild:fight_button];
    }
    return self;
}

-(void)buttonPressed
{
    NSLog(@"Fight button pressed");
    if (!game_layer) {
        game_layer = [[[self parent]parent]getChildByTag:1];
    }

    [game_layer testSP];
}

@end
