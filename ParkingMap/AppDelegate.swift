//
//  AppDelegate.swift
//  ParkingMap
//


import UIKit
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {



    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "969823028265-rujj1dsse14j87d4440qfn9au2ff9btk.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signInSilently()
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            /* Code to show your tab bar controller */
            print("user is signed in")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVC = sb.instantiateViewController(withIdentifier: "ViewController") as? UIViewController {
                window!.rootViewController = tabBarVC
            }
        } else {
            print("user is NOT signed in")
            /* code to show your login VC */
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVC = sb.instantiateViewController(withIdentifier: "GoogleViewController") as UIViewController? {
                window!.rootViewController = tabBarVC
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let email = user.profile.email
            // ...
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVC = sb.instantiateViewController(withIdentifier: "ViewController") as? UIViewController {
                window!.rootViewController = tabBarVC
            }
        } else {
            print("\(error.localizedDescription)")
        }
    }

    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}

