//
//  EditorTheme.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/17/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation
import SavannaKit
import SourceEditor

private let editorFont = UIFont(name: "Menlo-Regular", size: 14.0)!

public class LightEditorTheme: DefaultSourceEditorTheme
{
	public override var lineNumbersStyle: LineNumbersStyle?
	{
		return LineNumbersStyle(font: editorFont.withSize(editorFont.pointSize * 0.85), textColor: #colorLiteral(red: 0.6567457318, green: 0.6567457318, blue: 0.6567457318, alpha: 1))
	}
	
	public override var gutterStyle: GutterStyle
	{
		return GutterStyle(backgroundColor: #colorLiteral(red: 0.9300000072, green: 0.9300000072, blue: 0.9300000072, alpha: 1), minimumWidth: 44.0, gutterMargin: 8.0)
	}
	
	public override var font: Font
	{
		return editorFont
	}
	
	public override var backgroundColor: Color
	{
		return #colorLiteral(red: 0.9499999881, green: 0.9499999881, blue: 0.9499999881, alpha: 1)
	}
	
	public override func globalAttributes() -> [NSAttributedString.Key: Any]
	{
		return [
			.font: font,
			.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		]
	}
	
	public override func color(for markupTokenType: MarkupTokenType) -> Color
	{
		switch markupTokenType
		{
		case .section(1), .section(2), .section(3):
			return #colorLiteral(red: 0.4252530336, green: 0.4425903857, blue: 0.7702992558, alpha: 1)
			
		case .section(4), .section(5), .section(6):
			return #colorLiteral(red: 0.1514524519, green: 0.5434725881, blue: 0.8218073249, alpha: 1)
			
		case .hyperlink:	return #colorLiteral(red: 0.3067158759, green: 0.1546646357, blue: 0.6056337357, alpha: 1)
		case .bullet:		return #colorLiteral(red: 0.5748509765, green: 0.6316215992, blue: 0.631905973, alpha: 1)
		case .strong:		return #colorLiteral(red: 0.8643391728, green: 0.1952385902, blue: 0.1820551753, alpha: 1)
		case .emphasis:		return #colorLiteral(red: 0.7963961959, green: 0.2959932089, blue: 0.08345200866, alpha: 1)
		case .quote:		return #colorLiteral(red: 0.5748509765, green: 0.6316215992, blue: 0.631905973, alpha: 1)
		case .code:			return #colorLiteral(red: 0.001382949296, green: 0.550593555, blue: 0.00190189865, alpha: 1)
		
		default:
			return lineNumbersStyle!.textColor
		}
	}
	
	public override func color(for sourceCodeTokenType: SourceCodeTokenType) -> Color
	{
		switch sourceCodeTokenType
		{
		case .number:		return #colorLiteral(red: 0.4252530336, green: 0.4425903857, blue: 0.7702992558, alpha: 1)
		case .string:		return #colorLiteral(red: 0.7963961959, green: 0.2959932089, blue: 0.08345200866, alpha: 1)
		case .identifier:	return #colorLiteral(red: 0.3067158759, green: 0.1546646357, blue: 0.6056337357, alpha: 1)
		case .keyword:		return #colorLiteral(red: 0.8643391728, green: 0.1952385902, blue: 0.1820551753, alpha: 1)
		case .comment:		return #colorLiteral(red: 0.5748509765, green: 0.6316215992, blue: 0.631905973, alpha: 1)
		
		default:
			return lineNumbersStyle!.textColor
		}
	}
}
