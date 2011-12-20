//
//  CustomCell.h
//  ReachDownloadShow_3
//
//  Created by crazysnow on 11-5-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell {
    UILabel *nameLabel;
    UILabel *agtIDLabel;
    UILabel *agtGroupsLabel;
    UILabel *agtLogonGrpsLabel;   
    UILabel *workStatusLabel;
}
@property (nonatomic, retain)IBOutlet UILabel *nameLabel;
@property (nonatomic, retain)IBOutlet UILabel *agtIDLabel;
@property (nonatomic, retain)IBOutlet UILabel *agtGroupsLabel;
@property (nonatomic, retain)IBOutlet UILabel *agtLogonGrpsLabel;
@property (nonatomic, retain)IBOutlet UILabel *workStatusLabel;


@end
