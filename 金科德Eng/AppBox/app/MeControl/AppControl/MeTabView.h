//
//  MeTabView.h
//  MeAppVideo
//
//  Created by absir on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeTabView : UIView
{
    NSArray *tabViews;
    UIView *tabContentView;
    
    UIView *contentView;
    IBOutlet UIButton *selectBtn;
    
    
}
@property(nonatomic, retain)IBOutlet UIView *tabContentView;
@property(nonatomic, readonly)int selectIndex;


@end
