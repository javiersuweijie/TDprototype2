//
//  CustomMenuItem.h
//  TDprototype2
//
//  Created by Javiersu on 6/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CustomMenuItem : CCSprite <UIGestureRecognizerDelegate>{
}

// weak references

/** the image used when the item is not selected */
@property (nonatomic,readwrite,assign) CCNode<CCRGBAProtocol> *normalImage;
/** the image used when the item is selected */
@property (nonatomic,readwrite,assign) CCNode<CCRGBAProtocol> *selectedImage;
/** the image used when the item is disabled */
@property (nonatomic,readwrite,assign) CCNode<CCRGBAProtocol> *disabledImage;

+(id)menuItemWithOnlyImage:(NSString*)normal target:(id)t selector:(SEL)s;
+(id)menuItemWithImage:(NSString*)normal selected:(NSString*)selected disabled:(NSString*)disabled target:(id)t selector:(SEL)s;

@end
