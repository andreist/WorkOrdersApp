//
//  SQLAppDelegate.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class WorkOrder;

@interface SQLAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	//To hold a list of Coffee objects
	NSMutableArray *workOrderArray;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) NSMutableArray *workOrderArray;

- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

- (void) removeWorkOrder:(WorkOrder *)woObj;
- (void) addWorkOrder:(WorkOrder *)woObj;
- (void) modifyWorkOrder:(WorkOrder *)woObj;

@end

