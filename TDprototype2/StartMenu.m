//
//  StartMenu.m
//  TDprototype2
//
//  Created by Javiersu on 21/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StartMenu.h"
#import "GameScene.h"

@interface StartMenu () {
    CGSize winSize;
}

@end

@implementation StartMenu

+(id) scene
{
	CCScene *scene = [CCScene node];
	StartMenu *layer = [StartMenu node];
	[scene addChild: layer];
	return scene;
}

-(id)init
{
    if (self = [super init]) {

    }
    return self;
}

-(void)onEnter
{
    winSize = [[CCDirector sharedDirector] winSize];
    [self createTextField];
}

-(void)createTextField
{
    UITextField* txt = [[UITextField alloc] initWithFrame:CGRectMake(winSize.width/2-100, winSize.height/2-60, 200, 40)];
    txt.borderStyle = UITextBorderStyleRoundedRect;
    txt.textColor = [UIColor blackColor];
    txt.font = [UIFont systemFontOfSize:17.0];
    txt.placeholder = @"Username";
    txt.backgroundColor = [UIColor whiteColor];
    txt.autocorrectionType = UITextAutocorrectionTypeNo;
    txt.delegate = self;
    [txt setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    txt.keyboardType = UIKeyboardTypeDefault;
    txt.returnKeyType = UIReturnKeyDone;
    txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[[CCDirector sharedDirector] view] addSubview:txt];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // the user pressed the "Done" button, so dismiss the keyboard
    [textField resignFirstResponder];
    [textField removeFromSuperview];
    [[CCDirector sharedDirector]pushScene:[GameScene scene]];
    return YES;
}
@end
