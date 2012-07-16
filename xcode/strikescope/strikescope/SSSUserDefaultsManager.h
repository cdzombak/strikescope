#import <Foundation/Foundation.h>
#import "SSSStrikeStarDataController.h"

@interface SSSUserDefaultsManager : NSObject

+ (void) setDefaultRegion:(SSSStrikeStarRegion)region;
+ (SSSStrikeStarRegion) defaultRegion;

+ (void) setDefaultPlotType:(SSSStrikeStarPlotType)plotType;
+ (SSSStrikeStarPlotType) defaultPlotType;

@end
