//
//  Typescaler.swift
//  Font Check
//
//  Created by Allen Xavier on 2/9/15.
//  Copyright (c) 2015 Allen Garvey. All rights reserved.
//

import Foundation

import Foundation

class Typescaler : NSObject{
	let typeRatios  : [String : Double] = [
		"minor second" : 1.067,
		"major second" : 1.125,
		"minor third" : 1.2,
		"major third" : 1.25,
		"perfect fourth" : 1.333,
		"augmented fourth" : 1.414,
		"perfect fifth" : 1.5,
		"golden ratio" : 1.618
	];
	let typeScaleNames : [String] = ["Minor Second", "Major Second", "Minor Third", "Major Third", "Perfect Fourth", "Augmented Fourth", "Perfect Fifth", "Golden Ratio"]; //because dictionary keys can't be sorted
	let defaultRatio = "perfect fourth";
	let emValue : Double = 1;
	
	
	func calculatedScaleArray(baseValue : Double, typeRatioName : String, rangeStart : Int, rangeEnd : Int)->[Double]{
		let ratio : Double = typeRatios[typeRatioName.lowercaseString] ?? typeRatios[defaultRatio]!;
		return Array(map(rangeStart...rangeEnd) { baseValue * pow(ratio, Double($0)) });
	}
	
	
}