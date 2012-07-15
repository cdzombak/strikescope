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
