//
//  DetailViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class WorkOrder, EditViewController;

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

	
    IBOutlet UITableView *tableView;
	WorkOrder *woObj;
	NSIndexPath *selectedIndexPath;
	EditViewController *evController;
}

@property (nonatomic, retain) WorkOrder *woObj;

@end