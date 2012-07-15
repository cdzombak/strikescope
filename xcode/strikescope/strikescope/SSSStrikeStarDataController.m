#import "SSSStrikeStarDataController.h"
#import "SSSStrikeStarResult.h"
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"

@interface SSSStrikeStarDataController ()

@property (strong, nonatomic) AFHTTPClient* httpClient;

+ (NSString *)filenameForRegion:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType;
+ (NSString *)refererForRegion:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType;
+ (NSUInteger)refererIdForRegion:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType;

@end

@implementation SSSStrikeStarDataController

@synthesize httpClient = _httpClient;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://strikestarus.com/"]];
    }
    return self;
}

- (void)requestResultForRegion:(SSSStrikeStarRegion)region
                      plotType:(SSSStrikeStarPlotType)plotType
{
    // TODO check cache
    
    NSURL *requestURL = [NSURL URLWithString:[SSSStrikeStarDataController filenameForRegion:region plotType:plotType] relativeToURL:self.httpClient.baseURL];
    
    static NSTimeInterval timeout = 20.0;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeout];
    [request setValue:[SSSStrikeStarDataController refererForRegion:region plotType:plotType] forHTTPHeaderField:@"Referer"];
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:^UIImage *(UIImage *image) {
            // TODO: sharpen image?
            return image;
        } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            if (self.delegate != nil) {
                SSSStrikeStarResult *result;
                result = [[SSSStrikeStarResult alloc] initWithImage:image region:region plotType:plotType dateRetrieved:[NSDate date]];
                
                // TODO cache result
                
                [self.delegate resultReady:result];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            if (self.delegate != nil) {
                [self.delegate failedRequestForRegion:region plotType:plotType withResponse:response error:error];
            }
        }
    ];
    
    [self.httpClient.operationQueue cancelAllOperations];
    
    [self.httpClient enqueueHTTPRequestOperation:operation];
}

- (void)clearInMemoryCache
{
    #warning TODO caching
}

+ (NSString *)filenameForRegion:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType
{
    NSString *prefixString = @"image_gen.aspx?file=";
    
    NSString *regionString;
    NSString *suffixString;
    
    switch(region) {
        case SSSStrikeStarRegionUS:
            regionString = @"strikestar";
            break;
        case SSSStrikeStarRegionUSNC:
            regionString = @"NCUS";
            break;
        case SSSStrikeStarRegionUSNE:
            regionString = @"NEUS";
            break;
        case SSSStrikeStarRegionUSNW:
            regionString = @"NWUS";
            break;
        case SSSStrikeStarRegionUSSC:
            regionString = @"SCUS";
            break;
        case SSSStrikeStarRegionUSSE:
            regionString = @"SEUS";
            break;
        case SSSStrikeStarRegionUSSW:
            regionString = @"SWUS";
            break;
        default:
            NSAssert(0, @"Unknown region encountered");
    }
    
    switch(plotType) {
        case SSSStrikeStarPlotType60mPlot:
            suffixString = @".png";
            break;
        case SSSStrikeStarPlotType60mDensity:
            suffixString = @"DSY1.png";
            break;
        case SSSStrikeStarPlotType24hSummary:
            suffixString = @"24.png";
            break;
        default:
            NSAssert(0, @"Unknown plot type encountered");
    }
    
    return [NSString stringWithFormat:@"%@%@%@", prefixString, regionString, suffixString];
}

+ (NSString *)refererForRegion:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType
{
    return [NSString stringWithFormat:@"http://strikestarus.com/index.aspx?id=%u", [SSSStrikeStarDataController refererIdForRegion:region plotType:plotType]];
}

+ (NSUInteger)refererIdForRegion:(SSSStrikeStarRegion)region plotType:(SSSStrikeStarPlotType)plotType
{
    NSUInteger refererCode = 0;

    switch(region) {
        case SSSStrikeStarRegionUS:
            refererCode = 10;
            break;
        case SSSStrikeStarRegionUSNC:
            refererCode = 30;
            break;
        case SSSStrikeStarRegionUSNE:
            refererCode = 40;
            break;
        case SSSStrikeStarRegionUSNW:
            refererCode = 20;
            break;
        case SSSStrikeStarRegionUSSC:
            refererCode = 60;
            break;
        case SSSStrikeStarRegionUSSE:
            refererCode = 70;
            break;
        case SSSStrikeStarRegionUSSW:
            refererCode = 50;
            break;
        default:
            NSAssert(0, @"Unknown region encountered");
    }
    
    switch (plotType) {
        case SSSStrikeStarPlotType60mPlot:
            refererCode += 0;
            break;
        case SSSStrikeStarPlotType60mDensity:
            refererCode += 2;
            break;
        case SSSStrikeStarPlotType24hSummary:
            refererCode += 4;
            break;
        default:
            NSAssert(0, @"Unknown plot type encountered");
    }
    
    return refererCode;
}

+ (NSString *)userStringForRegion:(SSSStrikeStarRegion)region
{
    #warning TODO 
}

+ (NSString *)userStringForPlotType:(SSSStrikeStarPlotType)plotType
{
    #warning TODO 
}

@end
