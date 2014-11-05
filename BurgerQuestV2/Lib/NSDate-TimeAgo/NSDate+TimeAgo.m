#import "NSDate+TimeAgo.h"

@implementation NSDate (TimeAgo)


-(NSString *)timeAgo {    
    
    // Convert current date with system timezone
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *todayInString = [dateFormat stringFromDate:today];
    
    // Fix timezone
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *now = [dateFormat dateFromString:todayInString];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    NSLog(@"Delta seconds : %f, %f", deltaSeconds, deltaMinutes);
    
    if(deltaSeconds < 5) {
        return @"Just now";
    } else if(deltaSeconds < 60) {
        return [NSString stringWithFormat:@"%d seconds ago", (int)deltaSeconds];
    } else if(deltaSeconds < 120) {
        return @"A minute ago";
    } else if (deltaMinutes < 60) {
        return [NSString stringWithFormat:@"%d minutes ago", (int)deltaMinutes];
    } else if (deltaMinutes < 120) {
        return @"An hour ago";
    } else if (deltaMinutes < (24 * 60)) {
        return [NSString stringWithFormat:@"%d hour(s) ago", (int)floor(deltaMinutes/60)];
    } else if (deltaMinutes < (24 * 60 * 2)) {
        return @"Yesterday";
    } else if (deltaMinutes < (24 * 60 * 7)) {
        return [NSString stringWithFormat:@"%d day(s) ago", (int)floor(deltaMinutes/(60 * 24))];
    } else if (deltaMinutes < (24 * 60 * 14)) {
        return @"Last week";
    } else if (deltaMinutes < (24 * 60 * 31)) {
        return [NSString stringWithFormat:@"%d week(s) ago", (int)floor(deltaMinutes/(60 * 24 * 7))];
    } else if (deltaMinutes < (24 * 60 * 61)) {
        return @"Last month";
    } else if (deltaMinutes < (24 * 60 * 365.25)) {
        return [NSString stringWithFormat:@"%d months ago", (int)floor(deltaMinutes/(60 * 24 * 30))];
    } else if (deltaMinutes >= (24 * 60 * 365.25)) {
        return [NSString stringWithFormat:@"%d year(s) ago", (int)floor(deltaMinutes/(60 * 24 * 30 * 12))];
    
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        return [dateFormatter stringFromDate:now];
    }
    //return [NSString stringWithFormat:@"%d years ago", (int)floor(deltaMinutes/(60 * 24 * 365))];
}

@end
