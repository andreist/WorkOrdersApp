//
//  RootViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class WorkOrder, AddViewController, DetailViewController;

@interface RootViewController : UITableViewController {
	
	SQLAppDelegate *appDelegate;
	AddViewController *avController;
	DetailViewController *dvController;
	UINavigationController *addNavigationController;
}

@end
