//
//  MenuLayer.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "CustomMenu.h"
#import "Structure Menu.h"

@implementation MenuLayer
NSArray* menuArray;
CGSize winSize;
UIGestureRecognizer *tapGestureRecognizer;
Structure_Menu* menu;
@synthesize isMenuOpen;
+(id) scene
{
	CCScene *scene = [CCScene node];
	MenuLayer *layer = [MenuLayer node];
	[scene addChild: layer];
	return scene;
}

-(id)init
{
    if (self = [super init]) {
        NSLog(@"menuLayer created");
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    self.isTouchEnabled=YES;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    [ self setAnchorPoint:ccp(0.5,0.5)];
    winSize = [[CCDirector sharedDirector]winSize];
    menu = [[Structure_Menu alloc]init];
    [self addChild:menu];
    [menu setPosition:ccp(winSize.width/2,winSize.height/2)];
    isMenuOpen = NO;
}

-(void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    NSLog(@"tapped");
    if (isMenuOpen) {
        [menu keepCircle];
        isMenuOpen = NO;
    }
    else {
        isMenuOpen = YES;
        [menu arrangeCircle];
    }
    
    
}

@end