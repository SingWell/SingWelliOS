//
//  Platform.swift
//  SeeScoreIOS/SeeScoreMac Sample Apps
//
//  You are free to copy and modify this code as you wish
//  No warranty is made as to the suitability of this for any purpose
//

#if os(iOS)
import UIKit
	public typealias PlatView = UIView
	public typealias PlatFont = UIFont
	public typealias PlatTextField = UITextField
	public typealias PlatTextFieldDelegate = UITextFieldDelegate
#elseif os(OSX)
	import Cocoa
	import AppKit
	import CoreGraphics
	public typealias PlatView = NSView
	public typealias PlatFont = NSFont
	public typealias PlatTextField = NSTextField
	public typealias PlatTextFieldDelegate = NSTextFieldDelegate
#endif


