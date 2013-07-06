//
//  CustomMenu.m
//  TDprototype2
//
//  Created by Javiersu on 6/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CustomMenu.h"

@interface CustomMenu () {
    BOOL enabled_;
    id selectedItem_;
    NSArray* menuArray;
}
@end

@implementation CustomMenu
@synthesize isSelected;

-(id) initWithArray:(NSArray *)arrayOfItems
{
	if( (self=[super init]) ) {
#ifdef __CC_PLATFORM_IOS
#elif defined(__CC_PLATFORM_MAC)
		self.isMouseEnabled = YES;
#endif
		enabled_ = YES;
		
		// by default, menu in the center of the screen
		self.ignoreAnchorPointForPosition = YES;
		anchorPoint_ = ccp(0.5f, 0.5f);
		
		// XXX: in v0.7, winSize should return the visible size
		// XXX: so the bar calculation should be done there
#ifdef __CC_PLATFORM_IOS
//		CGRect r = [[UIApplication sharedApplication] statusBarFrame];
//		s.height -= r.size.height;
#endif
//		self.position = ccp(s.width/2, s.height/2);
		
		int z=0;
		
		for(CCSprite *item in arrayOfItems) {
			[self addChild: item z:z];
            item.visible = NO;
			z++;
		}
		
		selectedItem_ = nil;
	}
	
	return self;
}

-(void)onEnter
{
    [super onEnter];
}

-(void)arrangeCircle
{
    if ([[self children]count]>0&&!isSelected) {
        isSelected=YES;
        float angle = M_PI*2/[[self children] count];
        int i = 1;
        for (CCNode* menuItem in [self children]) {
            menuItem.visible = YES;
            CGPoint endpoint = ccpMult(ccp(cosf(angle*i),sinf(angle*i)),75);
            CCMoveBy* move = [CCMoveBy actionWithDuration:0.5 position:endpoint];
            id ease = [CCEaseElasticOut actionWithAction:move];

            [menuItem runAction:ease];
            i++;
        }
    }
}

-(void)keepCircle
{
    if (isSelected) {
        isSelected = NO;
        for (id menuItem in [self children]) {
            [menuItem setVisible:NO];
            [menuItem setPosition:ccp(0,0)];
        }
    }
}

@end
