//
//  UnUsualLeafTableViewController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClickableView.h"
@interface UnUsualLeafTableViewController: UITableViewController<UITableViewDataSource,ClickableHeaderViewDelegate>
typedef enum {
    UnUsualLeafTableViewControllerSituationVeryBad      = 1,
    UnUsualLeafTableViewControllerSituationBad          = 2,
    UnUsualLeafTableViewControllerSituationAgtLost      = 3,
    UnUsualLeafTableViewControllerSituationCusLost      = 4,
}UnUsualLeafTableViewControllerSituation;

@property (nonatomic, retain) NSArray *dataDictArray;
@property (nonatomic, readwrite) bool sectionVeryBadOpend;
@property (nonatomic, readwrite) bool sectionBadOpend;
- (id)initWithStyle:(UITableViewStyle)style dataDictArray:(NSArray*)dataDictArraySet Tag:(UnUsualLeafTableViewControllerSituation)situation;

@end
