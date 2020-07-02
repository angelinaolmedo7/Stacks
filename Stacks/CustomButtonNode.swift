//
//  CustomButtonNode.swift
//  Stacks
//
//  Created by Angelina Olmedo on 7/2/20.
//

import Foundation
import SpriteKit

enum ButtonNodeState {
    case Active, Selected, Hidden
}

class CustomButtonNode: SKSpriteNode {
    // variable to control when we want the button enabled or not
    // initialized to true because we want the button be enabled by default
    var isButtonEnabled: Bool = true

    // This is what will run when we tap on the button
    // We initialize it as a simple print statement and we can later reassign it
    var selectedHandler: () -> Void = {print("No Button action is set")}
    
    //stateManager that will manage the different states of the button
    var state: ButtonNodeState = .Active {
        didSet {
            switch state {
                case .Active:
                    // when the button is active we want to enable user interaction and set the alpha to fully visible
                    self.isUserInteractionEnabled =  true
                    self.alpha = 1
                    break
                case .Selected:
                    // when the button is selected we want to make the button slightly transparent
                    self.alpha = 0.7
                    break
                case .Hidden:
                    // when the button is hidden we want disable button interaction and hide and make the alpha fully invisible
                    self.isUserInteractionEnabled =  false
                    self.alpha = 0
                    break
            }
        }
    }

    // required method to use nodes from level editor
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // makes sure whenever me initialize a button it's intractable be default
        self.isUserInteractionEnabled =  true
    }
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isButtonEnabled{
            // change state
            state = .Selected
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isButtonEnabled {
            // run code assigned by other section
            selectedHandler()
            // change state back to active
            state = .Active
        }
    }
}
