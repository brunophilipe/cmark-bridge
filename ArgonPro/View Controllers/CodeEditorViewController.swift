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
		editorView?.theme = LightEditorTheme()
		editorView?.delegate = self
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
