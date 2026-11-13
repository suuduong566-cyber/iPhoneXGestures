#import <UIKit/UIKit.h>

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (BOOL)clickedMenuButton;
- (void)handleMenuDoubleTap;
@end

@interface XGHandler : NSObject
+ (void)pan:(UIPanGestureRecognizer *)g;
@end

@implementation XGHandler
+ (void)pan:(UIPanGestureRecognizer *)g {
    if (g.state != UIGestureRecognizerStateEnded) return;
    CGPoint t = [g translationInView:g.view];
    CGPoint v = [g velocityInView:g.view];
    if (t.y > -40) return;
    SBUIController *c = [%c(SBUIController) sharedInstance];
    if (v.y < -800) [c clickedMenuButton];
    else [c handleMenuDoubleTap];
}
@end

static UIWindow *gw;

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)a {
    %orig;
    CGRect s = [UIScreen mainScreen].bounds;
    gw = [[UIWindow alloc] initWithFrame:CGRectMake(0, s.size.height - 12, s.size.width, 12)];
    gw.windowLevel = 10000;
    gw.backgroundColor = [UIColor clearColor];
    gw.hidden = NO;
    [gw addGestureRecognizer:[[UIPanGestureRecognizer alloc]
        initWithTarget:[XGHandler class] action:@selector(pan:)]];
}
%end
