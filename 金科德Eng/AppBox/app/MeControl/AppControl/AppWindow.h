//
//  AppWindow.h
//  MeAppBox
//
//  Created by absir on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConfig.h"
#import "MeAccessoryView.h"

enum _AlertType {
    altTyp_normal,
    altTyp_warn,
    altTyp_error,
};

enum _AccessoryType{
    assryTyp_normal,
    assryTyp_next,
    assryTyp_input,
    
    assryTyp_count,
};

#define UNIVERSAL_DEVICES   //UNSIGNED设备版本
#define REMOVEME_ANIMATION  @"REMOVEME_ANIMATION"
#define REMOVEME_VIEWCONTROLL   @"REMOVEME_VIEWCONTROLL"

@interface AppWindow : NSObject<UIAlertViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    //设备后缀
    NSString *deviceName;
    
    //等待选择按钮
    int runLoopCount;
    int runLoopIndex;
    
    //弹出菜单
    UIView *alertBackground;
    NSMutableArray *alertsAry;
    
    //缓存字典
    NSMutableDictionary *xibViewCaches;
    NSMutableDictionary *viewControllerCaches;
    
    //View对应子节点
    NSMutableDictionary *hashViewDictionary;
    
    //键盘大小
    CGSize keyboardSize;
    
    //激活后中间属性
    float activeRecord;
    UIView *activeSuper;
    UIView *activeBackground;
    
    //分开输入激活和TextField;
    UIView *activeResponder;
    UITextField *activeTextField;
    
    //输入框导航和载入输入框
    UIView *accessoryView;
    MeAccessoryToolBar *inputToolBar;
    
    //输入导航条缓存
    MeAccessoryToolBar *meAccessoryToolBars[assryTyp_count];
    
    //拓展视图控制器
    bool isAnimationIn;
    CGRect rectVc;
    UIViewController *rectViewController;
}
@property(nonatomic, readonly)NSString *deviceName;
@property(nonatomic, readonly)int runLoopIndex;
@property(nonatomic, readonly)UIView *accessoryView;
@property(nonatomic, readonly)MeAccessoryToolBar *inputToolBar;
@property(nonatomic, readonly)bool isAnimationIn;
@property(nonatomic, retain)UIViewController *rectViewController;

//静态返回对象
+ (id)shared;

//获取指针映射NSNumber
+ (NSNumber *)keyFromObject:(id)sender;
//获取映射NSNumber指针
+ (id)objectFromKey:(NSNumber *)key;

//跳转至程序
+ (void)redirectAppUrl;
+ (void)redirectAuthorUrl;
+ (void)rateAppUrl;

//获取顶级视图
+ (UIWindow *)keyWindow;
+ (UIView *)frontView;
+ (void)writeSuperView:(UIView *)view;
+ (void)writeAllSubViews;
+ (void)writeSubViews:(UIView *)view :(int)level :(int)limit;

//设置全局翻转
+ (void)setOrientation:(UIInterfaceOrientation)orientation;

//获取上级空间
+ (id)fetchView:(UIView *)view Class:(Class)cls;

//获取绝对坐标
+ (CGRect)getWorldFrame:(UIView *)view;
+ (CGRect)getTranformFrame:(UIView *)view :(UIView *)from;
//获取View的截图
+ (UIImage *)getRenderImageView:(UIView *)view;

//缩放视图
+ (void)setView:(UIView *)view Scale:(float)scale;
+ (void)setView:(UIView *)view ScaleX:(float)sx Y:(float)sy;

//设置圆角视图
+ (void)setMasksToBounds:(UIView *)view;
+ (void)setMasksToBounds:(UIView *)view MR:(float)mR;
+ (void)setMasksToBounds:(UIView *)view MR:(float)mR BC:(CGColorRef)bC BW:(float)bW;

//设置背景图片
+ (void)setStretchable:(UIImageView *)view;
+ (void)setBackgroundView:(UIView *)view Image:(UIImage *)image;
+ (void)setPatternView:(UIView *)view Image:(UIImage *)image;

//页面切换
+ (UIViewController *)frontViewController;
+ (void)pushViewController:(UIViewController *)viewController Animated:(BOOL)animated;

//动画输入框
+ (void)accessoryAnimationInView:(UIView *)view;
+ (void)accessoryAnimationOutView:(UIView *)view;

//小视图整理
+ (void)patternView:(UIView *)parent Tile:(UIView *)tile;
+ (void)patternView:(UIView *)parent Tile:(UIView *)tile Rset:(CGRect)rset;
+ (void)patternView:(UIView *)parent Tiles:(NSArray *)tiles EdgeW:(CGPoint)edgW EdgeW:(CGPoint)edgH;
+ (void)patternView:(UIView *)parent Tiles:(NSArray *)tiles EdgeW:(CGPoint)edgW EdgeW:(CGPoint)edgH Pattern:(int)pattern Rset:(CGRect)rset;

//弹出消息框
+ (void)alertMessage:(NSString *)message;
+ (void)alertMessage:(NSString *)message Type:(int)type;
+ (void)alertMessage:(NSString *)message Title:(NSString *)title;
+ (void)alertSureMessage:(NSString *)message;
+ (int)alertSelectMessage:(NSString *)message;

//载入进度框
+ (UIView *)loadingView:(UIView *)view Type:(int)type Data:(NSArray *)data;
+ (void)loadingWindow:(NSString *)text Type:(int)type Data:(NSArray *)data;
+ (void)loadingWindowRemoveType:(int)type;

//获取NavigationController
+ (UINavigationController *)getNavigationController;
//获取UITabBarController
+ (UITabBarController *)getTabBarController;
//设置UITabBarController
+ (void)setTabBarSelectedIndex:(NSUInteger)index;
//获取ModalController
+ (UIViewController *)getModalController;

// 创建触摸
+ (void)addTouchInView:(UIView *)view;

// 视图菜单
+ (void)addAlertView:(UIView *)alert;

//获取设备xib
+ (id)loadNibName:(NSString *)name;
+ (id)loadNibName:(NSString *)name Label:(UILabel **)label;
+ (id)loadNibName:(NSString *)name Labels:(NSArray **)labels;
+ (id)loadViewControllerClass:(Class)cls;
+ (NSString *)deviceNibName:(NSString *)name;
//设备xib补齐
- (NSString *)deviceNibName:(NSString *)name;

//常驻Xib
- (id)addNibName:(NSString *)name;
- (void)clearNibCaches;
- (id)addViewControllerClass:(Class)cls;
- (void)clearControllerCaches;
- (void)clearAllCaches;

//主进程等待消息框
- (int)runLoopAlert:(UIAlertView *)alert;
- (int)runLoopActionSheet:(UIActionSheet *)actionSheet;

//弹出菜单
- (void)showAlertView:(UIView *)alert;
- (void)showAlertViews:(NSArray *)alerts :(BOOL)all;

//关闭菜单
- (void)closeAlertView;
- (void)closeAllAlertView;

//激活焦点
- (void)becomeActive:(UIView *)responder;
- (void)resignActive:(UIView *)responder;

//关闭激活焦点
- (void)resignActiveResponder;
- (void)resignActiveResponder:(UIView *)responder;

//动画唯一焦点
- (void)accessoryAnimationInView:(UIView *)view;
- (void)accessoryAnimationInView:(UIView *)view Responder:(UIView *)responder;

//大HashView设置
- (void)addHashParent:(NSObject *)parent :(NSObject *)child;
- (void)removeHashParent:(NSObject *)parent :(NSObject *)child;
- (NSArray *)getHashChildren:(NSObject *)parent;

//获取输入导航条
- (MeAccessoryToolBar *)accessoryToolBarAtType:(int)type;

//拓展视图控制器
- (void)animationInViewController:(UIViewController *)viewController InRect:(CGRect)inRect :(BOOL)animation;
- (void)animationOutViewController:(BOOL)animation;

//自定义UIBarButtonItem
+ (UIBarButtonItem *)getBarItemTitle:(NSString *)title Target:(id)target Action:(SEL)action ImageName:(NSString *)name;

//旋转图片
+ (UIImage *)rotateImage:(UIImage *)image;
+ (UIImage *)rotateImage:(UIImage *)image :(float)rotate;

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
//过滤html标签
+ (NSString *)filterHtmlTag:(NSString *)originHtmlStr;
//检测是否有效email地址
+ (BOOL)validateEmail:(NSString *)email;
//检测是否有效手机号码
+(BOOL)validateMobile:(NSString *)mobile;

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;
//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string;

+ (NSString *)localWiFiIPAddress;

@end
