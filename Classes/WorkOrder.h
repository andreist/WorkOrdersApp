//
//  Coffee.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface WorkOrder : NSObject {

	NSInteger woID;
	NSInteger woNumber;
	NSDate *woDate;
    NSString *woAddress;
    NSDate *woStartTime;
    NSString *woDebtor;
	
	//Intrnal variables to keep track of the state of the object.
	BOOL isDirty;
	BOOL isDetailViewHydrated;
}

@property (nonatomic, readonly) NSInteger woID;
@property (nonatomic, readwrite) NSInteger woNumber;
@property (nonatomic, copy) NSDate *woDate;
@property (nonatomic, copy) NSString *woAddress;
@property (nonatomic, copy) NSDate *woStartTime;
@property (nonatomic, copy) NSString *woDebtor;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) deleteWorkOrder;
- (void) addWorkOrder;
- (void) hydrateDetailViewData;
- (void) saveAllData;
- (void) updateWorkOrder; 

@end
