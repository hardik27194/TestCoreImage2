//
//  PIPaperSize.h
//  LeitzIcon
//
//  Created by Leonid 100500 on 4/26/13.
//  Copyright (c) 2013 Esselte. All rights reserved.
//

@interface PIPaperInfo : NSObject
#ifndef PAPER_INFO_PROJECT
<NSCopying>
#endif

- (id)initWithID:(NSString *)ID andDictionary:(NSDictionary *)plist;
- (NSDictionary *)dictionaryRepresentation;
@property (nonatomic, readonly) BOOL		isContinuous;
#ifdef PAPER_INFO_PROJECT
#else
- (CGSize)bestSizeInsideRect:(CGRect)bounds isLandscape:(BOOL)isLandscape;
//	continuous, shortcuts
@property (nonatomic, readonly) CGFloat		continuousWidth;
@property (nonatomic, readonly) CGFloat		continuousPrintableWidth;
@property (nonatomic, readonly) CGFloat		continuousMaxLength;
@property (nonatomic, readonly) CGFloat		continuousMinLeader;
@property (nonatomic, readonly) CGFloat		continuousMaxLeader;
@property (nonatomic, readonly) CGFloat		continuousDefLeader;
@property (nonatomic, readonly) CGFloat		continuousMarginTopBottom;
@property (nonatomic, readonly) CGFloat		continuousNonprintableWidth;
@property (nonatomic, retain, readonly) NSArray		*allCompatibleSKUs;
#endif

#ifdef PAPER_INFO_PROJECT
#define PROPACCESS readwrite
#else
#define PROPACCESS readonly
#endif

//	human readable props, for UI only
//@property (nonatomic, assign, PROPACCESS)	CGSize		size;
@property (nonatomic, strong, PROPACCESS)	NSString	*widthInInches;
@property (nonatomic, strong, PROPACCESS)	NSString	*heightInInches;
@property (nonatomic, strong, PROPACCESS)	NSString	*widthInMillimeters;
@property (nonatomic, strong, PROPACCESS)	NSString	*heightInMillimeters;
//	L = Label - has adhesive on back; N = Card Stock - Has no adhesive on back
@property (nonatomic, strong, PROPACCESS)	NSString	*mediaType;


@property (nonatomic, assign, PROPACCESS) CGFloat		radius;
//	CUPS drv info
@property (nonatomic, strong, PROPACCESS) NSString		*paperName;//=id
//	(ppd_size->width, ppd_size->length)
@property (nonatomic, assign, PROPACCESS) CGSize		paperSize;
@property (nonatomic, assign, PROPACCESS) UIEdgeInsets	margins;
//	media database name, how printer reports this media an example:'om_standard-address-label_28x88mm'
//	virtual mapping supports it (or will support)
//	an entity in the 'media-col-database' ipp attribute
@property (nonatomic, strong, PROPACCESS) NSString		*leitzID;

//	for continuous paperSize.width is a real paper width, when paperSize.height is the maximum paper length for a single label

#undef PROPACCESS

- (void)normalizeSizesToApp;

- (CGRect)printableRect;

+ (PIPaperInfo *)placeholderPaperInfo;

@end


@interface PIPaperInfo (UI)
//	paper size in inches or in milimeters
- (NSString *)localizedSizeString;
@end
