//
//  MeLabel.h
//  EBooks
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#define UITextAlignmentJustify ((UITextAlignment)kCTJustifiedTextAlignment)

@interface MeLabel : UILabel
{
    NSMutableAttributedString *attributedText_;
    CTFrameRef textFrame_;
}

@end
