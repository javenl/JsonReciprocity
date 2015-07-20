/*
 * Copyright (c) 2013 Mattes Groeger
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "MGConsoleOutput.h"

@interface MGBenchmarkStepData : NSObject

@property (nonatomic, strong) NSString *stepName;
@property (nonatomic) NSTimeInterval stepTime;
@property (nonatomic) NSUInteger stepCount;

@end

@interface MGConsoleSummaryOutput : MGConsoleOutput
{
	NSMutableArray *_stepData;
	NSTimeInterval _totalStepTime;
}

/**
 * Set this to yes, if you still want to get direct logs for each steps. Usually
 * this is not necessary anymore because you get them later as a sorted list.
 */
@property (nonatomic) BOOL logStepsInstantly;

/**
 * You can define a custom output string for the total time by using the
 * following placeholders:
 *
 * ${sessionName}
 * ${stepTime}
 * ${stepName}
 * ${stepPercent}
 * ${stepNumber}
 *
 * Example:
 * consoleOutput.totalFormat = @"<< BENCHMARK ${stepTime} (${stepPercent}%) ${stepName} >>";
 */
@property (nonatomic, strong) NSString *summaryFormat;

@end