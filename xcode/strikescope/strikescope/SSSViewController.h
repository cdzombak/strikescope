#import <UIKit/UIKit.h>
#import "SSSStrikeStarDataController.h"

@interface SSSViewController : UIViewController

@property (strong, nonatomic) SSSStrikeStarDataController *dataController;
@property (assign, nonatomic) SSSStrikeStarRegion requestedRegion;
@property (assign, nonatomic) SSSStrikeStarPlotType requestedPlotType;

@end
