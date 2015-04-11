//
//  ViewController.swift
//  Font Test
//
//  Created by Allen Xavier on 2/2/15.
//  Copyright (c) 2015 Allen Garvey. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var fontSizeComboBox: NSComboBox!
	@IBOutlet weak var searchField: NSSearchField!
	@IBOutlet weak var fontCountLabel: NSTextField!
	@IBOutlet weak var fontSelectionPopUp: NSPopUpButton!
	@IBOutlet var outputTextView: NSTextView!
	@IBOutlet var inputTextView: NSTextView!
	
	let DEFAULT_PIXEL_VALUE : Double = 32;
	let typeScaleStartingValue : Double = 16;
	let typescaler : Typescaler = Typescaler();
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		fontSizeComboBox.stringValue = "\(DEFAULT_PIXEL_VALUE)";
		fontSizeComboBox.addItemsWithObjectValues(typescaler.calculatedScaleArray(typeScaleStartingValue, typeRatioName: "perfect fourth", rangeStart: -2, rangeEnd: 7).map({round($0)}));
		fontSizeComboBox.numberOfVisibleItems = 10;
		outputTextView.richText = true;
		fontCountLabel.stringValue = "";
		
	}
	
	override func viewDidAppear() {
		super.viewDidAppear();
		makeInputTextViewFirstResponder();
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
			
		}
	}
	
	func makeInputTextViewFirstResponder(){
		let window : NSWindow = inputTextView.window!;
		window.makeFirstResponder(window);
		window.makeKeyWindow();
		window.makeFirstResponder(inputTextView);
		inputTextView.selectAll(inputTextView);
	}
	
	func attributeStringFromString(input: String, fontName: String, fontSize: CGFloat)->NSAttributedString{
		let testString = "\(input)    -(\(fontName))\n\n"
		return NSAttributedString(string: testString, attributes: [NSFontAttributeName : NSFont(name: fontName, size: fontSize)!]  as [NSObject : AnyObject]);
	}

	@IBAction func displayFonts(sender: AnyObject) {
		//initialize and setup various variables
		//so that the program doesn't have to be reloaded if a new font is added
		let allFonts : [String] = NSFontManager.sharedFontManager().availableFonts as! [String];
		let allFontFamilies : [String] = NSFontManager.sharedFontManager().availableFontFamilies as! [String];
		let inputText : String = inputTextView.string!;
		let pixelSize : CGFloat = CGFloat((fontSizeComboBox.stringValue as NSString).doubleValue);
		let cleanedPixelSize : CGFloat = pixelSize >= 0 ? pixelSize : CGFloat(DEFAULT_PIXEL_VALUE);
		var fonts : [String] = fontSelectionPopUp.indexOfSelectedItem == 0 ? allFontFamilies : allFonts;
		outputTextView.string = "";
		var fontNum : Int = 0;
		var totalText : NSMutableAttributedString = NSMutableAttributedString();
		let filterString : String = searchField.stringValue;
		
		//check to see if search field is blank before filtering results needlessly
		if(filterString.rangeOfString("^$|^[\\s\\t\\n]*$", options: .RegularExpressionSearch) == nil){
			let matcher  = AGEDRegExMatcher(regExPattern: filterString);
			fonts = fonts.filter({matcher.isStringMatchCaseInsensitive($0)});
		}
		
		totalText.beginEditing();
		for font in fonts{
			totalText.appendAttributedString(attributeStringFromString(inputText, fontName: font, fontSize: cleanedPixelSize));
			fontNum++;
		}
		totalText.endEditing();
		
		//update ui to show results
		dispatch_async(dispatch_get_main_queue()) {
			let outputTextView = self.outputTextView; //swift shows errors if we don't do this
			outputTextView.layoutManager?.replaceTextStorage(NSTextStorage(attributedString: totalText));
		};
		fontCountLabel.stringValue = "\(fontNum) fonts found";
		fontSizeComboBox.stringValue = "\(cleanedPixelSize)";
		
	}
	@IBAction func searchAction(sender: AnyObject) {
		self.displayFonts(sender);
	}
	
}

