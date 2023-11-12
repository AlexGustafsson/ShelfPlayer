//
//  AudioPlayer+Notifications.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 10.10.23.
//

import Foundation

extension AudioPlayer {
    static let playPauseNotification = NSNotification.Name("io.rfk.audiobooks.playPause")
    static let startStopNotification = NSNotification.Name("io.rfk.audiobooks.startStop")
    static let currentTimeChangedNotification = NSNotification.Name("io.rfk.audiobooks.currentTime.changed")
    static let playbackRateChanged = NSNotification.Name("io.rfk.audiobooks.rate.changed")
    static let sleepTimerChanged = NSNotification.Name("io.rfk.audiobooks.sleeptimer.changed")
}
