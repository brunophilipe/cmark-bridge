//
//  CodeEditorViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/16/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit
import SavannaKit
import SourceEditor

class CodeEditorViewController: UIViewController
{
	var editorView: SyntaxTextView?
	{
		return view as? SyntaxTextView
	}
	
    override func viewDidLoad()
	{
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		editorView?.contentTextView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
		editorView?.theme = LightEditorTheme()
		editorView?.delegate = self
    }
}

extension CodeEditorViewController: SyntaxTextViewDelegate
{
	func didChangeText(_ syntaxTextView: SyntaxTextView)
	{
		
	}
	
	func didChangeSelectedRange(_ syntaxTextView: SyntaxTextView, selectedRange: NSRange)
	{
	
	}
	
	func lexerForSource(_ source: String) -> Lexer
	{
		return MarkdownLexer()
	}
}
