//
//  P31DragRefreshTableViewDelegate.h
//  Tweets
//
//  Created by Mike on 11/6/09.
//  Copyright 2009 Prime31 Studios. All rights reserved.
//

#import "TTTableViewDelegate.h"
#import "TTModel.h"


@class P31RefreshTableHeaderView;

@interface P31DragRefreshTableViewDelegate : TTTableViewVarHeightDelegate <TTModelDelegate>
{
	P31RefreshTableHeaderView *_refreshHeaderView;
	BOOL _checkForRefresh;
}

@end
