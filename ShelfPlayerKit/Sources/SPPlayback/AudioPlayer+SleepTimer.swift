//
//  File.swift
//  
//
//  Created by Rasmus Krämer on 02.02.24.
//

import Foundation
import Defaults

public extension AudioPlayer {
    func sleepTimerDidExpire() {
        playing = false
        setSleepTimer(duration: nil)
        
        if Defaults[.smartRewind] && getItemCurrentTime() < getItemDuration() {
            seek(to: getItemCurrentTime() - 10)
        }
    }
    
    func setSleepTimer(duration: Double?) {
        audioPlayer.volume = 1
        
        pauseAtEndOfChapter = false
        remainingSleepTimerTime = duration
    }
    
    func setSleepTimer(endOfChapter: Bool) {
        pauseAtEndOfChapter = endOfChapter
        remainingSleepTimerTime = nil
    }
}
