//
//  AddViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class WorkOrder;

@interface AddViewController : UIViewController 
{
/*
	IBOutlet UITextField *txtCoffeeName;
	IBOutlet UITextField *txtPrice;
 */
    IBOutlet UITextField *txtWoNumber;
	IBOutlet UITextField *txtWoDate;
    IBOutlet UITextField *txtWoDebtor;
	IBOutlet UITextField *txtWoAddress;
    IBOutlet UITextField *txtWoStartTime;
    
    IBOutlet UIScrollView *scrollView;
	BOOL displayKeyboard;
    CGPoint  offset;
    UITextField *Field;
}

@property (nonatomic, retain) UIScrollView *scrollView;

@end
