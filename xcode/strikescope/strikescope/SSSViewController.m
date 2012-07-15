#import "SSSViewController.h"
#import "SSSStrikeStarDataController.h"
#import "SSSStrikeStarResult.h"

@interface SSSViewController () <SSSStrikeStarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plotTypeButton;

@property (strong, nonatomic) UIImageView *imageView;

@property (assign, nonatomic) SSSStrikeStarRegion requestedRegion;
@property (assign, nonatomic) SSSStrikeStarPlotType requestedPlotType;

@end

@implementation SSSViewController

@synthesize imageScrollView = _imageScrollView, navigationBar = _navigationBar, locationButton = _locationButton, plotTypeButton = _plotTypeButton;
@synthesize dataController = _dataController, imageView = _imageView;
@synthesize requestedRegion = _requestedRegion, requestedPlotType = _requestedPlotType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataController.delegate = self;

    [self.imageScrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rebel"]]];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.imageScrollView.frame];
    [self.imageScrollView addSubview:self.imageView];
    
    self.requestedPlotType = SSSStrikeStarPlotType60mPlot;
    self.requestedRegion = SSSStrikeStarRegionUS;
    
    [self updatePlot];
}

- (void)viewDidUnload
{
    [self setImageScrollView:nil];
    [self setNavigationBar:nil];
    [self setLocationButton:nil];
    [self setPlotTypeButton:nil];
    [self setImageView:nil];
    
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

- (void)updatePlot
{
    [self.dataController requestResultForRegion:self.requestedRegion plotType:self.requestedPlotType];
}

#pragma mark SSSStrikeStarDelegate methods

- (void)resultReady:(SSSStrikeStarResult *)result
{
    if (result.region != self.requestedRegion || result.plotType != self.requestedPlotType) return;

    #warning TODO check result time and update title
    
    #warning TODO sizing, etc:
    // TODO center image in scrollview
    // TODO size image to be twice the size on retina devices
    // TODO max initial size should be scrollview size
    
    [self.imageView setImage:result.image];
    
    self.imageView.frame = (CGRect) { {0,0}, result.image.size };
    self.imageScrollView.contentSize = result.image.size;
}

- (void)failedRequestForRegion:(SSSStrikeStarRegion)region
                      plotType:(SSSStrikeStarPlotType)plotType
                  withResponse:(NSHTTPURLResponse *)response
                         error:(NSError *)error
{
#warning TODO error handling
}

#pragma mark Property Overrides

- (void)setRequestedPlotType:(SSSStrikeStarPlotType)requestedPlotType
{
    _requestedPlotType = requestedPlotType;
    [self updatePlot];
}

- (void)setRequestedRegion:(SSSStrikeStarRegion)requestedRegion
{
    _requestedRegion = requestedRegion;
    [self updatePlot];
}

@end
