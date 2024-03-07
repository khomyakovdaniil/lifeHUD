//
//  AppDelegate.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit
import FirebaseCore
import BackgroundTasks
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                
            } else if let error = error {
                
            }
        })
        NotificationHelper.createNotification(title: "1", body: "1")
        //registerBackgroundTasks()
//        scheduleAppRefresh()
        // Override point for customization after application launch.
        return true
    }
    private func registerBackgroundTasks() {
        
        
      // Declared at the "Permitted background task scheduler identifiers" in info.plist
      let backgroundAppRefreshTaskSchedulerIdentifier = "com.Khomyakov.LifeHUD.refresh"
     

      // Use the identifier which represents your needs
      BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { (task) in
         print("BackgroundAppRefreshTaskScheduler is executed NOW!")
         print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
          self.handleAppRefresh(task)
         task.expirationHandler = {
           task.setTaskCompleted(success: false)
         }

         // Do some data fetching and call setTaskCompleted(success:) asap!
         let isFetchingSuccess = true
         task.setTaskCompleted(success: isFetchingSuccess)
       }
     }
    private func handleAppRefresh(_ task: BGTask) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let appRefreshOperation = NotificationOperation()
        queue.addOperation(appRefreshOperation)

        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        let lastOperation = queue.operations.last
        lastOperation?.completionBlock = {
            task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
        }

        scheduleAppRefresh()
    }
    
    private func scheduleAppRefresh() {
        do {
            let request = BGAppRefreshTaskRequest(identifier: "com.Khomyakov.LifeHUD.refresh")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 10)
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print(error)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
      submitBackgroundTasks()
    }
    
    func submitBackgroundTasks() {
      // Declared at the "Permitted background task scheduler identifiers" in info.plist
      let backgroundAppRefreshTaskSchedulerIdentifier = "com.Khomyakov.LifeHUD.refresh"
      let timeDelay = 10.0

      do {
        let backgroundAppRefreshTaskRequest = BGAppRefreshTaskRequest(identifier: backgroundAppRefreshTaskSchedulerIdentifier)
        backgroundAppRefreshTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: timeDelay)
        try BGTaskScheduler.shared.submit(backgroundAppRefreshTaskRequest)
        print("Submitted task request")
      } catch {
        print("Failed to submit BGTask")
      }
    }


}

