//
//  UICGRoute.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "UICGRoute.h"

@implementation UICGRoute

@synthesize dictionaryRepresentation;
@synthesize numerOfSteps;
@synthesize steps;
@synthesize distance;
@synthesize duration;
@synthesize summaryHtml;
@synthesize startGeocode;
@synthesize endGeocode;
@synthesize endLocation;
@synthesize polylineEndIndex;

+ (UICGRoute *)routeWithDictionaryRepresentation:(NSDictionary *)dictionary {
	UICGRoute *route = [[UICGRoute alloc] initWithDictionaryRepresentation:dictionary];
	return [route autorelease];
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary {
	self = [super init];
	if (self != nil) {
		dictionaryRepresentation = [dictionary retain];
        NSDictionary *k;
        for(NSString *key in [dictionaryRepresentation allKeys]){
            if ([[dictionaryRepresentation objectForKey:key] isKindOfClass:[NSDictionary class]] &&
                [[dictionaryRepresentation objectForKey:key] objectForKey:@"Steps"]) {
                k = [dictionaryRepresentation objectForKey:key];
            }
        }
        NSLog(@"K %@", k);
		NSArray *stepDics = [k objectForKey:@"Steps"];
		numerOfSteps = [stepDics count];
		steps = [[NSMutableArray alloc] initWithCapacity:numerOfSteps];
		for (NSDictionary *stepDic in stepDics) {
			[(NSMutableArray *)steps addObject:[UICGStep stepWithDictionaryRepresentation:stepDic]];
		}
		
		endGeocode = [dictionaryRepresentation objectForKey:@"MJ"];
		startGeocode = [dictionaryRepresentation objectForKey:@"dT"];
		
		distance = [k objectForKey:@"Distance"];
		duration = [k objectForKey:@"Duration"];
		NSDictionary *endLocationDic = [k objectForKey:@"End"];
		NSArray *coordinates = [endLocationDic objectForKey:@"coordinates"];
		CLLocationDegrees longitude = [[coordinates objectAtIndex:0] doubleValue];
		CLLocationDegrees latitude  = [[coordinates objectAtIndex:1] doubleValue];
		endLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
		summaryHtml = [k objectForKey:@"summaryHtml"];
		polylineEndIndex = [[k objectForKey:@"polylineEndIndex"] integerValue];
	}
	return self;
}

- (void)dealloc {
	[dictionaryRepresentation release];
	[steps release];
	[distance release];
	[duration release];
	[summaryHtml release];
	[startGeocode release];
	[endGeocode release];
	[endLocation release];
	[super dealloc];
}

- (UICGStep *)stepAtIndex:(NSInteger)index {
	return [steps objectAtIndex:index];;
}

@end
