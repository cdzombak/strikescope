#import "SSSViewController.h"
#import "SSSStrikeStarDataController.h"
#import "SSSStrikeStarResult.h"

#import "MBProgressHUD.h"
#import "QuartzCore/CALayer.h"

@interface SSSViewController () <SSSStrikeStarDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plotTypeButton;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic, readonly) UIGestureRecognizer *scrollViewTripleTapRecognizer;

@property (strong, nonatomic, readonly) NSDateFormatter *titleBarDateFormatter;
@property (strong, nonatomic) NSTimer *updateTitleBarTimer;
@property (strong, nonatomic) NSTimer *autoRefreshTimer;

@property (strong, nonatomic) SSSStrikeStarResult *currentResult;

@end

@implementation SSSViewController

@synthesize imageScrollView = _imageScrollView, navigationBar = _navigationBar, locationButton = _locationButton, plotTypeButton = _plotTypeButton;
@synthesize dataController = _dataController, imageView = _imageView, scrollViewTripleTapRecognizer = _scrollViewTripleTapRecognizer;
@synthesize titleBarDateFormatter = _titleBarDateFormatter, updateTitleBarTimer = _updateTitleBarTimer, autoRefreshTimer = _autoRefreshTimer;
@synthesize requestedRegion = _requestedRegion, requestedPlotType = _requestedPlotType, currentResult = _currentResult;

#pragma mark - UIView Lifecycle & Callbacks

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataController.delegate = self;
    self.imageScrollView.delegate = self;

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rebel"]]];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.imageScrollView.frame];
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.imageView.layer.shadowOpacity = 1.0;
    self.imageView.layer.shadowRadius = 10.0;
    self.imageView.clipsToBounds = NO;
    
    [self.imageScrollView addSubview:self.imageView];
    
    [self.imageScrollView addGestureRecognizer:self.scrollViewTripleTapRecognizer];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadButtonTouched:)];
    self.navigationBar.topItem.rightBarButtonItem = refreshButton;
    
    if (self.currentResult != nil) [self displayResult:self.currentResult]; 
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

- (void)viewDidAppear:(BOOL)animated
{
    self.updateTitleBarTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                                target:self
                                                              selector:@selector(updateTitleBar)
                                                              userInfo:nil
                                                               repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.updateTitleBarTimer invalidate];
    self.updateTitleBarTimer = nil;
    
    if (self.autoRefreshTimer != nil) {
        [self.autoRefreshTimer invalidate];
    }
    self.autoRefreshTimer = nil;
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

- (void)tripleTapped:(UIGestureRecognizer *)recognizer
{
    if (recognizer == self.scrollViewTripleTapRecognizer) {
        [self saveCurrentImage];
    }
}

- (void)reloadButtonTouched:(id)sender
{
    [self.dataController clearInMemoryCache];
    [self requestUpdatePlot];
}

- (void)updateTitleBar
{
    if (self.currentResult == nil) return;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)]; // TODO un-hard-code frame
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    
    label.text = [self.titleBarDateFormatter stringFromDate:self.currentResult.dateRetrieved];
    
    NSTimeInterval resultAge = [self.currentResult.dateRetrieved timeIntervalSinceNow];
    if (fabs(resultAge) > (10.0 * 60.0)) {
        // if result age is more than 10 minutes
        label.textColor = [UIColor redColor];
    } else {
        label.textColor = [UIColor whiteColor];
    }
    
    self.navigationBar.topItem.titleView = label;
}

- (void)requestUpdatePlot
{
    [self.dataController requestResultForRegion:self.requestedRegion plotType:self.requestedPlotType];
}

- (void)displayResult:(SSSStrikeStarResult *)result
{
    [self.imageView setImage:result.image];
    [self updateTitleBar];
    
    [self relayoutImage];
    
    if (self.autoRefreshTimer != nil) {
        [self.autoRefreshTimer invalidate];
    }
    self.autoRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:7.0*60.0
                                                             target:self
                                                           selector:@selector(requestUpdatePlot)
                                                           userInfo:nil
                                                            repeats:NO];
}

#pragma mark Layout & Drawing

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

#pragma mark Image Saving

- (void)saveCurrentImage
{
    UIImageWriteToSavedPhotosAlbum(self.currentResult.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(@"Saved!", nil);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
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

    self.currentResult = result;
    if (self.isViewLoaded && self.view.window) [self displayResult:self.currentResult];
}

- (void)failedRequestForRegion:(SSSStrikeStarRegion)region
                      plotType:(SSSStrikeStarPlotType)plotType
                  withResponse:(NSHTTPURLResponse *)response
                         error:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Error", nil)
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                          otherButtonTitles:nil
                          ];
    [alert show];
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

- (NSDateFormatter *)titleBarDateFormatter
{
    if (_titleBarDateFormatter == nil) {
        _titleBarDateFormatter = [[NSDateFormatter alloc] init];
        _titleBarDateFormatter.dateStyle = NSDateFormatterNoStyle;
        _titleBarDateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    return _titleBarDateFormatter;
}

- (UIGestureRecognizer *)scrollViewTripleTapRecognizer
{
    if (_scrollViewTripleTapRecognizer == nil) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapped:)];
        tapRecognizer.numberOfTapsRequired = 3;
        _scrollViewTripleTapRecognizer = tapRecognizer;
    }
    return _scrollViewTripleTapRecognizer;
}

@end
