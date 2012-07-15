#import <UIKit/UIKit.h>
#import "SSSStrikeStarDataController.h"

@interface SSSStrikeStarResult : NSObject

@property (copy, readonly) UIImage *image;
@property (assign, readonly) SSSStrikeStarPlotType plotType;
@property (assign, readonly) SSSStrikeStarRegion region;
@property (copy, readonly) NSDate *dateRetrieved;

- (id)initWithImage:(UIImage *)image region:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType dateRetrieved:(NSDate *)dateRetrieved;

@end
