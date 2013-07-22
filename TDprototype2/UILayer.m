//
//  UILayer.m
//  TDprototype2
//
//  Created by Javiersu on 5/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UILayer.h"
#import "UnitsMenu.h"
#import "ResourceLabel.h"
#import "Structure Menu.h"
#import "ConfirmMenu.h"
#import "UpgradeMenu.h"

@implementation UILayer
CGSize winSize;
UIGestureRecognizer *tapGestureRecognizer;
Structure_Menu* menu;
ConfirmMenu* confirmMenu;
-(void)onEnter
{
    [super onEnter];
    winSize = [[CCDirector sharedDirector]winSize];
    menu = [[Structure_Menu alloc]init];
    [self addChild:menu z:1 tag:1];
    
    confirmMenu = [[ConfirmMenu alloc]init];
    [self addChild:confirmMenu z:2 tag:2];
    
    id resource = [[ResourceLabel alloc]init];
    [self addChild:resource];
    
    [menu setConfirmMenu:confirmMenu];
}

-(id)addUpgradeMenuOf:(Structure*)prev to:(NSString*)string, ...
{
    return nil;
}
@end
