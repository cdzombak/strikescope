#import "SSSViewController.h"
#import "SSSStrikeStarDataController.h"
#import "SSSStrikeStarResult.h"

#import "QuartzCore/CALayer.h"

@interface SSSViewController () <SSSStrikeStarDelegate, UIScrollViewDelegate>

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
    self.imageScrollView.delegate = self;

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rebel"]]];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.imageScrollView.frame];
    [self.imageScrollView addSubview:self.imageView];

    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.imageView.layer.shadowOpacity = 1.0;
    self.imageView.layer.shadowRadius = 10.0;
    self.imageView.clipsToBounds = NO;
    
    self.requestedPlotType = SSSStrikeStarPlotType60mPlot;
    self.requestedRegion = SSSStrikeStarRegionUS;
    
    [self requestUpdatePlot];
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // TODO dedupe code w/relayoutImage
    
    float scale = MIN( 0.9*(self.imageScrollView.bounds.size.width/self.imageView.image.size.width),
                       0.9*(self.imageScrollView.bounds.size.height/self.imageView.image.size.height));
    
    self.imageScrollView.minimumZoomScale = scale;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.imageScrollView.maximumZoomScale = scale * 1.75;
    } else {
        self.imageScrollView.maximumZoomScale = scale * 3.75;
    }
    
    [self setEdgeInsetsForScale:self.imageScrollView.zoomScale animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)requestUpdatePlot
{
    [self.dataController requestResultForRegion:self.requestedRegion plotType:self.requestedPlotType];
}

- (void)relayoutImage
{
    self.imageView.frame = (CGRect) { {0,0}, self.imageView.image.size };
    self.imageScrollView.contentSize = self.imageView.image.size;
    
    float scale = MIN( 0.9*(self.imageScrollView.bounds.size.width/self.imageView.image.size.width),
                       0.9*(self.imageScrollView.bounds.size.height/self.imageView.image.size.height));
    
    self.imageScrollView.zoomScale = scale;
    self.imageScrollView.minimumZoomScale = scale;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.imageScrollView.maximumZoomScale = scale * 1.75;
    } else {
        self.imageScrollView.maximumZoomScale = scale * 3.75;
    }
    
    [self setEdgeInsetsForScale:scale animated:NO];
}

- (void)setEdgeInsetsForScale:(float)scale animated:(BOOL)animated
{
    CGFloat yInset = self.imageScrollView.bounds.size.height/2 - self.imageView.image.size.height*scale/2;
    CGFloat xInset = self.imageScrollView.bounds.size.width/2 - self.imageView.image.size.width*scale/2;
    
    xInset = MAX(18.0, xInset);
    yInset = MAX(12.0, yInset);
    
    void (^setEdgeInsets)(void) = ^() {
        self.imageScrollView.contentInset = UIEdgeInsetsMake(yInset, xInset, yInset, xInset);
    };
    
    if (animated) {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:setEdgeInsets
                         completion:nil];
    } else {
        setEdgeInsets();
    }
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == self.imageScrollView) {
        return self.imageView;
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (scrollView == self.imageScrollView) {
        [self setEdgeInsetsForScale:scale animated:YES];
    }
}

#pragma mark SSSStrikeStarDelegate methods

- (void)resultReady:(SSSStrikeStarResult *)result
{
    if (result.region != self.requestedRegion || result.plotType != self.requestedPlotType) return;

    [self.imageView setImage:[result.image copy]];
    
    [self relayoutImage];
    
    #warning TODO check result time and update title
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
    [self requestUpdatePlot];
}

- (void)setRequestedRegion:(SSSStrikeStarRegion)requestedRegion
{
    _requestedRegion = requestedRegion;
    [self requestUpdatePlot];
}

@end
