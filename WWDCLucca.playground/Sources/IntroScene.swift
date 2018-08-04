import SpriteKit

//Class responsible for controlling the Start Screen
public class IntroScene: SKScene{

    let headphonesLabel = SKLabelNode(text: "Put your headphones on")
    let startCircle = SKShapeNode(circleOfRadius: 50.0)
    let startLabel = SKLabelNode(text: "START")

    public override func didMove(to view: SKView) {
        self.startCircle.run(SKAction.fadeOut(withDuration: 0))
        self.startLabel.run(SKAction.fadeOut(withDuration: 0))

        self.backgroundColor = UIColor.black
        self.addChild(startLabel)
        self.addChild(startCircle)
        self.addChild(headphonesLabel)

        startLabel.position = CGPoint(x: 250, y: 235)
        startCircle.position = CGPoint(x: 250, y: 250)
        headphonesLabel.position = CGPoint(x: 250, y: 250)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
            self.headphonesLabel.run(SKAction.fadeOut(withDuration: 3))

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                self.startCircle.run(SKAction.fadeIn(withDuration: 3))
                self.startLabel.run(SKAction.fadeIn(withDuration: 3))
            })
        })
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.presentScene(GoToWWDC(size: CGSize(width: 500, height: 500)), transition: SKTransition.fade(withDuration: 2))
    }
}
