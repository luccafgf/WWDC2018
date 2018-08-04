import SpriteKit

//Class responsible for controlling the End Screen
class FinalScene: SKScene{
    let finalLabel = SKLabelNode(text: "That's all folks!")

    override func didMove(to view: SKView) {
        self.addChild(finalLabel)
        self.backgroundColor = UIColor.black
        finalLabel.position = CGPoint(x: 250, y: 250)
        finalLabel.run(SKAction.fadeIn(withDuration: 4))
    }
}
