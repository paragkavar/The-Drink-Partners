//
//  NewsViewController.m
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "PlistHelper.h"
#import "SBJson.h"
#import "TDPAppDelegate.h"
#import "NewsDetailsViewController.h"
#import "asyncimageview.h"


@implementation NewsViewController

@synthesize imageView,tableView,dicNews,keys;
@synthesize newsDetailsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [tableView release];
    [imageView release];
    [dicNews release];
    [keys release];
    [newsDetailsViewController release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


NSInteger sort4(id a, id b, void* p) {
    return  [b compare:a options:NSNumericSearch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"News";
    
    //Initialize details controller
    NewsDetailsViewController *auxNewsDetails = [[NewsDetailsViewController alloc] initWithNibName:@"NewsDetailsView" bundle:nil];
    self.newsDetailsViewController = auxNewsDetails;
    [auxNewsDetails release];
    
    NSString *newsJson =  [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[PlistHelper readValue:@"News URL"]]];
    if ([newsJson length] > 0) {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *dicNewsAux = [[parser objectWithString:newsJson error:nil] copy]; 
        
        
        NSArray *immutableKeys = [dicNewsAux allKeys];
        
        
        NSMutableArray *newsMutableKeys = [[NSMutableArray alloc] initWithArray:immutableKeys];
        [newsMutableKeys removeObject: @"otheryears"];
        NSArray *newsKeysBuffer = [newsMutableKeys sortedArrayUsingFunction:&sort4 context:nil];
        
        
        self.dicNews = dicNewsAux;
        self.keys = newsKeysBuffer;
        
        [dicNewsAux release];
        [newsMutableKeys release];
        [parser release];
    }
    
    [newsJson release];
    
    // Change the properties of the imageView and tableView (these could be set
	// in interface builder instead).
	//
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 140;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableView = nil;
    self.imageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

//
// numberOfSectionsInTableView:
//
// Return the number of sections for the table.
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//
// tableView:numberOfRowsInSection:
//
// Returns the number of rows in a given section.
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.keys count];
}

//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
    const NSInteger MIDDLE_LABEL_TAG = 1003;
	UILabel *topLabel;
    UILabel *middleLabel;
	UITextView *bottomText;
    
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		//
		// Create the cell.
		//
		cell =
        [[[UITableViewCell alloc]
          initWithFrame:CGRectZero
          reuseIdentifier:CellIdentifier]
         autorelease];
        
        
		UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
		cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
		
		const CGFloat LABEL_HEIGHT = 20;
		UIImage *image = [UIImage imageNamed:@"imageA.png"];
        
		//
		// Create the label for the top row of text
		//
		topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.2 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
                     aTableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:topLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
        middleLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.2 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + 15,
                     aTableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:middleLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		middleLabel.tag = MIDDLE_LABEL_TAG;
		middleLabel.backgroundColor = [UIColor clearColor];
		middleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		middleLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		middleLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] -5];

        
		//
		// Create the label for the botton row of text
		//
		bottomText =
        [[[UITextView alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 1.5 * cell.indentationWidth,
                     0.2 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT + 15,
                     aTableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT+50)]
         autorelease];
		[cell.contentView addSubview:bottomText];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		bottomText.tag = BOTTOM_LABEL_TAG;
		bottomText.backgroundColor = [UIColor clearColor];
		bottomText.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        bottomText.scrollEnabled = NO;
        bottomText.editable = NO;
        bottomText.userInteractionEnabled = NO;
		bottomText.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 4];
        
		//
		// Create a background image view.
		//
		cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
        [[[UIImageView alloc] init] autorelease];
        
	}
    
	else
	{
        //Get label and text by tag
		topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		bottomText = (UITextView *)[cell viewWithTag:BOTTOM_LABEL_TAG];
        middleLabel = (UILabel *)[cell viewWithTag:MIDDLE_LABEL_TAG];
	}
    
    NSDictionary *news = [dicNews objectForKey: [keys objectAtIndex:indexPath.row]];
	
    //Set texts
	topLabel.text = [news objectForKey:@"title"];
	bottomText.text = [news objectForKey:@"content"];
    middleLabel.text = [news objectForKey:@"postedon"];
	
	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [aTableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	
	//
	// Here I set an image based on the row. This is just to have something
	// colorful to show on each row.
	//
    
    NSArray *images = [news objectForKey:@"images"];
    //Get images Dictionary
    NSDictionary *imageDic = [images objectAtIndex:0];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], [imageDic objectForKey:@"thumb"]]; 
    
    //Set frame to load async image
    CGRect frame;
	frame.size.width=65; frame.size.height=80;
	frame.origin.x=10; frame.origin.y=20;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc]
                                   initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	NSURL* url = [[NSURL alloc] initWithString:urlString];
	[asyncImage loadImageFromURL:url];
    
    if ([[cell.contentView subviews] count]>3) {
		//then this must be another image, the old one is still in subviews
        [[[cell.contentView subviews] objectAtIndex:3] removeFromSuperview]; //so remove it (releases it also)
	}
    
	[cell.contentView addSubview:asyncImage];
	
    [url release];
    [urlString release];
	return cell;
} 

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Load news content    
    NSDictionary *news = [dicNews objectForKey: [keys objectAtIndex:indexPath.row]];
    self.newsDetailsViewController.text = [news objectForKey:@"content"]; 
    
    //Load image and title
    NSArray *images = [news objectForKey:@"images"];
    NSDictionary *imageDic = [images objectAtIndex:0];
    self.newsDetailsViewController.imageURL = [NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], [imageDic objectForKey:@"big"]];
    self.newsDetailsViewController.newsTitle = [NSString stringWithFormat:@"%@",[news objectForKey:@"title"]];
    
    //Push view
    TDPAppDelegate *delegate = (TDPAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.navNewsController pushViewController:self.newsDetailsViewController animated:YES];
    [self.newsDetailsViewController resetInfo];
    
     [aTableView deselectRowAtIndexPath:indexPath animated:YES];  
    
}


@end
