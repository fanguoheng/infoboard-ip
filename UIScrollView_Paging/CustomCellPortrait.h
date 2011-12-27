//
//  CustomCellPortrait.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellPortrait : UITableViewCell {
    
    UIImageView *groupIcon;
    
    UILabel *grpName;
    UILabel *login;
    UILabel *transAgt;
    UILabel *agtAnswer;
    UILabel *answerRate;
    UILabel *queueLen;
    UILabel *percentSign;

    
}

@property (nonatomic,retain) IBOutlet UIImageView *groupIcon;
@property (nonatomic,retain) IBOutlet UILabel *grpName;
@property (nonatomic,retain) IBOutlet UILabel *transAgt;
@property (nonatomic,retain) IBOutlet UILabel *agtAnswer;
@property (nonatomic,retain) IBOutlet UILabel *answerRate;
@property (nonatomic,retain) IBOutlet UILabel *percentSign;

@end

