//
//  ViewController.swift
//  Font Test
//
//  Created by Allen Xavier on 2/2/15.
//  Copyright (c) 2015 Allen Garvey. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var fontCountLabel: NSTextField!
	@IBOutlet weak var filterTextField: NSTextField!
	@IBOutlet weak var fontSelectionPopUp: NSPopUpButton!
	@IBOutlet var outputTextView: NSTextView!
	@IBOutlet var inputTextView: NSTextView!
	@IBOutlet weak var fontSizeTextView: NSTextField!
	
	let DEFAULT_PIXEL_VALUE : Double = 16;
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		outputTextView.richText = true;
		fontCountLabel.stringValue = "";
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	func attributeStringFromString(input: String, fontName: String, fontSize: CGFloat)->NSAttributedString{
		let testString = "\(input)    -(\(fontName))\n\n"
		return NSAttributedString(string: testString, attributes: ([NSFontAttributeName : NSFont(name: fontName, size: fontSize)!] as NSDictionary));
	}
	
	@IBAction func fontSizeStepperAction(sender: AnyObject) {
		let pixelSize : Double = (fontSizeTextView.stringValue as NSString).doubleValue;
		var newPixelSize : Double = sender.integerValue > 0 ? pixelSize + 1 : pixelSize - 1;
		newPixelSize = newPixelSize <= 0 ? 1 : newPixelSize;
		fontSizeTextView.stringValue = "\(newPixelSize)";
		
	}
	@IBAction func displayFonts(sender: AnyObject) {
		//initialize and setup various variables
		//so that the program doesn't have to be reloaded if a new font is added
		let allFonts : [String] = NSFontManager.sharedFontManager().availableFonts as [String];
		let allFontFamilies : [String] = NSFontManager.sharedFontManager().availableFontFamilies as [String];
		
		let inputText : String = inputTextView.string!;
		let pixelSize : CGFloat = CGFloat((fontSizeTextView.stringValue as NSString).doubleValue);
		let cleanedPixelSize : CGFloat = pixelSize >= 0 ? pixelSize : CGFloat(DEFAULT_PIXEL_VALUE);
		let fonts : [String] = fontSelectionPopUp.indexOfSelectedItem == 0 ? allFontFamilies : allFonts;
		outputTextView.string = "";
		var fontNum : Int = 0;
		var totalText : NSMutableAttributedString = NSMutableAttributedString();
		let filterString : String = filterTextField.stringValue;
		
		//get the attributedString based on matches if filter textField is not blank
		totalText.beginEditing();
		if(filterString.rangeOfString("^$|^[\\s\\t\\n]*$", options: .RegularExpressionSearch) != nil){
			for font in fonts{
				totalText.appendAttributedString(attributeStringFromString(inputText, fontName: font, fontSize: cleanedPixelSize));
				fontNum++;
			}
		}
		else{
			let matcher  = AGEDRegExMatcher(regExPattern: filterString);
			for font in fonts{
				if(matcher.isStringMatchCaseInsensitive(font)) {
					totalText.appendAttributedString(attributeStringFromString(inputText, fontName: font, fontSize: cleanedPixelSize));
					fontNum++;
				}
			}
		}
		totalText.endEditing();
		
		//update ui based on findings
		outputTextView.textStorage!.setAttributedString(totalText);
		fontCountLabel.stringValue = "\(fontNum) fonts found";
		fontSizeTextView.stringValue = "\(cleanedPixelSize)";
	}

}

