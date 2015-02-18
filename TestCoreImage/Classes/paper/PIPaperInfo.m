//
//  PIPaperSize.m
//  LeitzIcon
//
//  Created by Leonid 100500 on 4/26/13.
//  Copyright (c) 2013 Esselte. All rights reserved.
//

#import "PIPaperInfo.h"
#ifndef PAPER_INFO_PROJECT
#import "PICommonUtils.h"
#import "PIConstants.h"
#endif

@interface PIPaperInfo ()
#ifndef PAPER_INFO_PROJECT
@property (nonatomic, assign, readwrite) CGFloat	radius;
@property (nonatomic, strong, readwrite) NSString	*paperName; // paper id in fact
@property (nonatomic, assign, readwrite) CGSize		paperSize;
@property (nonatomic, strong, readwrite) NSString	*widthInInches;
@property (nonatomic, strong, readwrite) NSString	*heightInInches;
@property (nonatomic, strong, readwrite) NSString	*widthInMillimeters;
@property (nonatomic, strong, readwrite) NSString	*heightInMillimeters;
@property (nonatomic, strong, readwrite) NSString	*mediaType;
@property (nonatomic, assign, readwrite) UIEdgeInsets	margins;
@property (nonatomic, strong, readwrite) NSString	*leitzID;
#endif
@property (nonatomic, assign, readwrite) BOOL       isRotated;
@end


 NSString *const kPIWidthInInchesKey = @"widthInInches";
static NSString *const kPIHeightInInchesKey = @"heightInInches";
static NSString *const kPIWidthInMillimetersKey = @"widthInMillimeters";
static NSString *const kPIHeightInMillimetersKey = @"heightInMillimeters";
static NSString *const kPIMediaTypeKey = @"mediaType";

@implementation PIPaperInfo {
	BOOL _isContinuous;
	CGFloat	_continuousMinLeader;
	CGFloat _continuousMarginTopBottom;
}

- (id)initWithID:(NSString *)ID andDictionary:(NSDictionary *)plist
{
	self = ID.length ? [self init] : nil;
	if (self) {
		self.paperName = ID;
		self.leitzID = plist[@"id-ipp"];
		self.paperSize = CGSizeMake([plist[@"ppd.width"] floatValue], [plist[@"ppd.height"] floatValue]);
		_margins.left		= [plist[@"ppd.leftMargin"] floatValue];
		_margins.bottom		= [plist[@"ppd.bottomMargin"] floatValue];
		_margins.right		= [plist[@"ppd.rightMargin"] floatValue];
		_margins.top		= [plist[@"ppd.topMargin"] floatValue];
		self.radius			= [plist[@"radius"] floatValue];
        self.widthInInches = plist[kPIWidthInInchesKey];
        self.heightInInches = plist[kPIHeightInInchesKey];
        self.widthInMillimeters = plist[kPIWidthInMillimetersKey];
        self.heightInMillimeters = plist[kPIHeightInMillimetersKey];
        self.mediaType = plist[kPIMediaTypeKey];
		//	this is not the best way to distinct continuous but it works so far
		_isContinuous = [self.paperName hasPrefix:@"Continuous"];
#ifndef PAPER_INFO_PROJECT
		_allCompatibleSKUs = plist[@"CompatibleSKUs"];
#endif
	}
	return self;
}


#define FSTRING(prop) [NSString stringWithFormat:@"%2.3f", prop]
- (NSDictionary *)dictionaryRepresentation {
	NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithCapacity:8];
	plist[@"id"]					= self.paperName;
	plist[@"ppd.width"]				= FSTRING(self.paperSize.width);
	plist[@"ppd.height"]			= FSTRING(self.paperSize.height);
	plist[@"ppd.leftMargin"]		= FSTRING(self.margins.left);
	plist[@"ppd.bottomMargin"]		= FSTRING(self.margins.bottom);
	plist[@"ppd.rightMargin"]		= FSTRING(self.margins.right);
	plist[@"ppd.topMargin"]			= FSTRING(self.margins.top);
	plist[@"radius"]				= FSTRING(self.radius);
	if (self.widthInInches) {
		plist[kPIWidthInInchesKey]		= self.widthInInches;
	}
	if (self.heightInInches) {
		plist[kPIHeightInInchesKey]		= self.heightInInches;
	}
	if (self.widthInMillimeters) {
		plist[kPIWidthInMillimetersKey] = self.widthInMillimeters;
	}
	if (self.heightInMillimeters) {
		plist[kPIHeightInMillimetersKey]= self.heightInMillimeters;
	}
	if (self.mediaType) {
		plist[kPIMediaTypeKey]			= self.mediaType;
	}
	if (self.leitzID) {
		plist[@"id-ipp"] = self.leitzID;
	}
	return plist;
}
#undef FSTRING

#ifdef PAPER_INFO_PROJECT


#else

- (id)copyWithZone:(NSZone *)zone {
    PIPaperInfo *copy = [[self class] new];
	COPY_PROPERTY(paperName);
	COPY_PROPERTY(margins);
	COPY_PROPERTY(paperSize);
	COPY_PROPERTY(radius);
	COPY_PROPERTY(widthInInches);
	COPY_PROPERTY(heightInInches);
	COPY_PROPERTY(widthInMillimeters);
	COPY_PROPERTY(heightInMillimeters);
	COPY_PROPERTY(mediaType);
	COPY_PROPERTY(leitzID);
    return copy;
}

#define STRING_EQUAL(name) (((PIPaperInfo *)object).name == self.name || [((PIPaperInfo *)object).name isEqualToString:self.name])
#define FLOAT_EQUAL(name) (fabsf(((PIPaperInfo *)object).name - self.name) < 0.1)
- (BOOL)isEqual:(id)object {
	return [super isEqual:object] && (STRING_EQUAL(widthInInches) &&
									 STRING_EQUAL(heightInInches) &&
									 STRING_EQUAL(widthInMillimeters) &&
									 STRING_EQUAL(heightInMillimeters) &&
									 STRING_EQUAL(mediaType)
									 );
}
#undef STRING_EQUAL
#undef FLOAT_EQUAL

- (CGSize)bestSizeInsideRect:(CGRect)bounds isLandscape:(BOOL)isLandscape {
	if (bounds.size.width == 0 || bounds.size.height == 0) {
		return CGSizeZero;
	}
	const CGSize paperSize = self.paperSize;
	const CGFloat scaleW = paperSize.width / bounds.size.width;
	const CGFloat scaleH = paperSize.height / bounds.size.height;
	const CGFloat scale = MAX(scaleW, scaleH);
	const CGFloat resultWidth = roundf(paperSize.width / scale);
	const CGFloat resultHeight = roundf(paperSize.height / scale);
	return isLandscape ? CGSizeMake(resultWidth, resultHeight) : CGSizeMake(resultHeight, resultWidth);
}

- (CGFloat)continuousWidth {
	return self.paperSize.width;
}

- (CGFloat)continuousPrintableWidth {
	return self.paperSize.width - self.margins.left - self.margins.right;
}

- (CGFloat)continuousNonprintableWidth {
	return self.margins.left + self.margins.right;
}

- (CGFloat)continuousMaxLength {
	return self.paperSize.height;
}

- (CGFloat)continuousMinLeader {
	return 14.173;//5mm//_continuousMinLeader
}

- (CGFloat)continuousMaxLeader {
	extern const CGFloat kPIContinuousLabelMaximumLeader;
	return kPIContinuousLabelMaximumLeader;//20cm=566.92913385826772
}

- (CGFloat)continuousDefLeader {
	return 22.677;//8mm
}

- (CGFloat)continuousMarginTopBottom {
	return _continuousMarginTopBottom;
}

- (BOOL)isContinuous {
	return _isContinuous;
}

#endif

- (void)normalizeSizesToApp {
	if (self.isContinuous) {
		_continuousMinLeader = MAX(_margins.bottom, _margins.top);
		_continuousMarginTopBottom = MAX(_margins.left, _margins.right);
	}
	else {
		//	rotate paper; width is always bigger than height (kinda landscape)
		if(self.paperSize.width < self.paperSize.height)
		{
			CGSizeSwap(&_paperSize);
			self.isRotated = YES;
		}
		self.radius /= 20.0;	//	TWIPS-->points
	}
}

- (CGRect)printableRect {
	CGRect printableRect = { CGPointMake(self.margins.left, self.margins.top), self.paperSize };
	printableRect.size.width -= self.margins.left + self.margins.right;
	printableRect.size.height -= self.margins.top + self.margins.bottom;
	return printableRect;
}

+ (PIPaperInfo *)placeholderPaperInfo {
	PIPaperInfo *pi = [self new];
	pi.paperSize = CGSizeMake(250, 40);
	pi.paperName = @"placeholder";
	pi.radius = 9;
	return pi;
}

#pragma mark - debug

- (NSString *)description {
	if (self.isContinuous) {
		return [NSString stringWithFormat:@"<%@:%p> '%@' [paper.width, max.length] = [%2.4f, %2.4f]; marg[l:r|t:b]=[%2.4f:%2.4f|%2.4f:%2.4f]; ipp-id:'%@'",
				[self class], self, self.paperName, self.paperSize.width, self.paperSize.height,
				self.margins.left, self.margins.right, self.margins.top, self.margins.bottom,
				self.leitzID?self.leitzID:@"-"];
	}
	return [NSString stringWithFormat:@"<%@:%p> '%@' sz:[%2.4fx%2.4f]; marg[l:r|t:b]:[%2.4f:%2.4f | %2.4f:%2.4f]; r:%2.2f; ipp-id:'%@'",
			[self class], self, self.paperName, self.paperSize.width, self.paperSize.height,
			self.margins.left, self.margins.right, self.margins.top, self.margins.bottom, self.radius,
			self.leitzID?self.leitzID:@"-"];
}

@end


#ifndef PAPER_INFO_PROJECT

#import "PIAppDelegate.h"
#import "PIAppSettings.h"

@implementation PIPaperInfo (UI)

- (NSString *)localizedSizeString {
	PIAppSettings *settings = [PIAppDelegate shared].settings;
	if (settings.useMetricSystem) {
		return self.isContinuous ?
		[NSString stringWithFormat:@"%@ mm", self.heightInMillimeters] :
		[NSString stringWithFormat:@"%@ x %@ mm", self.widthInMillimeters, self.heightInMillimeters];
	}
	return self.isContinuous ?
	[NSString stringWithFormat:@"%@\"", self.heightInInches] :
	[NSString stringWithFormat:@"%@\" x %@\"", self.widthInInches, self.heightInInches];
}

@end

#else

@implementation PIPaperInfo (UI)
- (NSString *)localizedSizeString {
	return self.isContinuous ?
	[NSString stringWithFormat:@"%@ mm", self.heightInMillimeters] :
	[NSString stringWithFormat:@"%@ x %@ mm", self.widthInMillimeters, self.heightInMillimeters];
}
@end

#endif
