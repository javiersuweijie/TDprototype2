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
    
}
@end

@implementation CustomMenu

+(id) menuWithArray:(NSArray *)arrayOfItems
{
	return [[[self alloc] initWithArray:arrayOfItems] autorelease];
}

-(id) initWithArray:(NSArray *)arrayOfItems
{
	if( (self=[super init]) ) {
        
		self.isTouchEnabled = YES;

		enabled_ = YES;
		
		// by default, menu in the center of the screen
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		self.ignoreAnchorPointForPosition = YES;
		anchorPoint_ = ccp(0.5f, 0.5f);
		[self setContentSize:s];
		
		// XXX: in v0.7, winSize should return the visible size
		// XXX: so the bar calculation should be done there
#ifdef __CC_PLATFORM_IOS
		CGRect r = [[UIApplication sharedApplication] statusBarFrame];
		s.height -= r.size.height;
#endif
		self.position = ccp(s.width/2, s.height/2);
		
		int z=0;
		
		for( CCMenuItem *item in arrayOfItems) {
			[self addChild: item z:z];
			z++;
		}
        
        //		[self alignItemsVertically];
		
		selectedItem_ = nil;
	}
	
	return self;
}


@end
