//
//  CustomMenuItem.m
//  TDprototype2
//
//  Created by Javiersu on 6/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CustomMenuItem.h"


@implementation CustomMenuItem
@synthesize selectedImage,disabledImage,normalImage;
BOOL isEnabled;

+(id)menuItemWithOnlyImage:(NSString*)normal target:(id)t selector:(SEL)s
{
    return [CustomMenuItem menuItemWithImage:normal selected:normal disabled:normal target:t selector:s];
}

+(id)menuItemWithImage:(NSString*)normal selected:(NSString*)selected disabled:(NSString*)disabled target:(id)t selector:(SEL)s
{
    return [[CustomMenuItem alloc] initMenuItemWithSprite:[CCSprite spriteWithFile:normal] selectedSprte:[CCSprite spriteWithFile:selected] disabledSprite:[CCSprite spriteWithFile:disabled] target:t selector:s];
}

-(id)initMenuItemWithSprite:(CCSprite*)normal selectedSprte:(CCSprite*)selected disabledSprite:(CCSprite*)disabled target:(id)t selector:(SEL)s
{
    if (self = [super init]) {
//        self.normalImage = normal;
//        self.selectedImage = selected;
//        self.disabledImage = disabled;
        
        isEnabled = YES;
        self.isTouchEnabled = YES;
        normal.anchorPoint=ccp(0,0);
        [self addChild:normal];
//        [self addChild:self.normalImage];
//        [self addChild:self.selectedImage];
//        [self addChild:self.disabledImage];
        
        self.contentSize = normal.contentSize;
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:t action:s];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void) setNormalImage:(CCNode <CCRGBAProtocol>*)image
{
	if( image != normalImage ) {
//		image.anchorPoint = ccp(0,0);
        
		[self removeChild:normalImage cleanup:YES];
		[self addChild:image];
        
		normalImage = image;
        
        [self setContentSize: [normalImage contentSize]];
		
		[self updateImagesVisibility];
	}
}

-(void) setSelectedImage:(CCNode <CCRGBAProtocol>*)image
{
	if( image != selectedImage ) {
//		image.anchorPoint = ccp(0,0);
        
		[self removeChild:selectedImage cleanup:YES];
		[self addChild:image];
        
		selectedImage = image;
		
		[self updateImagesVisibility];
	}
}

-(void) setDisabledImage:(CCNode <CCRGBAProtocol>*)image
{
	if( image != disabledImage ) {
//		image.anchorPoint = ccp(0,0);
        
		[self removeChild:disabledImage cleanup:YES];
		[self addChild:image];
        
		disabledImage = image;
		
		[self updateImagesVisibility];
	}
}

-(void) updateImagesVisibility
{
	if( isEnabled ) {
		[normalImage setVisible:YES];
		[selectedImage setVisible:NO];
		[disabledImage setVisible:NO];
		
	} else {
        [normalImage setVisible:NO];
        [selectedImage setVisible:NO];
        [disabledImage setVisible:YES];
	}
}
@end
