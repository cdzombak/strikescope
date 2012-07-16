#import <UIKit/UIKit.h>

@class SSSStrikeStarResult;

typedef enum {
    SSSStrikeStarRegionUS = 0,
    SSSStrikeStarRegionUSNW,
    SSSStrikeStarRegionUSNC,
    SSSStrikeStarRegionUSNE,
    SSSStrikeStarRegionUSSW,
    SSSStrikeStarRegionUSSC,
    SSSStrikeStarRegionUSSE,
    SSSStrikeStarRegionCount
} SSSStrikeStarRegion;

typedef enum {
    SSSStrikeStarPlotType60mPlot = 0,
    SSSStrikeStarPlotType60mDensity,
    SSSStrikeStarPlotType24hSummary,
    SSSStrikeStarPlotTypeCount
} SSSStrikeStarPlotType;

@protocol SSSStrikeStarDelegate

- (void)resultReady:(SSSStrikeStarResult *)result;
- (void)failedRequestForRegion:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType withResponse:(NSHTTPURLResponse *)response error:(NSError *)error;

@end

@interface SSSStrikeStarDataController : NSObject

@property (weak, nonatomic) id<SSSStrikeStarDelegate> delegate;

+ (NSString *)userStringForRegion:(SSSStrikeStarRegion)region;
+ (NSString *)userStringForPlotType:(SSSStrikeStarPlotType)plotType;

- (id)init;

- (void)requestResultForRegion:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType;

- (void)clearInMemoryCache;

@end
