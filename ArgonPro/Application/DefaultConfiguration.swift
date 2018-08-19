//
//  DefaultConfiguration.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 18/8/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation
import ArgonModel
import Yams

class DefaultConfiguration: DynamicYamlDictionary
{
	init()
	{
		let contentsUrl = Bundle.main.url(forResource: "default_config", withExtension: "yml")!
		super.init(yaml: try! Yams.load(yaml: try! String(contentsOf: contentsUrl)) as! [String : Any])
	}
}
