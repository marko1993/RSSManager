//
//  Constants.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

struct K {
    
    struct Strings {
        static let appName = "RSSManager"
        static let ok = "Ok"
        static let rssFeed = "RSS Feed"
        static let favourites = "Favourites"
        static let liked = "Liked"
        static let options = "Options"
        static let name = "Name"
        static let namePlaceholder = "Enter name..."
        static let email = "Email"
        static let emailPlaceholder = "Enter email..."
        static let password = "Password"
        static let passwordPlaceholder = "Enter password..."
        static let login = "Log In"
        static let register = "Register"
    }
    
    struct Networking {
        static let baseUrl = "https://api.github.com/"
        
        struct Endpoints {
            static let fetchReposEndpoint = "search/repositories"
            static let getUserDetailsEndpoint = "users/"
        }
        
        struct Parameters {
            static let queryParam = "q"
            static let sortParam = "sort"
            static let sortValue = "updated"
        }
        
        struct Collections {
            static let users = "users"
            static let RSSFeed = "feeds"
            static let RSSItems = "RSSItems"
        }
        
    }

}
