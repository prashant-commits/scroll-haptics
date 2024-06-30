//
//  scroll_hapticsApp.swift
//  scroll-haptics
//
//  Created by Prashant Garg on 27/06/24.
//

import SwiftUI
import AppKit

@main
struct scroll_hapticsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var eventHandler: GlobalEventMonitor?
    private var hapticManger: HapticManger?
    private var feedbackPerformer: NSHapticFeedbackPerformer?
    private var deltaX: CGFloat = 0
    private var deltaY: CGFloat = 0
    private var offset: CGFloat = 5
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "chart.line.uptrend.xyaxis.circle", accessibilityDescription: "Chart Line")
            statusButton.action = #selector(togglePopover)
        }
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 300)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView())
        hapticManger = HapticManger()
        feedbackPerformer = NSHapticFeedbackManager.defaultPerformer
        eventHandler = GlobalEventMonitor(mask: .scrollWheel) { (event:NSEvent?) -> Void in
            if event?.phase.rawValue == 0 {return}
            if let scrollDelX = event?.scrollingDeltaX {
                self.deltaX = self.deltaX + scrollDelX
            }
            if let scrollDelY = event?.scrollingDeltaY {
                self.deltaY = self.deltaY + scrollDelY
            }
            if abs(self.deltaX) >= self.offset {
                self.performHaptic()
                self.deltaX = 0
            }
            if abs(self.deltaY) >= self.offset {
                self.performHaptic()
                self.deltaY = 0
            }
        }
        eventHandler?.start()
    }
    
    func performHaptic() {
        let genericPattern = NSHapticFeedbackManager.FeedbackPattern.alignment
        let nowPerformanceTime = NSHapticFeedbackManager.PerformanceTime.now
            
        feedbackPerformer?.perform(genericPattern, performanceTime: nowPerformanceTime)
    }
    
    @objc func togglePopover() {
        if let button = statusItem.button {
            print(popover.isShown)
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
            
        }
    }
}
