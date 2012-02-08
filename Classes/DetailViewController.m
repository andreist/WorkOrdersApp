//
//  DetailViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "DetailViewController.h"
#import "WorkOrder.h"
#import "EditViewController.h"
#import "SQLAppDelegate.h"


@implementation DetailViewController

@synthesize woObj;


// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView 
{
}
*/

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
    
    if(editing)
    {
        //NSLog(@"Edit mode on");
    }
    else
    {
        
        SQLAppDelegate *appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate modifyWorkOrder:woObj];
         woObj.isDirty = NO;
         woObj.isDetailViewHydrated = YES;
        //[appDelegate release];
        
    }
    
    [tableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	self.title = [NSString stringWithFormat:@"WO %i", woObj.woNumber];
	//tableView.dataSource = self;
	[tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	
	[tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[evController release];
	[selectedIndexPath release];
	[tableView release];
	[woObj release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tblView {
    return 5;
}


- (NSInteger)tableView:(UITableView *)tblView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	switch(indexPath.section) {
		case 0:
			cell.textLabel.text = [NSString stringWithFormat:@"%i", woObj.woNumber];
			break;
		case 1:
			cell.textLabel.text = [NSString stringWithFormat:@"%@", woObj.woDate];
			break;
        case 2:
			cell.textLabel.text = woObj.woDebtor;
			break;
		case 3:
			cell.textLabel.text = woObj.woAddress;
			break;
        case 4:
			cell.textLabel.text = [NSString stringWithFormat:@"%@", woObj.woStartTime];
			break;    
	}
	
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (NSString *)tableView:(UITableView *)tblView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionName = nil;
	
	switch (section) {
		case 0:
			sectionName = [NSString stringWithFormat:@"WO Number"];
			break;
		case 1:
			sectionName = [NSString stringWithFormat:@"Date"];
			break;
        case 2:
			sectionName = [NSString stringWithFormat:@"Debtor Name"];
			break;
		case 3:
			sectionName = [NSString stringWithFormat:@"Address"];
			break;
        case 4:
			sectionName = [NSString stringWithFormat:@"Start Time"];
			break;
}
	
	return sectionName;
}
/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    // Show the disclosure indicator if editing.
    return (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}
*/

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    return (self.editing) ? indexPath : nil;
}

- (void)tableView:(UITableView *)tblView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Keep track of the row selected.
	selectedIndexPath = indexPath;
	
	if(evController == nil)
		evController = [[EditViewController alloc] initWithNibName:@"EditView" bundle:nil];
	
	//Find out which field is being edited.
	switch(indexPath.section)
	{
		case 0:
			evController.keyOfTheFieldToEdit = @"woNumber";
			evController.editValue = [NSString stringWithFormat:@"%i", woObj.woNumber];
			break;
		case 1:
			evController.keyOfTheFieldToEdit = @"woDate";
			evController.editValue = [NSString stringWithFormat:@"Date"];
			break;
        case 2:
			evController.keyOfTheFieldToEdit = @"woDebtor";
			evController.editValue = woObj.woDebtor;
			break;
		case 3:
			evController.keyOfTheFieldToEdit = @"Address";
			evController.editValue = woObj.woAddress;
			break;
        case 4:
			evController.keyOfTheFieldToEdit = @"woStartTime";
			evController.editValue = [NSString stringWithFormat:@"woStartTime"];
			break;
	}
	
	//Object being edited.
	evController.objectToEdit = woObj;
	
	//Push the edit view controller on top of the stack.
	[self.navigationController pushViewController:evController animated:YES];
	
}

@end

