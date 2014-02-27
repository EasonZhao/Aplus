//
//  MeScrollView.h
//  MeAppVideo
//
//  Created by absir on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeScrollView : UIScrollView
{
    UIView *conView_;
}
@property(nonatomic, retain) IBOutlet UIView *conView;

@end
