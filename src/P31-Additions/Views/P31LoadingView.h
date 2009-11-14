//
//  LoadingView.h
//  LoadingView

#import "TTGlobal.h"


@interface P31LoadingView : UIView
{
	UIWindow *_backgroundWindow;
}
@property (nonatomic, retain) UIWindow *backgroundWindow;

+ (P31LoadingView*)loadingViewShowWithLoadingMessage;
+ (P31LoadingView*)loadingViewShowWithMessage:(NSString*)message;

- (id)initWithFrame:(CGRect)frame message:(NSString*)message;

- (void)show;
- (void)hide;
- (void)hideWithDoneImage;
- (void)hideWithDoneImageAndMessage:(NSString*)message;

- (void)setMessage:(NSString*)message;

@end
