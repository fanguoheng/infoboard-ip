//
//  CVTableCellBGView.h
//  Restaurant
//
//  Created by Kesalin on 6/21/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum GradientColorT{
    GradientColorNone,
    GradientColorWhite,
    GradientColorBlack,
    GradientColorGray,
    GradientColorRed,
    GradientColorGreen,
    GradientColorBlue,
    GradientColorPink,
    
    GradientColorCount
} GradientColor;

float* getGradientColor(int type);

typedef enum CellStyleT
{
	CellStyleNone,
	CellStyleTop,
	CellStyleMiddle,
	CellStyleBottom,
	CellStyleSingle,
    
    CellStyleCount
} CellStyle;

@interface CVTableCellBGView : UIView
{
    CellStyle           cellStyle;
    GradientColor       gradientColor;
}

@property (nonatomic, assign)CellStyle cellStyle;
@property (nonatomic, assign)GradientColor gradientColor;

@end
