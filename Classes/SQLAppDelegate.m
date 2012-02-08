//
//  SQLAppDelegate.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "SQLAppDelegate.h"
#import "RootViewController.h"
#import "WorkOrder.h"

@implementation SQLAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize workOrderArray;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	//Copy database to the user's phone if needed.
	[self copyDatabaseIfNeeded];
	
	//Initialize the workorder array.
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.workOrderArray = tempArray;
	[tempArray release];
	
	//Once the db is copied, get the initial data to display on the screen.
	[WorkOrder getInitialDataToDisplay:[self getDBPath]];
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	
	//Save all the dirty coffee objects and free memory.
	[self.workOrderArray makeObjectsPerformSelector:@selector(saveAllData)];
	
	[WorkOrder finalizeStatements];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    //Save all the dirty coffee objects and free memory.
	[self.workOrderArray makeObjectsPerformSelector:@selector(saveAllData)];
}

- (void)dealloc {
	[workOrderArray release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"workorder.db"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"workorder.db"];
}

- (void) removeWorkOrder:(WorkOrder *)woObj 
{
	
	//Delete it from the database.
	[woObj deleteWorkOrder];
	
	//Remove it from the array.
	[workOrderArray removeObject:woObj];
}

- (void) addWorkOrder:(WorkOrder *)woObj {
	
	//Add it to the database.
	[woObj addWorkOrder];
	
	//Add it to the WorkOrder array.
	[workOrderArray addObject:woObj];
}

- (void) modifyWorkOrder:(WorkOrder *)woObj
{
    //Modify the work order
	[woObj updateWorkOrder];
    //int index = [workOrderArray indexOfObject:woObj];
    //[workOrderArray replaceObjectAtIndex: index withObject:woObj];
}

@end
