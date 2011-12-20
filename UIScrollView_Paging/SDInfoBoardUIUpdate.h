//
//  SDInfoBoardUIUpdate.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDInfoBoardUpdateUI <NSObject>
@optional
- (void)willInfoBoardUpdateUIOnPage:(id) msg;
- (void)didInfoBoardUpdateUI:(NSString*) msg;
@end
