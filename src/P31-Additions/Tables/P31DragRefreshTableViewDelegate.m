//
//  P31DragRefreshTableViewDelegate.m
//  Tweets
//
//  Created by Mike on 11/6/09.
//  Copyright 2009 Prime31 Studios. All rights reserved.
//

#import "P31DragRefreshTableViewDelegate.h"
#import <Three20/TTGlobalUI.h>
#import <Three20/TTGlobalUINavigator.h>
#import "TTTableViewController.h"
#import "P31RefreshTableHeaderView.h"


@implementation P31DragRefreshTableViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject

- (id)initWithController:(TTTableViewController*)controller
{
	if( self = [super initWithController:controller] )
	{
		// Add our refresh header	
		_refreshHeaderView = [[P31RefreshTableHeaderView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f - _controller.tableView.bounds.size.height, TTScreenBounds().size.width, _controller.tableView.bounds.size.height )];
		_refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_refreshHeaderView.backgroundColor = RGBCOLOR( 226, 231, 237 );
		_refreshHeaderView.tag = kP31DragRefreshTableHeaderViewTag;
		[_controller.tableView addSubview:_refreshHeaderView];
		
		// Hook up to the model to listen for changes
		[controller.model.delegates addObject:self];
		
		// Grab the last refresh date if there is one
		if( [_controller.model respondsToSelector:@selector(loadedTime)] )
		{
			NSDate *date = [_controller.model performSelector:@selector(loadedTime)];
			
			if( date )
				[_refreshHeaderView setUpdateDate:date];
		}
	}
	return self;
}


- (void)dealloc
{
	[_controller.model.delegates removeObject:self];
  TT_RELEASE_SAFELY(_refreshHeaderView);
	
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If we will be displaying the last row we are going to load:more: when appropriate
	if( _controller.model.isLoaded && !_controller.model.isLoadingMore && !_controller.model.isLoading && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1 )
	{
		[_controller.model load:TTURLRequestCachePolicyDefault more:YES];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
	[super scrollViewDidScroll:scrollView];
	
	if( _checkForRefresh )
	{
		if( _refreshHeaderView.isFlipped && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_controller.model.isLoading )
		{
			[_refreshHeaderView flipImageAnimated:YES];
			[_refreshHeaderView setStatus:RefreshHeaderPullToReload];
		}
		else if( !_refreshHeaderView.isFlipped && scrollView.contentOffset.y < -65.0f )
		{
			[_refreshHeaderView flipImageAnimated:YES];
			[_refreshHeaderView setStatus:RefreshHeaderReleaseToReload];
		}
	}
}


- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
	[super scrollViewWillBeginDragging:scrollView];
	
	_checkForRefresh = YES;  //  only check offset when dragging
}


- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	
	// If dragging ends and we are far enough to be fully showing the header view trigger a load as long as we arent loading already
	if( scrollView.contentOffset.y <= -65.0f && !_controller.model.isLoading )
	{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"P31DragRefreshTableReload" object:nil];
		[_controller.model load:TTURLRequestCachePolicyNetwork more:NO];
	}
	
	_checkForRefresh = NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTModelDelegate

- (void)modelDidStartLoad:(id<TTModel>)model
{
	[_refreshHeaderView showActivity:YES];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	_controller.tableView.contentInset = UIEdgeInsetsMake( 60.0f, 0.0f, 00.0f, 0.0f );
	[UIView commitAnimations];
}


- (void)modelDidFinishLoad:(id<TTModel>)model
{
	[_refreshHeaderView flipImageAnimated:NO];
	[_refreshHeaderView setStatus:RefreshHeaderReleaseToReload];
	[_refreshHeaderView showActivity:NO];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[_controller.tableView setContentInset:UIEdgeInsetsMake( 0.0f, 0.0f, 00.0f, 0.0f )];
	[UIView commitAnimations];
	
	if( [model respondsToSelector:@selector(loadedTime)] )
	{
		NSDate *date = [model performSelector:@selector(loadedTime)];
		[_refreshHeaderView setUpdateDate:date];
	}
	else
	{
		[_refreshHeaderView setCurrentDate];
	}
}


- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error
{
	[_refreshHeaderView flipImageAnimated:NO];
	[_refreshHeaderView setStatus:RefreshHeaderReleaseToReload];
	[_refreshHeaderView showActivity:NO];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[_controller.tableView setContentInset:UIEdgeInsetsMake( 0.0f, 0.0f, 00.0f, 0.0f )];
	[UIView commitAnimations];
}


- (void)modelDidCancelLoad:(id<TTModel>)model
{
	[_refreshHeaderView flipImageAnimated:NO];
	[_refreshHeaderView setStatus:RefreshHeaderReleaseToReload];
	[_refreshHeaderView showActivity:NO];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[_controller.tableView setContentInset:UIEdgeInsetsMake( 0.0f, 0.0f, 00.0f, 0.0f )];
	[UIView commitAnimations];
}


@end
