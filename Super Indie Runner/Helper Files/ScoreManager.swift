//
// Created by Klaus Fischer on 29.11.20.
//

import Foundation

struct ScoreManager {

    static func getCurrentScore(for levelKey: String) -> [String: Int] {
        if let existingData = UserDefaults.standard.dictionary(forKey: levelKey) as? [String: Int] {
            return existingData
        } else {
            return [GameConstants.StringConstants.scoreScoreKey: 0,
                    GameConstants.StringConstants.scoreStarKey: 0,
                    GameConstants.StringConstants.scoreCoinsKey: 0
            ]
        }
    }

    static func updateScore(for levelKey: String, and score: [String: Int]) {
        UserDefaults.standard.set(score, forKey: levelKey)
        UserDefaults.standard.synchronize()
    }

    static func compare(scores: [[String: Int]], in levelKey: String) {
        var newHighScore = false

        let currentScore = getCurrentScore(for: levelKey)
        var maxScore = currentScore[GameConstants.StringConstants.scoreScoreKey]!
        var maxStars = currentScore[GameConstants.StringConstants.scoreStarKey]!
        var maxCoins = currentScore[GameConstants.StringConstants.scoreCoinsKey]!

        for score in scores {
            if score[GameConstants.StringConstants.scoreScoreKey]! > maxScore {
                maxScore = score[GameConstants.StringConstants.scoreScoreKey]!
                newHighScore = true;
            }
            if score[GameConstants.StringConstants.scoreStarKey]! > maxStars {
                maxStars = score[GameConstants.StringConstants.scoreStarKey]!
                newHighScore = true;
            }
            if score[GameConstants.StringConstants.scoreCoinsKey]! > maxCoins {
                maxCoins = score[GameConstants.StringConstants.scoreCoinsKey]!
                newHighScore = true;
            }
        }

        if !newHighScore {
            return
        }

        let newScore = [GameConstants.StringConstants.scoreScoreKey: maxScore,
                        GameConstants.StringConstants.scoreStarKey: maxStars,
                        GameConstants.StringConstants.scoreCoinsKey: maxCoins
        ]

        updateScore(for: levelKey, and: newScore)
    }

}
