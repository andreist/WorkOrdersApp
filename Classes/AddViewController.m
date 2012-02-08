//
//  AddViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "AddViewController.h"
#import "WorkOrder.h"

@implementation AddViewController

@synthesize scrollView;
/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Add Work Order";
 
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											   target:self action:@selector(cancel_Clicked:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
											   target:self action:@selector(save_Clicked:)] autorelease];
	
    NSLog(@"Ajunge viewDidLoad");
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(340, 700);
 }


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//Set the textboxes to empty string.
	txtWoNumber.text = @"10156";
    txtWoDate.text = @"2011-12-20";
    txtWoDebtor.text = @"debtor name 5";
    txtWoAddress.text = @"workorder 5 location address";
    txtWoStartTime.text = @"2011-12-22 00:33:00";
    
    
	
	//Make the wonumber  textfield to be the first responder.
	[txtWoNumber becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) save_Clicked:(id)sender {
	
	SQLAppDelegate *appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//Create a WorkOrder Object.
    
    
	WorkOrder *woObj = [[WorkOrder alloc] initWithPrimaryKey:0];
    NSNumberFormatter *no = [[NSNumberFormatter alloc] init];
    
    NSNumber * myNumber = [no numberFromString:txtWoNumber.text ];
	woObj.woNumber = [myNumber integerValue];
    //[myNumber release];
    [no release];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    woObj.woDate = [dateFormat dateFromString:txtWoDate.text]; 
    [dateFormat release];
    
    woObj.woDebtor = txtWoDebtor.text;
    woObj.woAddress = txtWoAddress.text;
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    woObj.woStartTime = [dateFormat1 dateFromString:txtWoStartTime.text]; 
    [dateFormat1 release];
    
    
    woObj.isDirty = NO;
	woObj.isDetailViewHydrated = YES;
	
	//Add the object
	[appDelegate addWorkOrder:woObj];
	
	//Dismiss the controller.
	[self.navigationController dismissModalViewControllerAnimated:YES];
    
    
}

- (void) cancel_Clicked:(id)sender {
	
	//Dismiss the controller.
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];
	return YES;
}

- (void)dealloc {
	[txtWoNumber release];
	[txtWoDate release];
    [txtWoDebtor release];
	[txtWoAddress release];
    [txtWoStartTime release];

    [super dealloc];
}


@end
