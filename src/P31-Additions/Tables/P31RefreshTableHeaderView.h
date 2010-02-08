//
//  P31RefreshTableHeaderView.h
//
//

#import <UIKit/UIKit.h>

typedef enum {
	RefreshHeaderReleaseToReload,
	RefreshHeaderPullToReload,
	RefreshHeaderLoadingStatus
} RefreshHeaderStatus;


@class TTView;

@interface P31RefreshTableHeaderView : UIView
{
	NSDate *_lastUpdatedDate;
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	TTView *_arrowImageView;
	UIActivityIndicatorView *_activityView;

	BOOL _isFlipped;
}
@property (nonatomic) BOOL isFlipped;


- (void)flipImageAnimated:(BOOL)animated;
- (void)setCurrentDate;
- (void)setUpdateDate:(NSDate*)date;
- (void)showActivity:(BOOL)shouldShow;
- (void)setStatus:(RefreshHeaderStatus)status;

@end
