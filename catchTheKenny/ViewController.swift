//
//  ViewController.swift
//  catchTheKenny
//
//  Created by Emre Özkara on 6.09.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var kennyImage: UIImageView!
    
    var score = 0
    var counter = 30
    var timer = Timer()
    var gameIsStarted = false
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        
        let storedHighScore = UserDefaults.standard.integer(forKey: "highScore")
        highScore = storedHighScore
        bestScoreLabel.text = "High Score: \(highScore)"
        
        kennyImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(kennyTapped))
        kennyImage.addGestureRecognizer(gestureRecognizer)
    }

    func startTimer() {
        gameIsStarted = true
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(countDown),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func kennyTapped() {
        if !gameIsStarted {
            startTimer()
        }
        
        score += 1
        scoreLabel.text = "Score: \(score)"
        
        let imageWidth = kennyImage.frame.width
        let imageHeight = kennyImage.frame.height
        
        let safeArea = view.safeAreaLayoutGuide.layoutFrame
        
        let minX = safeArea.minX
        let maxX = safeArea.maxX - imageWidth
        
        let minY = safeArea.minY + 120
        let maxY = safeArea.maxY - imageHeight - 80
        
        if maxX > minX && maxY > minY {
            let randomX = CGFloat.random(in: minX..<maxX)
            let randomY = CGFloat.random(in: minY..<maxY)
            
            kennyImage.frame = CGRect(x: randomX, y: randomY, width: imageWidth, height: imageHeight)
        }
    }
    
    func setupGame() {
        score = 0
        counter = 30
        gameIsStarted = false
        
        scoreLabel.text = "Score: \(score)"
        timeLabel.text = "Time: \(counter)"
        kennyImage.isUserInteractionEnabled = true
    }
    
    @objc func countDown() {
        counter -= 1
        timeLabel.text = "Time: \(counter)"
        
        if counter == 0 {
            timer.invalidate()
            kennyImage.isUserInteractionEnabled = false
            
            if score > highScore {
                highScore = score
                UserDefaults.standard.set(highScore, forKey: "highScore")
                bestScoreLabel.text = "High Score: \(highScore)"
            }
            
            showGameAlert()
        }
    }
    
    func showGameAlert() {
        let alert = UIAlertController(title: "Süre bitti", message: "Skorun: \(score)", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "İptal", style: .cancel) { [weak self] _ in
            self?.setupGame()
        }
        
        let replayButton = UIAlertAction(title: "Tekrar Oyna", style: .default) { [weak self] _ in
            self?.setupGame()
            self?.startTimer()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(replayButton)
        
        present(alert, animated: true, completion: nil)
    }
}
