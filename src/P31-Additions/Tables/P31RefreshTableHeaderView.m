//
//  P31RefreshTableHeaderView.m
//
//

#import "P31RefreshTableHeaderView.h"
#import "P31StyleSheet.h"
#import <QuartzCore/QuartzCore.h>


@implementation P31RefreshTableHeaderView

@synthesize isFlipped = _isFlipped;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame
{
	if( self = [super initWithFrame:frame] )
	{
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		_lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, frame.size.height - 30.0f, 320.0f, 20.0f )];
		_lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		_lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		_lastUpdatedLabel.textColor = TTSTYLEVAR( refreshTableHeaderTextColor );
		_lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_lastUpdatedLabel.shadowOffset = CGSizeMake( 0.0f, 1.0f );
		_lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		_lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_lastUpdatedLabel];

		/*
		if( [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"] )
		{
			_lastUpdatedLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
		}
		else
		{
			[self setCurrentDate];
		}
		*/

		[_lastUpdatedLabel release];

		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, frame.size.height - 48.0f, 320.0f, 20.0f )];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = TTSTYLEVAR( refreshTableHeaderTextColor );
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake( 0.0f, 1.0f );
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = UITextAlignmentCenter;
		[self setStatus:RefreshHeaderPullToReload];
		[self addSubview:_statusLabel];
		[_statusLabel release];

		_arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake( 25.0f, frame.size.height - 65.0f, 30.0f, 55.0f )];
		_arrowImage.contentMode = UIViewContentModeScaleAspectFit;
		_arrowImage.image = TTIMAGE( @"bundle://Prime31.bundle/images/blueArrow.png" );
		[_arrowImage layer].transform = CATransform3DMakeRotation( M_PI, 0.0f, 0.0f, 1.0f );
		[self addSubview:_arrowImage];
		[_arrowImage release];

		_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake( 25.0f, frame.size.height - 38.0f, 20.0f, 20.0f );
		_activityView.hidesWhenStopped = YES;
		[self addSubview:_activityView];
		[_activityView release];

		_isFlipped = NO;

	}
	return self;
}


- (void)dealloc
{
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public

- (void)flipImageAnimated:(BOOL)animated
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animated ? .18 : 0.0];
	[_arrowImage layer].transform = _isFlipped ? CATransform3DMakeRotation( M_PI, 0.0f, 0.0f, 1.0f ) : CATransform3DMakeRotation( M_PI * 2, 0.0f, 0.0f, 1.0f );
	[UIView commitAnimations];

	_isFlipped = !_isFlipped;
}


- (void)setUpdateDate:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setAMSymbol:@"AM"];
	[formatter setPMSymbol:@"PM"];
	[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
	
	_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
	
	//[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
	//[[NSUserDefaults standardUserDefaults] synchronize];
	
	[formatter release];
}


- (void)setCurrentDate
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setAMSymbol:@"AM"];
	[formatter setPMSymbol:@"PM"];
	[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
	
	_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:[NSDate date]]];
	
	//[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
	//[[NSUserDefaults standardUserDefaults] synchronize];
	
	[formatter release];
}


- (void)setStatus:(RefreshHeaderStatus)status
{
	switch( status )
	{
	case RefreshHeaderReleaseToReload :
		_statusLabel.text = @"Release to refresh...";
		break;
	case RefreshHeaderPullToReload:
		_statusLabel.text = @"Pull down to refresh...";
		break;
	case RefreshHeaderLoadingStatus:
		_statusLabel.text = @"Loading...";
		break;
	default:
		break;
	}
}


- (void)showActivity:(BOOL)shouldShow
{
	if( shouldShow )
	{
		[_activityView startAnimating];
		_arrowImage.hidden = YES;
		[self setStatus:RefreshHeaderLoadingStatus];
	}
	else
	{
		[_activityView stopAnimating];
		_arrowImage.hidden = NO;
	}

}


@end
