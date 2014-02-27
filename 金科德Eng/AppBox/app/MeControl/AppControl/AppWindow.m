                                              //
//  AppWindow.m
//  MeAppBox
//
//  Created by absir on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppWindow.h"

#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <QuartzCore/QuartzCore.h>

#import "MeTextField.h"

#define SCROLL_ACCESSORYVIEW_HEIGHT 64
#define SCROLL_ACCESSORYVIEW_DELAY  0.05f

@implementation AppWindow
@synthesize deviceName;
@synthesize runLoopIndex;
@synthesize accessoryView;
@synthesize inputToolBar;
@synthesize isAnimationIn;
@synthesize rectViewController;

static id _shared_ = NULL;
//初始化对象
+ (id)shared
{
    @synchronized(self)
	{
		if (!_shared_)
			_shared_ = [[self alloc] init];
		return _shared_;
	}
}

//获取指针映射NSNumber
+ (NSNumber *)keyFromObject:(id)sender
{
    return [NSNumber numberWithUnsignedLong:(unsigned)sender];
}
//获取映射NSNumber指针
+ (id)objectFromKey:(NSNumber *)key
{
    return (id)[key unsignedLongValue];
}

//跳转至程序
+ (void)redirectAppUrl
{
    NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/cn/app/id%@", BUNLD_APPID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
+ (void)redirectAuthorUrl
{
    NSString *url = [NSString stringWithFormat:@"itms-apps://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?term=%@", [BUNLD_AUTHOR stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
+ (void)rateAppUrl
{
    NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",BUNLD_APPID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

//获取顶级视图
+ (UIWindow *)keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}
+ (UIView *)frontView
{
    UIWindow *window = [self keyWindow];
    
    //return window;
    
    return [[window subviews] lastObject];
}
+ (void)writeSuperView:(UIView *)view
{
    NSLog(@"%@", view);
    
    view = [view superview];
    
    if(view)
        [self writeSuperView:view];
}
+ (void)writeAllSubViews
{
    [self writeSubViews:[self keyWindow] :0 :-1];
}
+ (void)writeSubViews:(UIView *)view :(int)level :(int)limit
{
    printf("%d\t%s\t%s\r\n", level, [NSStringFromCGRect([view frame]) UTF8String], [NSStringFromClass([view class]) UTF8String]);
    
    --limit;
    if(limit != 0)
    {
        NSArray *subViews = [view subviews];
        
        ++level;
        for (UIView *v in subViews) {
            
            [self writeSubViews:v :level :limit];
        }
    }
}

//设置全局翻转
+ (void)setOrientation:(UIInterfaceOrientation)orientation
{
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = application.keyWindow;
    
    if(!window) return;
    
    application.statusBarOrientation = orientation;
    
    CGFloat rotation = 0;
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotation = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotation = M_PI_2;
            break;
        default: //UIInterfaceOrientationPortrait
            break;
    }
    
    if(rotation < 0 || (rotation > 0 && rotation < M_PI)){
        float swap = rect.size.width;
        rect.size.width = rect.size.height;
        rect.size.height = swap;
    }
    
    [window setTransform:CGAffineTransformIdentity];
    [window setTransform:CGAffineTransformMakeRotation(rotation)];
    
    [window setBounds:rect];
    
    [[AppWindow shared] resetkeyboardSize];
}

//获取上级空间
+ (id)fetchView:(UIView *)view Class:(Class)cls
{
    while ((view = [view superview])) {
        if([view isKindOfClass:cls])
            return view;
    }
    
    return nil;
}

//获取绝对坐标
+ (CGRect)getWorldFrame:(UIView *)view
{
    return [self getTranformFrame:view :nil];
}
+ (CGRect)getTranformFrame:(UIView *)view :(UIView *)from
{
    CGRect frame = [view frame];
    UIView *parent = view;
    CGPoint offset;
    while ((parent = [parent superview]) && parent != from) {
        offset = parent.frame.origin;
        frame.origin.x += offset.x;
        frame.origin.y += offset.y;
        
        if([parent isKindOfClass:[UIScrollView class]]){
            offset = [(UIScrollView *)parent contentOffset];
            frame.origin.x -= offset.x;
            frame.origin.y -= offset.y;
        }
    }
    
    return frame;
}

//获取View的截图
+ (UIImage *)getRenderImageView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//缩放视图
+ (void)setView:(UIView *)view Scale:(float)scale
{
    [self setView:view ScaleX:scale Y:scale];
}
+ (void)setView:(UIView *)view ScaleX:(float)sx Y:(float)sy
{
    CGRect rect = view.frame;
    float flt = rect.size.width;
    rect.size.width *= sx;
    rect.origin.x += (flt-rect.size.width)*0.5f;
    
    flt = rect.size.height;
    rect.size.height *= sy;
    rect.origin.y += (flt-rect.size.height)*0.5f;
    
    [view setFrame:rect];
}

//设置圆角视图
+ (void)setMasksToBounds:(UIView *)view
{
    [self setMasksToBounds:view MR:10];
}
+ (void)setMasksToBounds:(UIView *)view MR:(float)mR
{
    [self setMasksToBounds:view MR:mR BC:NULL BW:0];
}
+ (void)setMasksToBounds:(UIView *)view MR:(float)mR BC:(CGColorRef)bC BW:(float)bW
{
    CALayer *layer = view.layer;
    
    layer.masksToBounds = mR>0?TRUE:FALSE;
    if(!layer.masksToBounds) return;
    
    layer.cornerRadius = mR;
    if(!bC) return;
    
    layer.borderColor = bC;
    layer.borderWidth = bW;
}

//设置背景图片
+ (void)setStretchable:(UIImageView *)view
{
    UIImage *image = view.image;
    CGSize size = image.size;
    view.image = [image stretchableImageWithLeftCapWidth:size.width*0.5f topCapHeight:size.height*0.5f];
}
+ (void)setBackgroundView:(UIView *)view Image:(UIImage *)image
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    backgroundImageView.image = image;
    [view addSubview:backgroundImageView];
    [view sendSubviewToBack:backgroundImageView];
    [backgroundImageView release];
}
+ (void)setPatternView:(UIView *)view Image:(UIImage *)image
{
    UIColor *color = [[UIColor alloc] initWithPatternImage:image];
    [view setBackgroundColor:color];
    [color release];
}

//页面切换
+ (UIViewController *)frontViewController
{
    UIViewController *find = [[UIApplication sharedApplication] keyWindow].rootViewController;
    UIViewController *front = NULL;
    while (find) {
        front = find;
        if( [front modalViewController]){
            find = [front modalViewController];
            
        }else if([front isKindOfClass:[UITabBarController class]]){
            find = [(UITabBarController *)front selectedViewController];
            
        }else if([front isKindOfClass:[UINavigationController class]]){
            find = [[(UINavigationController *)front childViewControllers] lastObject];
            
        }else{
            break;
        }
    }
    return front;
}
+ (void)pushViewController:(UIViewController *)viewController Animated:(BOOL)animated
{
    [[self frontViewController].navigationController pushViewController:viewController animated:animated];
}

//动画输入框
+ (void)accessoryAnimationInView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGRect rect = view.frame;
    rect.origin.y = window.bounds.size.height;
    [view setFrame:rect];
    [window addSubview:view];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelay:SCROLL_ACCESSORYVIEW_DELAY];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    rect.origin.y -= rect.size.height;
    [view setFrame:rect];
    
    [UIView commitAnimations];
}
+ (void)accessoryAnimationOutView:(UIView *)view
{    
    CGRect rect = view.frame;
    [UIView beginAnimations:REMOVEME_ANIMATION context:NULL];
    [UIView setAnimationDelay:SCROLL_ACCESSORYVIEW_DELAY];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    rect.origin.y += rect.size.height;
    [view setFrame:rect];
    
    [UIView setAnimationDelegate:[self shared]];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

//小视图整理
+ (void)patternView:(UIView *)parent Tile:(UIView *)tile
{
    [self patternView:parent Tile:tile Rset:CGRectZero];
}
+ (void)patternView:(UIView *)parent Tile:(UIView *)tile Rset:(CGRect)rset
{
    CGSize size = parent.bounds.size;
    CGRect rect = tile.bounds;
    
    rect.origin = rset.origin;
    
    rect.size.width -= rset.origin.x + rset.size.width;
    rect.size.height -= rset.origin.y + rset.size.height;
    
    rect.origin.x += (size.width - rect.size.width) * 0.5f;
    rect.origin.y += (size.height - rect.size.height) * 0.5f;
    
    [tile setFrame:rect];
    
    [parent addSubview:tile];
}
+ (void)patternView:(UIView *)parent Tiles:(NSArray *)tiles EdgeW:(CGPoint)edgW EdgeW:(CGPoint)edgH
{
    [self patternView:parent Tiles:tiles EdgeW:edgW EdgeW:edgH Pattern:0 Rset:CGRectZero];
}
+ (void)patternView:(UIView *)parent Tiles:(NSArray *)tiles EdgeW:(CGPoint)edgW EdgeW:(CGPoint)edgH Pattern:(int)pattern Rset:(CGRect)rset
{
    int len = [tiles count];
    if(len <= 0) return;
    
    CGRect frame = [parent frame];
    frame.origin.x += rset.origin.x;
    frame.origin.y += rset.origin.y;
    frame.size.width -= rset.origin.x + rset.size.width;
    frame.size.height -= rset.origin.y + rset.size.height;
    
    CGRect rect = [[tiles objectAtIndex:0] bounds];
    
    if(pattern < 0){
        pattern = -pattern;
        frame.size.width = (rect.size.width + edgW.y) * pattern - edgW.y + 2 * edgW.x;
        frame.origin.x += (frame.size.width - frame.size.width)*0.5f;
        
    }else{
        
        //计算可排列个数
        if(pattern == 0){
            edgW.y += rect.size.width;
            if(edgW.y != 0)
                pattern = floorf((frame.size.width - 2 * edgW.x) / edgW.y);
            if(pattern < 1)
                pattern = 1;
        }
        
        if(edgW.x != 0 && edgW.x >= -3 && edgW.x <= 3)
            edgW.x = (frame.size.width - rect.size.width * (pattern - 1)) / (2 * edgW.x + (pattern - 1)/edgW.x);
        
        if(pattern <= 1)
            edgW.y = edgW.x;
        else
            edgW.y = (frame.size.width - 2 * edgW.x) / (pattern - 1) - rect.size.width;
        
        if(edgH.x != 0 && edgH.x >= -3 && edgH.x <= 3)
            edgH.x *= edgW.x;
        
        if(edgH.y !=0 && edgH.y >= -3 && edgH.y <= 3)
            edgH.y *= edgW.y;
    }
    
    //排列初始化
    edgW.x += rset.origin.x;
    edgW.y += rect.size.width;
    edgH.y += rect.size.height;
    
    rect.origin.y = edgH.x + rset.origin.y;
    
    //开始排列
    for(int i = 0, j, k; i < len; i += pattern){
        
        rect.origin.x = edgW.x;
        
        for(j = 0, k = i; j < pattern && k < len; j++, k++){
            UIView *tile = [tiles objectAtIndex:k];
            [tile setFrame:rect];
            [parent addSubview:tile];
            
            rect.origin.x += edgW.y;
        }
        
        rect.origin.y += edgH.y;
    }    
    
    frame.size.height = rect.origin.y + edgH.x;
    
    //还原父视图
    frame.origin.x -= rset.origin.x;
    frame.origin.y -= rset.origin.y;
    frame.size.width += rset.origin.x + rset.size.width;
    frame.size.height += rset.origin.y + rset.size.height;
    
    [parent setFrame:frame];
}


//弹出消息框
+ (void)alertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    //[self alertMessage:message Type:altTyp_normal];
}
+ (void)alertMessage:(NSString *)message Type:(int)type
{
    NSString *tit = NULL;
    switch (type) {
        case altTyp_warn:
            tit = @"Warn";
            break;
        case altTyp_error:
            tit = @"Error";
            break;
        default:
            tit = @"Notice";
            break;
    }
    [self alertMessage:message Title:tit];
}
+ (void)alertMessage:(NSString *)message Title:(NSString *)title
{
    AppWindow *appWindow = [AppWindow shared];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [appWindow runLoopAlert:alert];
    [alert release];
}
+ (void)alertSureMessage:(NSString *)message
{
    AppWindow *appWindow = [AppWindow shared];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:message delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [appWindow runLoopAlert:alert];
    [alert release];
}
+ (int)alertSelectMessage:(NSString *)message
{
    AppWindow *appWindow = [AppWindow shared];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:message delegate:NULL cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [appWindow runLoopAlert:alert];
    [alert release];
    
    return appWindow.runLoopIndex;
}

//载入进度框
#define LOADINGVIEW_TYPE_COUNT      1
#define LOADINGWINDOW_TYPE_COUNT    1
static BOOL _loadingDid_ = FALSE;
static UIView *_loadingView_[LOADINGVIEW_TYPE_COUNT];
static NSMutableArray *_loadingViewAry_[LOADINGVIEW_TYPE_COUNT];
static UIView *_loadingWindow_[LOADINGWINDOW_TYPE_COUNT];
static NSMutableArray *_loadingWindowAry_[LOADINGWINDOW_TYPE_COUNT];
+ (void)loadingViewDid
{
    if(_loadingDid_) return;
    
    _loadingDid_ = TRUE;
    
    for(int i=0; i<LOADINGVIEW_TYPE_COUNT; i++){
        _loadingView_[i] = NULL;
        _loadingViewAry_[i] = NULL;
    }
    
    for(int i=0; i<LOADINGWINDOW_TYPE_COUNT; i++){
        _loadingWindow_[i] = NULL;
        _loadingWindowAry_[i] = NULL;
    }
}
+ (UIView *)loadingView:(UIView *)view Type:(int)type Data:(NSArray *)data
{
    [self loadingViewDid];
    
    if(type<0 || type>=LOADINGVIEW_TYPE_COUNT) type=0;
    
    view = [[[UIView alloc] initWithFrame:view.bounds] autorelease];
    [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    
    if(!_loadingView_[type]){
        
        UIView *loadingView = NULL;
        UIActivityIndicatorView *actView;
        
        switch (type) {
            default:
                
                actView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
                [actView startAnimating];
                
                loadingView = actView;
                break;
        }
        
        _loadingView_[type] = [loadingView retain];
    }
    
    [self patternView:view Tile:_loadingView_[type]];
    
    return view;
}

+ (void)loadingWindow:(NSString *)text Type:(int)type Data:(NSArray *)data
{
    [self loadingViewDid];
    
    if(type<0 || type>=LOADINGWINDOW_TYPE_COUNT) type=0;
    
    UIView *loadingWindow;
    if(!_loadingWindow_[type]){
        
        _loadingWindowAry_[type] = [[NSMutableArray alloc] init];
        
        UILabel *label;
        switch (type) {
            default:
                loadingWindow = [self loadNibName:@"LoadingView" Label:&label];
                [AppWindow setMasksToBounds:loadingWindow];
                
                [_loadingWindowAry_[type] addObject:label];
                break;
        }
        
        _loadingWindow_[type] = [loadingWindow retain];
    }
    
    switch (type) {
        default:
            [(UILabel *)[_loadingWindowAry_[type] objectAtIndex:0] setText:text];
            break;
    }
    
    loadingWindow = _loadingWindow_[type].superview;
    if(loadingWindow.superview) [loadingWindow removeFromSuperview];
    
    UIView *frontView = [self frontView];
    
    loadingWindow = [[[UIView alloc] initWithFrame:frontView.bounds] autorelease];
    
    [self patternView:loadingWindow Tile:_loadingWindow_[type]];
    
    [frontView addSubview:loadingWindow];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}
+ (void)loadingWindowRemoveType:(int)type
{
    [self loadingViewDid];
    
    if(type<0 || type>=LOADINGWINDOW_TYPE_COUNT) type=0;
    
    if(_loadingWindow_[type]){
        UIView *superView = _loadingWindow_[type].superview;
        if(superView.superview){
            [superView removeFromSuperview];
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        }
    }
}

//获取NavigationController
+ (UINavigationController *)getNavigationController
{
    UIWindow *window = [self keyWindow];
    UINavigationController *vc = (UINavigationController *)window.rootViewController;
    while (vc) {
        if([vc navigationController])
            vc = vc.navigationController;
        
        if([vc isKindOfClass:[UINavigationController class]])
            break;
        else if(![vc modalViewController] && [vc isKindOfClass:[UITabBarController class]])
            vc = (UINavigationController *)[(UITabBarController *)vc selectedViewController];
        else
            vc = (UINavigationController *)vc.modalViewController;
    }
    return vc;
}
//获取UITabBarController
+ (UITabBarController *)getTabBarController
{
    UIWindow *window = [self keyWindow];
    UITabBarController *vc = (UITabBarController *)window.rootViewController;
    while (vc) {
        
        if([vc tabBarController])
            vc = vc.tabBarController;
        
        if([vc isKindOfClass:[UITabBarController class]])
            break;
        else if(![vc modalViewController] && [vc isKindOfClass:[UINavigationController class]])
            vc = (UITabBarController *)[(UINavigationController *)vc visibleViewController];
        else
            vc = (UITabBarController *)vc.modalViewController;
    }
    return vc;
}
//设置UITabBarController
+ (void)setTabBarSelectedIndex:(NSUInteger)index
{
    [[self getTabBarController] setSelectedIndex:index];
}
//获取ModalController
+ (UIViewController *)getModalController
{
    UIWindow *window = [self keyWindow];
    UIViewController *vc = window.rootViewController;
    UIViewController *rc = nil;
    while (vc) {
        rc = vc;
        
        if([vc modalViewController])
            vc = [vc modalViewController];
        else if([vc isKindOfClass:[UINavigationController class]])
            vc = [(UINavigationController *)vc visibleViewController];
        else if([vc isKindOfClass:[UITabBarController class]])
            vc = [(UITabBarController *)vc selectedViewController];
        else
            vc = nil;
    }
    return rc;
}

// 创建触摸
+ (void)addTouchInView:(UIView *)view
{

}

// 视图菜单
+ (void)addAlertView:(UIView *)alert
{
    UIViewController *modalController = [AppWindow getModalController];
    
    UIView *groundView = [[UIView alloc] initWithFrame:modalController.view.bounds];
    [groundView setBackgroundColor:[UIColor clearColor]];
    
    [modalController.view addSubview:groundView];
    [groundView release];
    
    [AppWindow patternView:groundView Tile:alert];
}

//获取设备xib
+ (id)loadNibName:(NSString *)name
{
#ifdef UNIVERSAL_DEVICES
    return [[[NSBundle mainBundle] loadNibNamed:[self deviceNibName:name] owner:NULL options:NULL] objectAtIndex:0];
#else
    return [[[NSBundle mainBundle] loadNibNamed:name owner:NULL options:NULL] objectAtIndex:0];
#endif
}
+ (id)loadNibName:(NSString *)name Label:(UILabel **)label
{
    UIView *view = [self loadNibName:name];
    if(![view isKindOfClass:[UIView class]]) return NULL;
    
    NSArray *children = [view subviews];
    for(UILabel *lab in children){
        if([lab isKindOfClass:[UILabel class]]){
            *label = lab;
            break;
        }
    }
    
    return view;
}
+ (id)loadNibName:(NSString *)name Labels:(NSArray **)labels
{
    UIView *view = [self loadNibName:name];
    if(![view isKindOfClass:[UIView class]]) return NULL;
    
    NSArray *children = [view subviews];
    NSMutableArray *collects = [NSMutableArray array];
    for(UILabel *lab in children){
        if([lab isKindOfClass:[UILabel class]]){
            [collects addObject:lab];
        }
    }
    
    *labels = collects;
    
    return view;
}
+ (id)loadViewControllerClass:(Class)cls
{
    NSString *name = NSStringFromClass(cls);
    return [[[cls alloc] initWithNibName:[AppWindow deviceNibName:name] bundle:nil] autorelease];
}

+ (NSString *)deviceNibName:(NSString *)name
{
#ifdef UNIVERSAL_DEVICES
    return [[AppWindow shared] deviceNibName:name];
#else
    return name;
#endif    
}
//设备xib补齐
- (NSString *)deviceNibName:(NSString *)name
{
    return [name stringByAppendingString:deviceName];
}

//常驻Xib
- (id)addNibName:(NSString *)name
{
    id val = [xibViewCaches objectForKey:name];
    if(!val)
    {
        val = [AppWindow loadNibName:name];
        [xibViewCaches setObject:val forKey:name];
    }
    return val;
}
- (void)clearNibCaches
{
    for (id key in xibViewCaches) {
        UIView *val = [xibViewCaches objectForKey:key];
        if([val retainCount] == 1){
            [xibViewCaches removeObjectForKey:key];
        }
    };
}
- (id)addViewControllerClass:(Class)cls
{
    NSString *name = NSStringFromClass(cls);
    id val = [viewControllerCaches objectForKey:name];
    if(!val)
    {
        val = [AppWindow loadViewControllerClass:cls];
        if(val){
            [viewControllerCaches setObject:val forKey:name];
        }
    }
    return val;
}
- (void)clearControllerCaches
{
    for (id key in viewControllerCaches) {
        UIView *val = [viewControllerCaches objectForKey:key];
        if([val retainCount] == 1){
            [viewControllerCaches removeObjectForKey:key];
        }
    };
}
- (void)clearAllCaches
{
    [self clearNibCaches];
    [self clearControllerCaches];
}

//获取键盘大小
- (void)resetkeyboardSize
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectNull];
    
    [[UIApplication sharedApplication].keyWindow addSubview:txtField];
    
    [txtField becomeFirstResponder];
    [txtField resignFirstResponder];
    
    [txtField removeFromSuperview];
    [txtField release];
}

//注册UIWindow通知
- (void)windowDidBecomeKeyNotification:(NSNotification *)aNotification
{
    [self resetkeyboardSize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeKeyNotification object:nil];
}
//软键盘消息
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey]; 
    keyboardSize = [value CGRectValue].size;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIDeviceOrientationLandscapeRight || orientation == UIDeviceOrientationLandscapeLeft){
        keyboardSize.height = 320;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:NULL];
}

//初始化对象
- (id)init
{
    if((self = [super init])){
        //系统消息管理
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        //注册初始化UIWindow后通知
        [defaultCenter addObserver:self selector:@selector(windowDidBecomeKeyNotification:) name:UIWindowDidBecomeKeyNotification object:nil];
        
        //注册键盘通知
        //[defaultCenter addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
        
        //获取设备后缀
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            deviceName = IPAD_SUFFIX;
        } else {
            deviceName = IPHONE_SUFFIX;
        }
        [deviceName retain];
        
        alertsAry = [[NSMutableArray alloc] init];
        
        xibViewCaches = [[NSMutableDictionary alloc] init];
        viewControllerCaches = [[NSMutableDictionary alloc] init];
        
        hashViewDictionary = [[NSMutableDictionary alloc] init];
        
        int i;
        for(i=0; i<assryTyp_count; i++){
            meAccessoryToolBars[i] = NULL;
        }
    }
    return self;
}

//释放对象
- (void)dealloc
{
    [deviceName release];
    
    [alertsAry release];
    
    [xibViewCaches release];
    [viewControllerCaches release];
    
    [hashViewDictionary release];
    
    for(int i=0; i<assryTyp_count; i++){
        [meAccessoryToolBars[i] release];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [rectViewController release];
    
    if(self==_shared_){
        _shared_ = NULL;
        
        if(_loadingDid_){
            
            _loadingDid_ = FALSE;
            
            for(int i=0; i<LOADINGVIEW_TYPE_COUNT; i++){
                [_loadingView_[i] release];
                [_loadingViewAry_[i] release];
            }
            
            for(int i=0; i<LOADINGWINDOW_TYPE_COUNT; i++){
                [_loadingWindow_[i] release];
                [_loadingWindowAry_[i] release];
            }
        }
    }
    [super dealloc];
}

//弹出框方法
- (int)runLoopAlert:(UIAlertView *)alert
{
    runLoopCount++;
    runLoopIndex = -1;
    [alert setDelegate:self];
    [alert show];
    while (runLoopCount || runLoopIndex == -1) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return runLoopIndex;
}
- (int)runLoopActionSheet:(UIActionSheet *)actionSheet
{
    runLoopCount++;
    runLoopIndex = -1;
    [actionSheet setDelegate:self];
    [actionSheet showInView:[AppWindow frontView]];
    while (runLoopIndex == -1) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return runLoopIndex;
}

//弹出菜单
- (void)addAlertView:(UIView *)alert
{
    UIView *frontView = [AppWindow frontView];
    
    if(!alertBackground){
        alertBackground = [[UIView alloc] initWithFrame:frontView.bounds];
        
        [alertBackground setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
        
        [frontView addSubview:alertBackground];
        
        [alertBackground release];
    }
    
    UIView *alertView = [[UIView alloc] initWithFrame:frontView.bounds];
    [AppWindow patternView:alertView Tile:alert];
    
    [frontView addSubview:alertView];
    
    [alertView release];
}
- (void)showAlertView:(UIView *)alert
{
    [alertsAry addObject:alert];
    [self addAlertView:alert];
}
- (void)showAlertViews:(NSArray *)alerts :(BOOL)all
{
    UIView *alert = NULL;
    
    for (alert in alerts) {
        
        if([alert superview]){
            [alert removeFromSuperview];
        }
        
        [alertsAry addObject:alert];
        
        if(all) [self addAlertView:alert];
    }
    
    if(!all) [self addAlertView:alert];
}

//关闭菜单
- (void)closeAlertView
{
    if(!alertsAry) return;
    
    UIView *alert = [alertsAry lastObject];
    [alert.superview removeFromSuperview];
    
    [alertsAry removeLastObject];
    alert = [alertsAry lastObject];
    
    if(!alert){
        
        if(alertBackground){
            [alertBackground removeFromSuperview];
            alertBackground = NULL;
        }
        
    } else if(![alert superview]){
        
        [self addAlertView:alert];
    }
    
}
- (void)closeAllAlertView
{
    if(!alertsAry) return;
    
    for(UIView *view in alertsAry){
        [view.superview removeFromSuperview];
    }
    
    if(alertBackground){
        [alertBackground removeFromSuperview];
        alertBackground = NULL;
    }
    
    [alertsAry removeAllObjects];
}

//激活焦点
- (void)becomeActive:(UIView *)responder
{
    UIView *superView = [responder superview];
    CGSize size = [[AppWindow frontView] bounds].size;
    CGRect frame = [AppWindow getWorldFrame:responder];
    CGRect superRect = [superView frame];
    
    if(activeSuper != superView){
        if(activeSuper){
            [self resignActiveResponder];
        }
        
        activeSuper = superView;
        activeRecord = superRect.origin.y;
    }
    
    float offerset = size.height - (IS_IPAD?550: 270)/*keyboardSize.height*/ - SCROLL_ACCESSORYVIEW_HEIGHT - frame.size.height - frame.origin.y;
    
    if(offerset > 0){
        float offset = activeRecord - superRect.origin.y;
        if(offset < 0) offerset = 0;
        else if(offerset > offset) offerset = offset;
    }
    
    if(offerset){
        
        UIScrollView *scrollView = (UIScrollView *)[superView superview];
        
        if([scrollView isKindOfClass:[UIScrollView class]]){
            
            CGPoint offset = [scrollView contentOffset];
            offset.y -= offerset;
            
            [scrollView setContentOffset:offset animated:TRUE];
            
        } else {
            
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDelay:SCROLL_ACCESSORYVIEW_DELAY];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            superRect.origin.y += offerset;
            [superView setFrame:superRect];
            
            [UIView commitAnimations];
        }
    }
    
    //设置当前激活的控件
    activeResponder = responder;
}
- (void)resignActive:(UIView *)responder
{
    if(!responder || responder != activeResponder) return;
    
    UIView *superView = [responder superview];
    if(superView == activeSuper && ![[superView superview] isKindOfClass:[UIScrollView class]]){
        
        CGRect superRect = [superView frame];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelay:SCROLL_ACCESSORYVIEW_DELAY];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        superRect.origin.y = activeRecord;
        superView.frame = superRect;
        
        [UIView commitAnimations];
    }
    
    if(activeBackground){
        [activeBackground removeFromSuperview];
        activeBackground = NULL;
    }
    
    activeResponder = NULL;
}

//关闭激活焦点
- (void)resignActiveResponder
{
    [self resignActiveResponder:NULL];
}
- (void)resignActiveResponder:(UIView *)responder
{
    //[activeTextField resignFirstResponder];
    if(responder != activeResponder){
        [self resignActive:activeResponder];
    }
    
    if(accessoryView){
        [AppWindow accessoryAnimationOutView:accessoryView];
        accessoryView = NULL;
    }
}

//动画唯一焦点
- (void)accessoryAnimationInView:(UIView *)view
{
    [self accessoryAnimationInView:view Responder:NULL];
}
- (void)accessoryAnimationInView:(UIView *)view Responder:(UIView *)responder
{
    [self resignActiveResponder:responder];
    
    [AppWindow accessoryAnimationInView:view];
    accessoryView = view;
}

//大HashView设置
- (void)addHashParent:(NSObject *)parent :(NSObject *)child
{
    NSNumber *key = [AppWindow keyFromObject:parent];
    NSMutableArray *children = [hashViewDictionary objectForKey:key];
    if(!children){
        children = [[NSMutableArray alloc] init];
        [hashViewDictionary setObject:children forKey:key];
        [children release];
    }
    
    [children addObject:child];
}
- (void)removeHashParent:(NSObject *)parent :(NSObject *)child
{
    NSNumber *key = [AppWindow keyFromObject:parent];
    NSMutableArray *children = [hashViewDictionary objectForKey:key];
    if(children){
        [children removeObject:child];
        if(![children count]){
            [hashViewDictionary removeObjectForKey:key];
        }
    }
}
- (NSArray *)getHashChildren:(NSObject *)parent
{
    NSNumber *key = [AppWindow keyFromObject:parent];
    return [hashViewDictionary objectForKey:key];
}

//弹出菜单委托实现方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    runLoopCount --;
    runLoopIndex = buttonIndex;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    runLoopCount --;
    runLoopIndex = buttonIndex;
}

//获取输入导航条
- (MeAccessoryToolBar *)accessoryToolBarAtType:(int)type
{
    if(type < 0 || type >= assryTyp_count) return NULL;
    
    NSString *assryNib = NULL;
    switch (type) {
        case assryTyp_normal:
            assryNib = @"MeAccessoryToolBar";
            break;
        case assryTyp_next:
            assryNib = @"NextAccessoryToolBar";
            break;
        default:
            break;
    }
    
    if(assryNib){
        return [AppWindow loadNibName:assryNib];
    }
    
    return NULL;
}

//输入框委托方法、实现
- (BOOL)textFieldShouldBeginEditing:(MeTextField *)textField
{
    if(![textField isEnabled]) return FALSE;
    
    if(accessoryView){
        [AppWindow accessoryAnimationOutView:accessoryView];
        accessoryView = NULL;
    }
    
    activeTextField = textField;
    if(![textField isKindOfClass:[MeTextField class]]) return TRUE;
    
    int typIdx = [textField accessoryViewType];
    if(typIdx >= 0 && typIdx <= assryTyp_count){
        if(!meAccessoryToolBars[typIdx]){
            meAccessoryToolBars[typIdx] = [[self accessoryToolBarAtType:typIdx] retain];
        }
        
        inputToolBar = meAccessoryToolBars[typIdx];
        [inputToolBar setAccessoryResponder:textField];
        
        textField.inputAccessoryView = inputToolBar;
    }
    
    return TRUE;
}
- (void)textFieldDidEndEditing:(MeTextField *)textField
{
    if(![textField isKindOfClass:[MeLengthField class]]) return;
    
    [textField sendActionsForControlEvents:UIControlEventTouchUpOutside];
}

- (BOOL)textFieldShouldReturn:(MeTextField *)textField
{
    if([textField isKindOfClass:[MeTextField class]]) [textField sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    return TRUE;
}

- (BOOL)textViewShouldBeginEditing:(MeTextView *)textView
{
    if(![textView isEditable]) return FALSE;
    
    if(accessoryView){
        [AppWindow accessoryAnimationOutView:accessoryView];
        accessoryView = NULL;
    }
    
    activeTextField = (UITextField *)textView;
    if(![textView isKindOfClass:[MeTextView class]]) return TRUE;
    
    int typIdx = [textView accessoryViewType];
    if(typIdx >= 0 && typIdx <= assryTyp_count){
        if(!meAccessoryToolBars[typIdx]){
            meAccessoryToolBars[typIdx] = [[self accessoryToolBarAtType:typIdx] retain];
        }
        
        inputToolBar = meAccessoryToolBars[typIdx];
        [inputToolBar setAccessoryResponder:(UIControl *)textView];
        
        textView.inputAccessoryView = inputToolBar;
    }
    
    return TRUE;
}

//动画结束委托
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if([animationID isEqualToString:REMOVEME_ANIMATION]){
        
        [(UIView *)context removeFromSuperview];
        
    }
    if([animationID isEqualToString:REMOVEME_VIEWCONTROLL]){
        
        [self animationOutViewController:false];
        
    }
    else{
        
        [(UIView *)context setAlpha:1.0];
        
        [UIView beginAnimations:REMOVEME_ANIMATION context:context];
        [UIView setAnimationDuration:0.5];
        
        [(UIView *)context setAlpha:0.2];
        
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];
    }
}

//拓展视图控制器
#define Animation_In_Delay  0.32f
- (void)animationInViewController:(UIViewController *)viewController InRect:(CGRect)inRect :(BOOL)animation
{
    [self animationOutViewController:false];
    
    UIWindow *window = [AppWindow keyWindow];
    UIViewController *rootController = window.rootViewController;
    if(!rootController) return;
    
    isAnimationIn = true;
    
    self.rectViewController = rootController;
    window.rootViewController = viewController;
    
    UIView *superView = viewController.view;
    [superView addSubview:rootController.view];
    
    UIView *subView = rootController.view;
    rectVc = subView.frame;
    
    if(animation)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:Animation_In_Delay];
    }
    
    inRect.origin.x += rectVc.origin.x;
    inRect.origin.y += rectVc.origin.y;
    inRect.size.width += rectVc.size.width;
    inRect.size.height += rectVc.size.height;
    
    [subView setFrame:inRect];
    
    if(animation)
    {
        [UIView commitAnimations];
    }
}
- (void)animationOutViewController:(BOOL)animation;
{
    if(!isAnimationIn) return;
    
    UIWindow *window = [AppWindow keyWindow];
    
    if(animation)
    {
        [UIView beginAnimations:REMOVEME_VIEWCONTROLL context:nil];
        [UIView setAnimationDelay:Animation_In_Delay];
        
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        [rectViewController.view setFrame:rectVc];
        
        [UIView commitAnimations];
        
    }else {
        
        isAnimationIn = false;
        
        [rectViewController.view setFrame:rectVc];
        [rectViewController.view removeFromSuperview];
        [window setRootViewController:rectViewController];
        
        [self setRectViewController:nil];
    }
    
}

//自定义BarItem
+ (UIBarButtonItem *)getBarItemTitle:(NSString *)title Target:(id)target Action:(SEL)action ImageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:[name stringByAppendingString:RES_NORMAL_PNG]];
    
    if(!image) return nil;
    
    UIButton *barBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [barBackButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [barBackButton setTitle:title forState:UIControlStateNormal];
    [barBackButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    
    [barBackButton setBackgroundImage:image forState:UIControlStateNormal];
    [barBackButton setBackgroundImage:[UIImage imageNamed:[name stringByAppendingString:RES_DOWN_PNG]] forState:UIControlStateHighlighted];
    
    [barBackButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:barBackButton] autorelease];
}

//旋转图片
+ (UIImage *)rotateImage:(UIImage *)image
{
    CGSize size = image.size;
    
    CGSize newSize;
    
    newSize.width = size.height;
    newSize.height = size.width;
    
    //NSLog(@"%@", NSStringFromCGSize(newSize));
    
    UIGraphicsBeginImageContext(newSize);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(ctx, M_PI_2);
    
    //CGContextTranslateCTM(ctx, 0, -newSize.width);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextDrawImage(ctx, CGRectMake(0,0,size.width, size.height), image.CGImage);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)rotateImage:(UIImage *)image :(float)rotate
{
//    CGSize size = image.size;
//    
//    float radio = size.width * size.width + size.height * size.height;
//    
//    
//    UIGraphicsBeginImageContext(size);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextRotateCTM(ctx, rotate);
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0,0,size.width, size.height), image.CGImage);
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return image;
}

#define DEFAULT_VOID_COLOR [UIColor blackColor]
//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSString *)filterHtmlTag:(NSString *)originHtmlStr{
    NSString *result = nil;
    NSRange arrowTagStartRange = [originHtmlStr rangeOfString:@"<"];
    if (arrowTagStartRange.location != NSNotFound) { //如果找到
        NSRange arrowTagEndRange = [originHtmlStr rangeOfString:@">"];
        //NSLog(@"start-> %d   end-> %d", arrowTagStartRange.location, arrowTagEndRange.location);
        //NSString *arrowSubString = [originHtmlStr substringWithRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location)];
        result = [originHtmlStr stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];
        // NSLog(@"Result--->%@", result);
        return [self filterHtmlTag:result];    //递归，过滤下一个标签
    }else{
        result = [originHtmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];  // 过滤&nbsp等标签
        //result = [originHtmlStr stringByReplacingOccurrencesOf  ........
    }
    return result;
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[[NSScanner alloc] initWithString:hexCharStr] autorelease];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (NSString *)localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

@end

