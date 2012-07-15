#import <UIKit/UIKit.h>

@class SSSStrikeStarResult;

typedef enum {
    SSSStrikeStarRegionUS,
    SSSStrikeStarRegionUSNW,
    SSSStrikeStarRegionUSNC,
    SSSStrikeStarRegionUSNE,
    SSSStrikeStarRegionUSSW,
    SSSStrikeStarRegionUSSC,
    SSSStrikeStarRegionUSSE
} SSSStrikeStarRegion;

typedef enum {
    SSSStrikeStarPlotType60mPlot,
    SSSStrikeStarPlotType60mDensity,
    SSSStrikeStarPlotType24hSummary
} SSSStrikeStarPlotType;

@protocol SSSStrikeStarDelegate

- (void)resultReady:(SSSStrikeStarResult *)result wasLastRequest:(BOOL)wasLastRequest;

@end

@interface SSSStrikeStarDataController : NSObject

+ (NSString *)userStringForRegion:(SSSStrikeStarRegion)region;
+ (NSString *)userStringForPlotType:(SSSStrikeStarPlotType)plotType;

- (void)requestResultForRegion:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType;

@end
