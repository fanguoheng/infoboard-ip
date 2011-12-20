//
//  MD5.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
- (NSString *) md5;
@end

@interface NSData (MD5)
- (NSString*)md5;
@end