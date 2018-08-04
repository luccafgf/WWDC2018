import SpriteKit

//Enum with possible user directions
public enum Direction{
    case top
    case bottom
}

//Class responsible for controlling the Interaction Screen
public class GoToWWDC: SKScene{

    var mic = SKNode()
    let visual = SKShapeNode(circleOfRadius: 50.0)
    let ballForward = SKShapeNode(circleOfRadius: 1.0)
    let ballBackward = SKShapeNode(circleOfRadius: 1.0)
    let labelForward = SKLabelNode(text: "Forward")
    let labelBackward = SKLabelNode(text: "Backward")

    var isTouched: Bool = false
    var touchLocation = CGPoint()

    let parkSound = SKAudioNode(fileNamed: "park.mp3")
    let urbanSound = SKAudioNode(fileNamed: "urban.mp3")

    let car1 = SKAudioNode(fileNamed: "car1.mp3")
    let car2 = SKAudioNode(fileNamed: "car2.mp3")
    let cars1 = SKAudioNode(fileNamed: "cars1.mp3")
    let cars2 = SKAudioNode(fileNamed: "cars2.mp3")

    var talksArrayBool: [Bool] = [false, false, false, false, false, false]

    override public func didMove(to view: SKView) {

        //Mic Configuration
        mic.position = CGPoint(x: 250, y: 0)
        self.listener = mic

        //Visual Configuration
        visual.position = CGPoint(x: 250, y: 250)
        ballForward.position = CGPoint(x: 250, y: 375)
        ballBackward.position = CGPoint(x: 250, y: 125)
        labelForward.position = CGPoint(x: 250, y: 465)
        labelBackward.position = CGPoint(x: 250, y: 10)
        ballForward.fillColor = UIColor.white
        ballBackward.fillColor = UIColor.white
        self.backgroundColor = UIColor.black

        //Child's
        self.addChild(car1)
        self.addChild(car2)
        self.addChild(cars1)
        self.addChild(cars2)
        self.addChild(visual)
        self.addChild(labelForward)
        self.addChild(labelBackward)
        self.addChild(ballForward)
        self.addChild(ballBackward)

        //Init's
        self.setTrafficSound()
        self.setTalk1Sound()
        self.setParkSound()
        self.setUrbanSound()

    }

    //Function that captures the beginning of the touch screen and sets the touch position for the motion setting
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouched = true
        for touch in touches{
            touchLocation = touch.location(in: self)
        }
    }

    //Function that captures the ending of the touch screen and sets the touch animation
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouched = false
        visual.run(SKAction.move(to: CGPoint(x: 250, y: 250), duration: 1))
    }

    //Function that calls the sound height checks of the main audio nodes and the player's motion function
    override public func update(_ currentTime: TimeInterval) {
        if isTouched{
            setMovement(touchLocation)
            setVisuals(touchLocation)
        }
        self.changeVolumeTraffic()
        self.changeVolumePark()
        self.changeVolumeUrban()
    }

    //Function that check the direction of the player's motion
    func setMovement(_ touchLocation: CGPoint){
        switch touchLocation.y {
        case let x where x > 250:
            movePlayer(.top)
        case let x where x <= 250:
            movePlayer(.bottom)
        default:
            break
        }
    }

    //Function that defines the visual elements and their behaviors
    func setVisuals(_ touchLocation: CGPoint){
        visual.glowWidth = 0.4
        if touchLocation.y > 250{
            visual.run(SKAction.move(to: CGPoint(x: 250, y: 375), duration: 1))
        }else{
            visual.run(SKAction.move(to: CGPoint(x: 250, y: 125), duration: 1))
        }
    }

    //Function that performs player movement
    func movePlayer(_ direction: Direction){
        switch direction {
        case .top:
            self.listener?.position = CGPoint(x: self.mic.position.x, y: self.mic.position.y + 0.5)
            checkPosition(self.mic.position)
        case .bottom:
            self.listener?.position = CGPoint(x: self.mic.position.x, y: self.mic.position.y - 0.5)
            checkPosition(self.mic.position)
        }
    }

    //Function that defines when the audios should be played
    func checkPosition(_ position: CGPoint){
        switch position.y {
        case let x where x > 140 && x < 150:
            if !self.talksArrayBool[1]{
                self.setTalk2Sound()
            }
        case let x where x == 220:
            if !self.talksArrayBool[3]{
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    self.setTalk4Sound()
                })
            }
            self.playTrafficSound()
        case let x where x == 300:
            self.setBikeSound()
        case let x where x > 390 && x < 400:
            if !self.talksArrayBool[5]{
                self.setWelcomeSound()
            }
        case let x where x > 440 && x < 450:
            if !self.talksArrayBool[4]{
                self.setTalk5Sound()
            }
        default:
            break
        }
    }

    //Function that defines audio 1
    func setTalk1Sound(){
        self.talksArrayBool[0] = true
        let talk1 = SKAction.playSoundFileNamed("talk1.mp3", waitForCompletion: true)
        self.run(talk1)
    }

    //Function that defines audio 2
    func setTalk2Sound(){
        self.talksArrayBool[1] = true
        let talk2 = SKAction.playSoundFileNamed("talk2.mp3", waitForCompletion: true)
        self.run(talk2)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            self.setTalk3Sound()
        })
    }

    //Function that defines audio 3
    func setTalk3Sound(){
        self.talksArrayBool[2] = true
        let talk3 = SKAction.playSoundFileNamed("talk3.mp3", waitForCompletion: true)
        self.stopTrafficSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.run(talk3)
            self.setHornSound()
        })
    }

    //Function that defines audio 4
    func setTalk4Sound(){
        self.talksArrayBool[3] = true
        let talk4 = SKAction.playSoundFileNamed("talk4.mp3", waitForCompletion: true)
        self.run(talk4)
    }

    //Function that defines audio 5
    func setTalk5Sound(){
        self.talksArrayBool[4] = true
        let talk5 = SKAction.playSoundFileNamed("talk5.mp3", waitForCompletion: true)
        self.run(talk5)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.view?.presentScene(FinalScene(size: CGSize(width: 500, height: 500)), transition: SKTransition.fade(withDuration: 2))
        })

    }

    //Function that defines audio 6
    func setWelcomeSound(){
        self.talksArrayBool[5] = true
        let welcome = SKAction.playSoundFileNamed("welcome.m4a", waitForCompletion: true)
        self.run(welcome)
    }

    //Function that defines audio 7
    func setHornSound(){
        let horn1 = SKAction.playSoundFileNamed("horn1.mp3", waitForCompletion: true)
        let horn2 = SKAction.playSoundFileNamed("horn2.mp3", waitForCompletion: true)
        let horn3 = SKAction.playSoundFileNamed("horn3.mp3", waitForCompletion: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.run(horn1)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.run(horn2)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.run(horn3)
            self.run(horn1)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
            self.run(horn2)
        })
    }

    //Function that defines audio 8
    func setParkSound(){
        self.addChild(parkSound)
        parkSound.position = CGPoint(x: 240, y: 0)
    }

    //Function that controls the audio 8 height perception
    func changeVolumePark(){
        var finalVolume = 0.0
        let volumeValue = abs(mic.position.y - 0)
        switch volumeValue {
        case let x where x >= 150:
            finalVolume = 0.0
        case let x where x >= 100 && x < 150:
            finalVolume = 0.2
        case let x where x >= 50 && x < 100:
            finalVolume = 0.4
        case let x where x >= 25 && x < 50:
            finalVolume = 0.6
        case let x where x >= 0 && x < 25:
            finalVolume = 0.8
        default:
            finalVolume = 0.0
        }
        let volume = SKAction.changeVolume(to: Float(finalVolume), duration: 1)
        self.parkSound.run(volume)
    }

    //Function that defines audio 9
    func setBikeSound(){
        let bikeSound = SKAction.playSoundFileNamed("bike.mp3", waitForCompletion: true)
        self.run(bikeSound)
    }

    //Function that defines audio 10
    func setUrbanSound(){
        self.addChild(urbanSound)
        urbanSound.position = CGPoint(x: 240, y: 350)
    }

    //Function that controls the audio 10 height perception
    func changeVolumeUrban(){
        var finalVolume = 0.0
        let volumeValue = abs(mic.position.y - 350)
        switch volumeValue {
        case let x where x >= 60:
            finalVolume = 0.0
        case let x where x >= 40 && x < 60:
            finalVolume = 0.2
        case let x where x >= 20 && x < 40:
            finalVolume = 0.4
        case let x where x >= 0 && x < 20:
            finalVolume = 0.6
        default:
            finalVolume = 0.0
        }
        let volume = SKAction.changeVolume(to: Float(finalVolume), duration: 1)
        self.urbanSound.run(volume)
    }

    //Function that defines audio 11
    func setTrafficSound(){

        self.car1.isPositional = true
        self.car2.isPositional = true
        self.cars1.isPositional = true
        self.cars2.isPositional = true

        self.car1.position = CGPoint(x: 0, y: 150)
        self.car2.position = CGPoint(x: 0, y: 175)
        self.cars1.position = CGPoint(x: 0, y: 200)
        self.cars2.position = CGPoint(x: 0, y: 225)

        //Sequence Car 1
        let moveForwardCar1 = SKAction.moveTo(x: 0, duration: 6)
        let moveBackCar1 = SKAction.moveTo(x: 500, duration: 6)
        let sequenceCar1 = SKAction.sequence([moveForwardCar1, moveBackCar1])
        let repeatForeverCar1 = SKAction.repeatForever(sequenceCar1)
        let audioCar1 = SKAction.changeVolume(to: 0.1, duration: 0)
        let groupCar1 = SKAction.group([audioCar1, repeatForeverCar1])

        //Sequence Car 2
        let moveForwardCar2 = SKAction.moveTo(x: 0, duration: 4)
        let moveBackCar2 = SKAction.moveTo(x: 500, duration: 4)
        let sequenceCar2 = SKAction.sequence([moveForwardCar2, moveBackCar2])
        let repeatForeverCar2 = SKAction.repeatForever(sequenceCar2)
        let audioCar2 = SKAction.changeVolume(to: 0.1, duration: 0)
        let groupCar2 = SKAction.group([audioCar2, repeatForeverCar2])

        //Sequence Cars 1
        let moveForwardCars1 = SKAction.moveTo(x: 0, duration: 6)
        let moveBackCars1 = SKAction.moveTo(x: 500, duration: 6)
        let sequenceCars1 = SKAction.sequence([moveForwardCars1, moveBackCars1])
        let repeatForeverCars1 = SKAction.repeatForever(sequenceCars1)
        let audioCars1 = SKAction.changeVolume(to: 0.1, duration: 0)
        let groupCars1 = SKAction.group([audioCars1, repeatForeverCars1])

        //Sequence Cars 2
        let moveForwardCars2 = SKAction.moveTo(x: 0, duration: 4)
        let moveBackCars2 = SKAction.moveTo(x: 500, duration: 4)
        let sequenceCars2 = SKAction.sequence([moveForwardCars2, moveBackCars2])
        let repeatForeverCars2 = SKAction.repeatForever(sequenceCars2)
        let audioCars2 = SKAction.changeVolume(to: 0.1, duration: 0)
        let groupCars2 = SKAction.group([audioCars2, repeatForeverCars2])

        self.car1.run(groupCar1)
        self.car2.run(groupCar2)
        self.cars1.run(groupCars1)
        self.cars2.run(groupCars2)
    }

    //Function that pauses traffic sound (Traffic Light simulation)
    func stopTrafficSound(){
        let stopTraffic = SKAction.pause()
        let transitionVolume = SKAction.changeVolume(to: 0.0, duration: 4)
        let sequence = SKAction.sequence([transitionVolume, stopTraffic])

        self.car1.run(sequence)
        self.car2.run(sequence)
        self.cars1.run(sequence)
        self.cars2.run(sequence)
    }

    //Function that plays traffic sound (Traffic Light simulation)
    func playTrafficSound(){
        let playTraffic = SKAction.play()
        let transitionVolume = SKAction.changeVolume(to: 1.0, duration: 4)
        let sequence = SKAction.sequence([transitionVolume, playTraffic])

        self.car1.run(sequence)
        self.car2.run(sequence)
        self.cars1.run(sequence)
        self.cars2.run(sequence)
    }

    //Function that controls the audio 11 height perception
    func changeVolumeTraffic(){
        var finalVolume = 0.0
        let volumeValue = abs(mic.position.y - 150)
        switch volumeValue {
        case let x where x >= 150:
            finalVolume = 0.0
        case let x where x >= 100 && x < 150:
            finalVolume = 0.2
        case let x where x >= 50 && x < 100:
            finalVolume = 0.4
        case let x where x >= 25 && x < 50:
            finalVolume = 0.6
        case let x where x >= 0 && x < 25:
            finalVolume = 0.8
        default:
            finalVolume = 0.0
        }
        let volume = SKAction.changeVolume(to: Float(finalVolume), duration: 1)
        self.car1.run(volume)
        self.car2.run(volume)
        self.cars1.run(volume)
        self.cars2.run(volume)
    }

}
