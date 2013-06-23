//
//  ShortestPathStep.h
//  TDprototype2
//
//  Created by Javiersu on 8/6/13.
//
//

#import <Foundation/Foundation.h>

@interface ShortestPathStep : NSObject
{
    CGPoint position;
    int gScore;
    int hScore;
    ShortestPathStep *__weak parent;
}

@property (nonatomic,assign)CGPoint position;
@property (nonatomic,assign)int gScore;
@property (nonatomic,assign)int hScore;
@property (nonatomic,weak)ShortestPathStep *parent;

-(id)initWithPosition:(CGPoint)pos;
-(int)fScore;


@end
