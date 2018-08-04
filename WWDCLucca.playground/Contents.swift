/*:

 # Going To WWDC  💃🏻 🛫 🇺🇸


 ## The purpose of this interactive Playground is to simulate a visually impaired experience on a normal day! Well, a day not so normal like that 🙃

The idea of ​​simulating a visually impaired experience came naturally to me because I passed my last moments studying and researching about how these people live and interact with the world, especially with Apps 📱


Because of my interest and experience with visually impaired people, I found it worthwhile to simulate what it would be like to go to WWDC being one. The idea is that we can value and give more attention to these people, and that we can also perceive the richness of this human sense so rich that is the hearing.


*Thank you Milena Ferraz and Bruna Oliveira for lending me their beautiful voices so I could make my playground 😊*


Sound effects obtained from [ZapSplat](https://www.zapsplat.com)

 */
import PlaygroundSupport
import SpriteKit

let mapView = SKView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
let WWDCScene = IntroScene(size: CGSize(width: 500, height: 500))
WWDCScene.scaleMode = .aspectFit
WWDCScene.backgroundColor = UIColor.black

mapView.presentScene(WWDCScene)
PlaygroundPage.current.liveView = mapView
