#import "SSSStrikeStarResult.h"

@interface SSSStrikeStarResult ()

@property (copy, readwrite) UIImage *image;
@property (assign, readwrite) SSSStrikeStarPlotType plotType;
@property (assign, readwrite) SSSStrikeStarRegion region;
@property (copy, readwrite) NSDate *dateRetrieved;

@end

@implementation SSSStrikeStarResult

@synthesize dateRetrieved = _dateRetrieved, image = _image, region = _region, plotType = _plotType;

- (id)initWithImage:(UIImage *)image
             region:(SSSStrikeStarRegion)region
           plotType:(SSSStrikeStarPlotType)plotType
      dateRetrieved:(NSDate *)dateRetrieved
{
    self = [super init];
    if (self) {
        self.dateRetrieved  = dateRetrieved;
        self.image = image;
        self.plotType = plotType;
        self.region = region;
    }
    return self;
}

@end
