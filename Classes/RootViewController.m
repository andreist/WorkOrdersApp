//
//  RootViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "RootViewController.h"
#import "WorkOrder.h"
#import "AddViewController.h"
#import "DetailViewController.h"

@implementation RootViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appDelegate.workOrderArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//Get the object from the array.
	WorkOrder *woObj = [appDelegate.workOrderArray objectAtIndex:indexPath.row];
	
	//Set the workOrder.
	cell.textLabel.text =  [NSString stringWithFormat:@"Work Order %i", woObj.woNumber] ;
	
	//Set the accessory type.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Set up the cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
	
	if(dvController == nil) 
		dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
	
	WorkOrder *woObj = [appDelegate.workOrderArray objectAtIndex:indexPath.row];
	
	//Get the detail view data if it does not exists.
	//We only load the data we initially want and keep on loading as we need.
	[woObj hydrateDetailViewData];
	
	
    dvController.woObj = woObj;

	
	[self.navigationController pushViewController:dvController animated:YES];
	
     
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
											 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
											 target:self action:@selector(add_Clicked:)];
	
	appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	
	self.title = @"Work Orders List";
}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		
		//Get the object to delete from the array.
		WorkOrder *woObj = [appDelegate.workOrderArray objectAtIndex:indexPath.row];
		[appDelegate removeWorkOrder: woObj];
		
		//Delete the object from the table.
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


/*
// Override to support conditional editing of the list
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support rearranging the list
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the list
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	[super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
	
	//Do not let the user add if the app is in edit mode.
	if(editing)
		self.navigationItem.leftBarButtonItem.enabled = NO;
	else
		self.navigationItem.leftBarButtonItem.enabled = YES;
}	

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) add_Clicked:(id)sender {
	
	if(avController == nil)
		avController = [[AddViewController alloc] initWithNibName:@"AddView" bundle:nil];
	
	if(addNavigationController == nil)
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:avController];
	
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
}


- (void)dealloc {
	[dvController release];
	[addNavigationController release];
	[avController release];
    [super dealloc];
}



@end

