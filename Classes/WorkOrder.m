//
//  WorkOrder.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "WorkOrder.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *detailStmt = nil;
static sqlite3_stmt *updateStmt = nil;

@implementation WorkOrder

@synthesize  woID, woNumber, woDate, woAddress, woStartTime, woDebtor , isDirty, isDetailViewHydrated;

+ (void) getInitialDataToDisplay:(NSString *)dbPath {
	
	SQLAppDelegate *appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql = "SELECT wo_ID, wo_Number, wo_Date, wo_Address, wo_StartTime, wo_Debtor FROM  workorders";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            {
				
				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				WorkOrder *woObj = [[WorkOrder alloc] initWithPrimaryKey:primaryKey];
                woObj.woNumber = sqlite3_column_int(selectstmt, 1);
                
                char *date = (char *) sqlite3_column_text(selectstmt, 2);
                woObj.woDate = (date) ? [NSString stringWithUTF8String:date] : @"";
                
                char *address = (char *) sqlite3_column_text(selectstmt, 3);
                woObj.woAddress = (address) ? [NSString stringWithUTF8String:address] : @"";
                
                char *startTime = (char *) sqlite3_column_text(selectstmt, 4);
                woObj.woStartTime = (startTime) ? [NSString stringWithUTF8String:startTime] : @"";
                
                char *debtor = (char *) sqlite3_column_text(selectstmt, 5);
				woObj.woDebtor = (debtor) ? [NSString stringWithUTF8String:debtor] : @"";

				
				woObj.isDirty = NO;
				
				[appDelegate.workOrderArray addObject:woObj];
				[woObj release];
			}
		}
	}
	else
    {
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
        NSLog(@"SQLITE not ok");
    }
}

+ (void) finalizeStatements {
	
	if (database) sqlite3_close(database);
	if (deleteStmt) sqlite3_finalize(deleteStmt);
	if (addStmt) sqlite3_finalize(addStmt);
	if (detailStmt) sqlite3_finalize(detailStmt);
	if (updateStmt) sqlite3_finalize(updateStmt);
}

- (id) initWithPrimaryKey:(NSInteger) pk 
{
	
	[super init];
	woID = pk;
	
	isDetailViewHydrated = NO;
	
	return self;
}

- (void) deleteWorkOrder {
	
	if(deleteStmt == nil) {
		const char *sql = "delete from workorders where wo_ID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, woID);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}

- (void) addWorkOrder {
	
	if(addStmt == nil) {
		const char *sql = "insert into workorders (wo_Number, wo_Date, wo_Address, wo_StartTime, wo_Debtor) Values(?, ?,?,?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
    
	sqlite3_bind_int(addStmt, 1, woNumber);
    
    NSDateFormatter *dFormat1 = [[NSDateFormatter alloc] init];
    [dFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dString1 = [dFormat1 stringFromDate: woDate];
    sqlite3_bind_text(addStmt, 2, [dString1 UTF8String], -1, SQLITE_TRANSIENT);
    [dFormat1 release];
    //[dString1 release];
    
	sqlite3_bind_text(addStmt, 3, [woAddress UTF8String], -1, SQLITE_TRANSIENT);
    
    NSDateFormatter *dFormat2 = [[NSDateFormatter alloc] init];
    [dFormat2 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dString2 = [dFormat2 stringFromDate:woStartTime];
	sqlite3_bind_text(addStmt, 4, [dString2 UTF8String], -1, SQLITE_TRANSIENT);
    [dFormat2 release];
    //[dString2 release];
    
    sqlite3_bind_text(addStmt, 5, [woDebtor UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		//SQLitce provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		woID = sqlite3_last_insert_rowid(database);
	
	//Reset the add statement.
	sqlite3_reset(addStmt);
     
}
 
- (void) updateWorkOrder
{
	
		if(updateStmt == nil) {
            
			const char *sql = "update WorkOrders Set wo_Number = ?, wo_Date = ?, wo_Address = ?, wo_StartTime = ?, wo_Debtor = ? Where wo_ID = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) 
				NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_int(updateStmt, 1,woNumber); 
        
        NSDateFormatter *dFormat3 = [[NSDateFormatter alloc] init];
        [dFormat3 setDateFormat:@"yyyy-MM-dd"];
        NSString *dString3 = [dFormat3 stringFromDate: woDate];
    if ( [woDate isKindOfClass:[NSDate class]] == YES)
        {
            NSLog(@"woDate is NSDateate");
        }
        else
        {
            NSLog(@"woDate is not NSDateate");
        }
        sqlite3_bind_text(updateStmt, 2, [dString3 UTF8String], -1, SQLITE_TRANSIENT);
        [dFormat3 release];
        //[dString1 release];
        
        sqlite3_bind_text(updateStmt, 3, [woAddress UTF8String], -1, SQLITE_TRANSIENT);
        
        NSDateFormatter *dFormat4 = [[NSDateFormatter alloc] init];
        [dFormat4 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *dString4 = [dFormat4 stringFromDate:woStartTime];
        sqlite3_bind_text(updateStmt, 4, [dString4 UTF8String], -1, SQLITE_TRANSIENT);
        [dFormat4 release];
        //[dString2 release];
        
        sqlite3_bind_text(updateStmt, 5, [woDebtor UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(updateStmt, 6, woID);
        
		if(SQLITE_DONE != sqlite3_step(updateStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(updateStmt);
    
}


- (void) hydrateDetailViewData 
{
	
	//If the detail view is hydrated then do not get it from the database.
	if(isDetailViewHydrated) return;
	
	if(detailStmt == nil) {
		const char *sql = "SELECT wo_ID, wo_Number, wo_Date, wo_Address, wo_StartTime, wo_Debtor FROM  workorders WHERE wo_ID = ? ";
		if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_int(detailStmt, 1, woID);
	
	if(SQLITE_DONE != sqlite3_step(detailStmt)) {
		
		//Get the price in a temporary variable.
		//NSDecimalNumber *priceDN = [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(detailStmt, 0)];
        
        char *debtorCN = (char *) sqlite3_column_text(detailStmt, 5);

        NSString *debtorDN = (debtorCN) ? [NSString stringWithUTF8String:debtorCN] : @"";
		
		//Assign the price. The price value will be copied, since the property is declared with "copy" attribute.
		self.woDebtor = debtorDN;
		
		//Release the temporary variable. Since we created it using alloc, we have own it.
		//[debtorDN release];
	}
	else
		NSAssert1(0, @"Error while getting the price of coffee. '%s'", sqlite3_errmsg(database));
	
	//Reset the detail statement.
	sqlite3_reset(detailStmt);
	
	//Set isDetailViewHydrated as YES, so we do not get it again from the database.
	isDetailViewHydrated = YES;
     
}

- (void) saveAllData 
{
	
	if(isDirty) {
		
		if(updateStmt == nil) {
            
			const char *sql = "update WorkOrders Set wo_Number = ?, wo_Date = ?, wo_Address = ?, wo_StartTime, wo_Debtor Where wo_ID = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) 
				NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_int(addStmt, 1, woNumber);
        
        NSDateFormatter *dFormat1 = [[NSDateFormatter alloc] init];
        [dFormat1 setDateFormat:@"yyyy-MM-dd"];
        NSString *dString1 = [dFormat1 stringFromDate: woDate];
        sqlite3_bind_text(addStmt, 2, [dString1 UTF8String], -1, SQLITE_TRANSIENT);
        [dFormat1 release];
        //[dString1 release];
        
        sqlite3_bind_text(addStmt, 3, [woAddress UTF8String], -1, SQLITE_TRANSIENT);
        
        NSDateFormatter *dFormat2 = [[NSDateFormatter alloc] init];
        [dFormat2 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *dString2 = [dFormat2 stringFromDate:woStartTime];
        sqlite3_bind_text(addStmt, 4, [dString2 UTF8String], -1, SQLITE_TRANSIENT);
        [dFormat2 release];
        //[dString2 release];
        sqlite3_bind_text(addStmt, 5, [woDebtor UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(addStmt, 6, woID);
        
		if(SQLITE_DONE != sqlite3_step(updateStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(updateStmt);
		
		isDirty = NO;
	}
	
	//Reclaim all memory here.
	[woDate release];
	woDate = nil;
	[woStartTime release];
	woStartTime = nil;
    [woAddress release];
    woAddress = nil;
    [woDebtor release];
    woDebtor = nil;
	
	isDetailViewHydrated = NO;
     
}

- (void) setWoNumber:(NSInteger)newValue
{
	
	self.isDirty = YES;
	woNumber = newValue;    
}

- (void) setWoDate:(NSDate *)newVal
{
	
	self.isDirty = YES;
	[woDate release];
	woDate = [newVal copy];
     
}

- (void) setWoAddress:(NSString *) newVal
{
	
	self.isDirty = YES;
	[woAddress release];
	woAddress = [newVal copy];
    
}

- (void) setWoDebtor:(NSString *) newVal
{
	
	self.isDirty = YES;
	[woDebtor release];
	woDebtor = [newVal copy];
    
}

- (void) setWoStartTime:(NSDate *) newVal
{
	
	self.isDirty = YES;
	[woStartTime release];
	woStartTime = [newVal copy];

}

- (void) dealloc {
	
	[woDate release];
	[woStartTime release];
    [woAddress release];
    [woDebtor release];

	[super dealloc];
}

@end
