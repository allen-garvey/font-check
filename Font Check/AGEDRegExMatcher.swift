//
//  AGEDRegExMatcher.swift
//  Font Check
//
//  Created by Allen Xavier on 2/5/15.
//  Copyright (c) 2015 Allen Garvey. All rights reserved.
//

import Foundation
import Cocoa

class AGEDRegExMatcher : NSObject{
	//empty string for regExPattern crashes
	private var regExPattern : String = "^$";
	private var regExMatcher : NSRegularExpression = NSRegularExpression(pattern: "^$", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!;
	
	init(regExPattern : String){
		super.init();
		self.setRegExPattern(regExPattern);
	}
	
	func isStringMatchCaseInsensitive(string : String, regExPattern: String)->Bool{
		self.regExPattern = regExPattern;
		return self.isStringMatchCaseInsensitive(string);
	}
	
	func isStringMatchCaseInsensitive(string : String)->Bool{
		if((self.regExMatcher.matchesInString(string, options: nil, range: NSMakeRange(0, count(string))) as NSArray).count > 0){
			return true;
		}
		return false;
	}
	
	func setRegExPattern(regExPattern: String){
		self.regExPattern = regExPattern;
		self.regExMatcher = NSRegularExpression(pattern: self.regExPattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!;
	}
	


}