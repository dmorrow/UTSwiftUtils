//
//  Routable.swift
//
//  Created by Daniel Morrow on 11/04/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import UIKit

typealias RoutableParams = Dictionary <AnyHashable, Any>
typealias RoutableOpenCallback = (_ params: RoutableParams) -> Void

protocol Routable {
    var controllerParams:RoutableParams? { get set }
    init(params:RoutableParams?)
}

extension Routable where Self: UIViewController {
    init(params: RoutableParams?) {
        self.init(nibName: nil, bundle: nil)
        self.controllerParams = params
    }
}

struct RouteParams {
    var routeOptions : RouteOptions?
    var openParams : RoutableParams?
    var extraParams : RoutableParams?
    
    // TODO: CHECK THIS... MAYBE ALWAYS NEED DEFAULT PARAMS AVAILABLE?
    var controllerParams : RoutableParams {
        get {
            var controllerParams = RoutableParams()
            if let defaults = self.routeOptions?.defaultParams {
                controllerParams = controllerParams.merge(defaults)
            }
            if let extras = self.extraParams {
                controllerParams = controllerParams.merge(extras)
            }
            if let opens = self.openParams {
                controllerParams = controllerParams.merge(opens)
            }
            return controllerParams
        }
    }
    
    init(routerOptions: RouteOptions, openParams: RoutableParams?, extraParams: RoutableParams?) {
        self.routeOptions = routerOptions
        self.openParams = openParams
        self.extraParams = extraParams
    }
}


enum RouteException : Error {
    case initializerNotFound
    case routeNotFound
    case misformedRoute
}

struct RouteOptions {
    
    var openClass: Routable?
    var callback : RoutableOpenCallback?
    
    init(presentationStyle: UIModalPresentationStyle = UIModalPresentationStyle.none, transitionStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical, defaultParams: RoutableParams? = nil, isRoot: Bool = false, isModal: Bool = false) {
        self.presentationStyle = presentationStyle
        self.transitionStyle = transitionStyle
        self.defaultParams = defaultParams
        self.shouldOpenAsRootViewController = isRoot
        self.isModal = isModal
    }
    
    /**
    The property determining if the mapped `UIViewController` should be opened modally or pushed in the navigation stack.
    */
    var isModal : Bool = false
    
    /**
    The property determining the `UIModalPresentationStyle` assigned to the mapped `UIViewController` instance. This is always assigned, regardless of whether or not `modal` is true.
    */
    var presentationStyle : UIModalPresentationStyle = UIModalPresentationStyle.none
    
    /**
    The property determining the `UIModalTransitionStyle` assigned to the mapped `UIViewController` instance. This is always assigned, regardless of whether or not `modal` is true.
    */
    var transitionStyle : UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
    /**
    Default parameters sent to the `UIViewController`'s initWithRouteParams: method. This is useful if you want to pass some non-`NSString` information. These parameters will be overwritten by any parameters passed in the URL in open:.
    */
    var defaultParams : RoutableParams?
    
    /**
    The property determining if the mapped `UIViewController` instance should be set as the root view controller of the router's `UINavigationController` instance.
    */
    var shouldOpenAsRootViewController : Bool = false
    
}

class Router {
    
    static let shared = Router()
    
    // Map of URL format NSString -> RouteOptions
    // i.e. "users/:id"
    private (set) var  routes = [String : RouteOptions]()
    // Map of final URL NSStrings -> RouteParams
    // i.e. "users/16"
    private (set) var cachedRoutes = [String : RouteParams]()
    
    static let ROUTE_NOT_FOUND_FORMAT : String = "No route found for URL %@"
    
    static let INVALID_CONTROLLER_FORMAT : String = "Your controller class %@ needs to implement either the static method %@ or the instance method %@"
    
    ///-------------------------------
    /// @name Navigation Controller
    ///-------------------------------
    
    /**
    The `UINavigationController` instance which mapped `UIViewController`s will be pushed onto.
    */
    var navigationController : UINavigationController?

    
    /**
    Pop to the last `UIViewController` mapped with the router; this will either dismiss the presented `UIViewController` (i.e. modal) or pop the top view controller in the navigationController. The transition is animated.
    */
    func pop() {
        self.popViewControllerFromRouterAnimated(animated: true)
    }
    
    /**
    Pop to the last `UIViewController` mapped with the router; this will either dismiss the presented `UIViewController` (i.e. modal) or pop the top view  controller in the navigationController.
    @param animated Whether or not the transition is animated;
    */
    func popViewControllerFromRouterAnimated(animated: Bool) {
        if let navController = self.navigationController {
            if navController.presentedViewController != nil {
                navController.dismiss(animated: animated)
            } else {
                let _ = self.navigationController?.popViewController(animated: animated)
            }
        }
    }
    
    /**
    Pop to the last `UIViewController` mapped with the router; this will either dismiss the presented `UIViewController` (i.e. modal) or pop the top view controller in the navigationController.
    @param animated Whether or not the transition is animated;
    @remarks not idiomatic objective-c naming
    */
    func pop(animated: Bool) {
        self.popViewControllerFromRouterAnimated(animated: animated)
    }
    
    
    ///-------------------------------
    /// @name Mapping URLs
    ///-------------------------------
    
    /**
    Map a URL format to an anonymous callback and `RouteOptions` options
    @param format A URL format (i.e. "users/:id" or "logout")
    @param callback The callback to run when the URL is triggered in `open:`
    @param options Configuration for the route
    */
    func map(format: String, options: RouteOptions? = nil, callback: @escaping RoutableOpenCallback) {
        var options: RouteOptions = options ?? RouteOptions()
        options.callback = callback
        self.routes[format] = options
    }
    
    /**
    Map a URL format to an anonymous callback and `RouteOptions` options
    @param format A URL format (i.e. "users/:id" or "logout")
    @param controllerClass The `UIViewController` `Class` which will be instanstiated when the URL is triggered in `open:`
    @param options Configuration for the route, such as modal settings
    */
    func map(format: String, controllerClass: Routable, options: RouteOptions? = nil) {
        var options: RouteOptions = options ?? RouteOptions()
        options.openClass = controllerClass
        self.routes[format] = options
    }
    
    ///-------------------------------
    /// @name Opening URLs
    ///-------------------------------
    
    /**
    A convenience method for opening a URL using `UIApplication` `openURL:`.
    @param url The URL the OS will open (i.e. "http://google.com")
    */
    func open(external url : String) {
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    /**
    Triggers the appropriate functionality for a mapped URL, such as an anonymous function or opening a `UIViewController`
    @param url The URL being opened (i.e. "users/16")
    @param animated Whether or not `UIViewController` transitions are animated.
    @param extraParams more paramters to pass in while opening a `UIViewController`; take priority over route-specific default parameters
    @exception routeNotFound Thrown if url does not have a valid mapping
    @exception NavigationControllerNotProvided Thrown if url opens a `UIViewController` and navigationController has not been assigned
    @exception initializerNotFound Thrown if the mapped `UIViewController` instance does not implement -initWithRouteParams: or +allocWithRouteParams:
    */
    func open(url: String, animated: Bool = true, extraParams: RoutableParams? = nil) {
        
        guard let params = routeParams(for: url, extraParams: extraParams), let options = params.routeOptions else {
            return
        }
        
        if let callback = options.callback {
            callback(params.controllerParams)
            return
        }
        
        guard let navController = navigationController else {
            fatalError("Router#navigationController has not been set to a UINavigationController instance")
        }
        

        guard let controller = controller(for: params) else {
            return
        }
        
        if navController.presentedViewController != nil {
            navController.dismiss(animated: true)
        }
        
        if options.isModal {
            if controller is UINavigationController {
                navController.present(controller, animated: animated)
            } else {
                let wrapperController = UINavigationController(rootViewController: controller)
                wrapperController.modalPresentationStyle = controller.modalPresentationStyle
                wrapperController.modalTransitionStyle = controller.modalTransitionStyle
                navController.present(wrapperController, animated: animated)
            }
        } else if options.shouldOpenAsRootViewController {
            navController.setViewControllers([controller], animated: animated)
        } else {
            navController.pushViewController(controller, animated: animated)
        }
    }
    
    /**
    Get params of a given URL, simply return the params dictionary NOT using a block
    @param url The URL being detected (i.e. "users/16")
    */
    
    func routeParams(for url: String, extraParams: RoutableParams? = nil) -> RouteParams? {
    
        if let cachedRoute = self.cachedRoutes[url], extraParams == nil { //TODO: should we just tack on the extra params and return if cached at all?
            return cachedRoute
        }
        
        if let nsurl = NSURL(string: url), let pathComponents = nsurl.pathComponents {
            var openParams : RouteParams?
            for (routeUrl, routeOptions) in self.routes {
                if let nsurl = NSURL(string: routeUrl), let routeParts = nsurl.pathComponents, let givenParams = self.params(for: pathComponents, routeUrlComponents: routeParts),  routeParts.count == pathComponents.count{
                    openParams = RouteParams(routerOptions: routeOptions, openParams: givenParams, extraParams: extraParams)
                    break
                }
            }
            
            guard let returnParams = openParams else {
                    return nil
            }
            
            self.cachedRoutes[url] = returnParams
            return returnParams
        }
        return nil
    }
    
    func params(for urlComponents: [String], routeUrlComponents: [String]) -> RoutableParams? {
        var params = RoutableParams()
        for (idx, routeComponent) in routeUrlComponents.enumerated() {
            let givenComponent = urlComponents[idx]
            if routeComponent.hasPrefix(":") {
                let colIndex = routeComponent.index(routeComponent.startIndex, offsetBy:1)
                let key : String = routeComponent.substring(from:colIndex)
                params[key] = givenComponent
            } else if routeComponent != givenComponent {
                return nil
            }
        }
        return params
    }
    
    func createViewController(with openClass: Routable, params: RoutableParams?) -> UIViewController? {
        guard let viewController = UIApplication.deviceSpecificClass(baseClass: openClass) as? Routable.Type else {
            return nil
        }
        return viewController.init(params:params) as? UIViewController
    }
    
    func controller(for params: RouteParams) -> UIViewController? {
        guard let routeOptions = params.routeOptions, let openClass = routeOptions.openClass, let controller = createViewController(with: openClass, params: params.controllerParams) else {
            return nil
        }
        
        controller.modalTransitionStyle = routeOptions.transitionStyle
        controller.modalPresentationStyle = routeOptions.presentationStyle
        return controller

    }
}