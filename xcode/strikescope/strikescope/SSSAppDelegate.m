#import "SSSAppDelegate.h"

#import "SSSViewController.h"
#import "SSSStrikeStarDataController.h"
#import "SSSUserDefaultsManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface SSSAppDelegate ()

@property (strong, nonatomic) SSSStrikeStarDataController *dataController;

@end

@implementation SSSAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize dataController = _dataController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[SSSViewController alloc] initWithNibName:@"SSSViewController" bundle:nil];
    self.viewController.dataController = [[SSSStrikeStarDataController alloc] init];
    self.viewController.requestedRegion = SSSUserDefaultsManager.defaultRegion;
    self.viewController.requestedPlotType = SSSUserDefaultsManager.defaultPlotType;
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

@end
