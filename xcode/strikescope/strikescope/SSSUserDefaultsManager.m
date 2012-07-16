#import "SSSUserDefaultsManager.h"

#define DEFAULTS [NSUserDefaults standardUserDefaults]

@implementation SSSUserDefaultsManager

+ (SSSStrikeStarPlotType)defaultPlotType
{
    return [DEFAULTS integerForKey:@"defaultPlotType"];
}

+ (void)setDefaultPlotType:(SSSStrikeStarPlotType)plotType
{
    [DEFAULTS setInteger:plotType forKey:@"defaultPlotType"];
}

+ (SSSStrikeStarRegion)defaultRegion
{
    return [DEFAULTS integerForKey:@"defaultRegion"];
}

+ (void)setDefaultRegion:(SSSStrikeStarRegion)region
{
    [DEFAULTS setInteger:region forKey:@"defaultRegion"];
}

@end
