#import "SSSViewController.h"

@interface SSSViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plotTypeButton;

@end

@implementation SSSViewController

@synthesize imageScrollView = _imageScrollView, navigationBar = _navigationBar, locationButton = _locationButton, plotTypeButton = _plotTypeButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.imageScrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rebel"]]];
}

- (void)viewDidUnload
{
    [self setImageScrollView:nil];
    [self setNavigationBar:nil];
    [self setLocationButton:nil];
    [self setPlotTypeButton:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
