//
//  IOObject.h
//  TDprototype2
//
//  Created by Javiersu on 6/7/13.
//
//

#import <Foundation/Foundation.h>

@interface IOOObject : NSObject
-(id)initWithList:(NSArray*)list;
-(void)sendData;
-(void)exportStructureListFrom:(NSArray*)filledList;
-(id)load;
@end
