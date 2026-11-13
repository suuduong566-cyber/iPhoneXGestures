#import <UIKit/UIKit.h>

static UIWindow *gStrip = nil;

static void XGAlert(NSString *title, NSString *msg) {
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:title message:msg
        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [a show];
}

static BOOL XGCall(NSArray *names) {
    id ui = [NSClassFromString(@"SBUIController")
        performSelector:NSSelectorFromString(@"sharedInstance")];
    for (NSString *n in names) {
        SEL s = NSSelectorFromString(n);
        if ([ui respondsToSelector:s]) {
            [ui performSelector:s];
            return YES;
        }
    }
    return NO;
}

@interface XGHandler : NSObject
+ (instancetype)shared;
- (void)pan:(UIPanGestureRecognizer *)g;
@end

@implementation XGHandler
+ (instancetype)shared {
    static XGHandler *h = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ h = [[XGHandler alloc] init]; });
    return h;
}
- (void)pan:(UIPanGestureRecognizer *)g {
    if (g.state != UIGestureRecognizerStateEnded) return;
    CGPoint t = [g translationInView:g.view];
    CGPoint v = [g velocityInView:g.view];
    if (t.y > -40) return;
    NSArray *names = (v.y < -800)
        ? @[@"clickedMenuButton"]
        : @[@"handleMenuDoubleTap", @"_toggleSwitcher"];
    if (!XGCall(names)) {
        XGAlert(@"Thieu ham", [names componentsJoinedByString:@", "]);
    }
}
@end

static void XGSetup(void) {
    if (gStrip) return;
    CGRect sc = [UIScreen mainScreen].bounds;
    gStrip = [[UIWindow alloc] initWithFrame:
        CGRectMake(0, sc.size.height - 12, sc.size.width, 12)];
    gStrip.windowLevel = UIWindowLevelAlert + 1;
    gStrip.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
    UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc]
        initWithTarget:[XGHandler shared] action:@selector(pan:)];
    [gStrip addGestureRecognizer:p];
    gStrip.hidden = NO;
    XGAlert(@"iPhoneXGestures", @"Tweak da nap");
}

%ctor {
    NSLog(@"[iPhoneXGestures] loaded");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{ XGSetup(); });
}
