//
//  BarcodeEAN13.m
//
//  Created by Strokin Alexey on 8/27/13. Assist Eugene Hermann
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import "BarCodeEAN13.h"

////////////////////////////////////////////////////////////////////////////////

enum 
{
   Odd = 0,
   Even = 1
}
typedef Parity;


#define ShiftCopyBoolArray(dst, src, size) \
do\
{\
	memcpy(dst, src, size);\
	dst += size;\
} while (0)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wduplicate-decl-specifier"


static const NSUInteger kBarCodeLength = 12;

static const BOOL const bQuiteZone[] = {0,0,0,0,0,0,0,0,0};

static const BOOL const bLeadTrailer[] = {1,0,1};

static const BOOL const bSeporator[] = {0,1,0,1,0};

static const BOOL const bOddLeft[10][7] = {
	{0,0,0,1,1,0,1}, {0,0,1,1,0,0,1}, {0,0,1,0,0,1,1}, {0,1,1,1,1,0,1}, 
	{0,1,0,0,0,1,1}, {0,1,1,0,0,0,1}, {0,1,0,1,1,1,1}, {0,1,1,1,0,1,1}, 
	{0,1,1,0,1,1,1}, {0,0,0,1,0,1,1}
};

static const BOOL const  bEvenLeft[10][7] = {
	{0,1,0,0,1,1,1}, {0,1,1,0,0,1,1}, {0,0,1,1,0,1,1}, {0,1,0,0,0,0,1}, 
	{0,0,1,1,1,0,1}, {0,1,1,1,0,0,1}, {0,0,0,0,1,0,1}, {0,0,1,0,0,0,1}, 
	{0,0,0,1,0,0,1}, {0,0,1,0,1,1,1}
};

static const BOOL const  bRight[10][7] = {
	{1,1,1,0,0,1,0}, {1,1,0,0,1,1,0}, {1,1,0,1,1,0,0}, {1,0,0,0,0,1,0}, 
	{1,0,1,1,1,0,0}, {1,0,0,1,1,1,0}, {1,0,1,0,0,0,0}, {1,0,0,0,1,0,0}, 
	{1,0,0,1,0,0,0}, {1,1,1,0,1,0,0}
};

static const BOOL const bParity[10][5] = {
	{0,0,0,0,0}, {0,1,0,1,1}, {0,1,1,0,1}, {0,1,1,1,0}, {1,0,0,1,1}, 
	{1,1,0,0,1}, {1,1,1,0,0}, {1,0,1,0,1}, {1,0,1,1,0}, {1,1,0,1,0}
};

#pragma clang diagnostic pop


////////////////////////////////////////////////////////////////////////////////


static BOOL* FillManufactureCode(BOOL *dst, NSInteger *code)
{
//	DLog(@"");
	const NSInteger manufacturePos = 2;
	const NSInteger manufactureLen = 5;
	NSInteger firstDigit = code[0];
	NSInteger pos = manufacturePos;
	for (NSInteger i = 0; i < manufactureLen; i++, pos++)
	{
		NSInteger num = code[pos];
		Parity parity = (bParity[firstDigit][i] == 0) ? Odd : Even;
		BOOL *bin;
		if (parity == Odd)
		{
			bin = (BOOL *)bOddLeft[num];
		}
		else
		{
			bin = (BOOL *)bEvenLeft[num];
		}
		ShiftCopyBoolArray(dst, bin, 7);
	}
	return dst;
}

static BOOL *FillProductCode(BOOL *dst, NSInteger *barCode)
{
	const NSInteger productPos = 7;
	const NSInteger productLen = 5;
	NSInteger codePos = productPos;
	for (NSInteger i = 0; i < productLen; i++, codePos++)
	{
		NSInteger num = barCode[codePos];
		BOOL *bin = (BOOL *)bRight[num];
		ShiftCopyBoolArray(dst, bin, 7);
	}
	return dst;
}

static BOOL *FillCheckSumm(BOOL *dst, NSInteger *barCode)
{
	NSInteger sum = 0;
	for (NSUInteger pos = 0; pos < kBarCodeLength; pos ++)
	{
		NSInteger num = barCode[pos];
		NSInteger factor = ((pos % 2 == 0) ? 1 : 3);
		sum += num * factor;
	}
	NSInteger ost = sum % 10;
	NSInteger result = (10 - ost) % 10;
	BOOL *bin = (BOOL *)bRight[result];
	ShiftCopyBoolArray(dst, bin, 7);
	return dst;
}

static NSInteger* InitializeBarCode(NSString *barCodeString)
{
	NSInteger *barCode = calloc(kBarCodeLength, sizeof(NSInteger));
	size_t barLength = barCodeString.length;
	barLength = MIN(barLength, kBarCodeLength);
	unichar *stringBuf = calloc(barLength, sizeof(unichar));
	NSRange range = {0, barLength};
	[barCodeString getCharacters:stringBuf range:range];
	for (NSUInteger i = 0; i < barLength; i++)
	{
		barCode[i] = stringBuf[i] - 0x30;
		if (barCode[i] < 0 || barCode[i] > 9)
		{
			barCode[i] = 0;
		}
	}
	free(stringBuf);
	return barCode;
}


//////////////////////////////////////////////////////////////////////////////////

void CalculateBarCodeEAN13(NSString *barCodeString, BOOL *buffer)
{
	NSInteger *barCode = InitializeBarCode(barCodeString);
    BOOL *bp = buffer;
	ShiftCopyBoolArray(bp, bQuiteZone, 9);
	ShiftCopyBoolArray(bp, bLeadTrailer, 3);
	NSInteger countryCode = barCode[1];
	ShiftCopyBoolArray(bp, bOddLeft[countryCode], 7);
	bp = FillManufactureCode(bp, barCode);
	ShiftCopyBoolArray(bp, bSeporator, 5);
	bp = FillProductCode(bp, barCode);
    bp = FillCheckSumm(bp, barCode);
	ShiftCopyBoolArray(bp, bLeadTrailer, 3);
	ShiftCopyBoolArray(bp, bQuiteZone, 9);
	
	free(barCode);
}

NSString *GetNewRandomEAN13BarCode(void)
{
    NSString *result = @"";
    NSInteger sum = 0;
    for (NSInteger i = 12; i >= 1; i--)
    {
        NSInteger m = (i % 2) == 1 ? 3 : 1;
        NSInteger value = arc4random() % 10;
        sum += (m*value);
        result = [result stringByAppendingFormat:@"%li", (long)value];
    }
    NSInteger cs = 10 - (sum % 10);
    result = [result stringByAppendingFormat:@"%li", (long)(cs == 10 ? 0 : cs)];
    NSLog(@"Generated barcode: %@", result);
    return result;
}

BOOL isValidBarCode(NSString* barCode)
{
    BOOL valid = NO;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:barCode];
    if ([alphaNums isSupersetOfSet:inStringSet] && barCode.length == 13)
    {
        //      checksum validation
        NSInteger sum = 0;
        for (NSUInteger i = 0; i < 12; i++)
        {
            NSUInteger m = (i % 2) == 1 ? 3 : 1;
            NSUInteger value = [barCode characterAtIndex:i] - 0x30;
            sum += (m*value);
        }
        NSInteger cs = 10 - (sum % 10);
        if (cs == 10) cs = 0;
        valid = (cs == ([barCode characterAtIndex:12] - 0x30));
    }
    return valid;
}
