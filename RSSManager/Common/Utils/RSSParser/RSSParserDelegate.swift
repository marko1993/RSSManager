//
//  RSSParser.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import Foundation

class RSSParserDelegate: NSObject, XMLParserDelegate {
    
    var currentElement: String?
    var channel: RSSChannel = RSSChannel()
    var currentRSSItem: RSSItem?
    var itemCount: Int = 0
    var urlString: String?
    var limit: Int = 0

    func parseXML(data: Data, limit: Int = 20, urlString: String) {
        self.limit = limit
        self.urlString = urlString
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    // MARK: - XMLParserDelegate methods

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName

        if elementName == "item" {
            currentRSSItem = RSSItem()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)

        if !trimmedString.isEmpty {
            switch currentElement {
            case "title":
                if currentRSSItem == nil {
                    channel.title = trimmedString
                } else {
                    currentRSSItem?.title = trimmedString
                }
            case "description":
                if currentRSSItem == nil {
                    channel.description = trimmedString
                } else {
                    currentRSSItem?.description = trimmedString
                }
            case "pubDate":
                if currentRSSItem == nil {
                    channel.pubDate = trimmedString
                } else {
                    currentRSSItem?.pubDate = trimmedString
                }
            case "link":
                if currentRSSItem != nil {
                    currentRSSItem?.link = trimmedString
                }
            case "url":
                channel.imageUrl = trimmedString
            case "itunes:image":
                currentRSSItem?.imageUrl = trimmedString
            default:
                break
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item", let item = currentRSSItem {
            channel.items.append(item)
            channel.url = urlString
            itemCount += 1

            if itemCount >= limit {
                parser.abortParsing()
            }
        }
    }
}
