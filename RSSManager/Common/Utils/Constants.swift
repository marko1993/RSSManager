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
        static let add = "Add"
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
        static let logout = "Log Out"
        static let register = "Register"
        static let dontHavaAccount = "Don't have an account? "
        static let alreadyHaveAccount = "Already have an account? "
        static let feedSearchBarPlaceholder = "Enter RSS url..."
        static let favouritesSearchBarPlaceholder = "Search favourites..."
        static let likedSearchBarPlaceholder = "Search liked..."
        static let feedEmptyMessage = "There are currently no RSS feeds added. To add feed, enter url and press Add."
        static let favouritesEmptyMessage = "There are currently no favourite RSS feeds. To add feed to favourites, press on a star icon."
        static let likedEmptyMessage = "There are currently no liked articles. To add article, press on a like button."
    }
    
    struct Networking {
        
        struct Collections {
            static let users = "users"
            static let RSSFeed = "feeds"
            static let RSSItems = "RSSItems"
        }
        
    }

}
