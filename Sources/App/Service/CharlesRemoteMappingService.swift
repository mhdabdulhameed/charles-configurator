//
//  CharlesRemoteMappingService.swift
//  App
//
//  Created by Mohamed Abdul-Hameed on 26.04.20.
//

import Foundation

final class RemoteMappingService {

    func mapRemote(to newRemote: String) -> String {
        let map = Map(toolEnabled: true, mappings: [
            MapMapping(sourceLocation: Location(prtcl: "https", host: "amboss.com", path: nil),
                       destinationLocation: Location(prtcl: "https", host: "\(newRemote).amboss.de.qa.medicuja.de", path: nil),
                       preserveHostHeader: false,
                       enabled: false),
            
            MapMapping(sourceLocation: Location(prtcl: "https", host: "next-api-de.amboss.com", path: nil),
                       destinationLocation: Location(prtcl: "https", host: "\(newRemote).nextapi.de.qa.medicuja.de", path: nil),
                       preserveHostHeader: false,
                       enabled: false),
            
            MapMapping(sourceLocation: Location(prtcl: "https", host: "mobile-api-de.amboss.com", path: nil),
                       destinationLocation: Location(prtcl: "https", host: "\(newRemote).vesikel.de.qa.medicuja.de", path: nil),
                       preserveHostHeader: false,
                       enabled: false),
            
            MapMapping(sourceLocation: Location(prtcl: "https", host: "next.amboss.com", path: nil),
                       destinationLocation: Location(prtcl: "https", host: "\(newRemote).de.next.medicuja.de", path: nil),
                       preserveHostHeader: false,
                       enabled: false),
            
            MapMapping(sourceLocation: Location(prtcl: nil, host: "amboss.com", path: "/de"),
                       destinationLocation: Location(prtcl: nil, host: "\(newRemote).amboss.de.qa.medicuja.de", path: nil),
                       preserveHostHeader: false,
                       enabled: false),
            
            MapMapping(sourceLocation: Location(prtcl: "https", host: "www.amboss.com", path: "/de/*"),
                       destinationLocation: Location(prtcl: "https", host: "\(newRemote).amboss.de.qa.medicuja.de", path: nil),
                       preserveHostHeader: false,
                       enabled: false),
            
            MapMapping(sourceLocation: Location(prtcl: "https", host: "www.amboss.com", path: nil),
                       destinationLocation: Location(prtcl: "https", host: "\(newRemote).amboss.de.qa.medicuja.de", path: nil),
                       preserveHostHeader: false,
                       enabled: false)
        ])

        let document = XMLDocument()

        document.version = "1.0"
        document.characterEncoding = "UTF-8"

        let charlesPreproccessingInstruction = XMLElement(kind: .processingInstruction)
        charlesPreproccessingInstruction.name = "charles"
        document.addChild(charlesPreproccessingInstruction)

        document.setRootElement(map.asXML(with: "map"))
        
        return document.xmlString
    }
}

private protocol XMLRepresentable {
    func asXML(with root: String) -> XMLElement
}

private struct Location: XMLRepresentable {
    let prtcl: String?
    let host: String
    let path: String?
    
    func asXML(with root: String) -> XMLElement {
        let root =  XMLElement(name: root)
        
        if let prtcl = prtcl {
            root.addChild(XMLElement(name: "protocol", stringValue: prtcl))
        }
        
        root.addChild(XMLElement(name: "host", stringValue: host))
        
        if let path = path {
            root.addChild(XMLElement(name: "path", stringValue: path))
        }
        
        return root
    }
}

private struct MapMapping: XMLRepresentable {
    let sourceLocation: Location
    let destinationLocation: Location
    let preserveHostHeader: Bool
    let enabled: Bool
    
    func asXML(with root: String) -> XMLElement {
        let root =  XMLElement(name: root)
        root.addChild(sourceLocation.asXML(with: "sourceLocation"))
        root.addChild(destinationLocation.asXML(with: "destLocation"))
        root.addChild(XMLElement(name: "preserveHostHeader", stringValue: preserveHostHeader ? "true" : "false"))
        root.addChild(XMLElement(name: "enabled", stringValue: enabled ? "true" : "false"))
        return root
    }
}

private struct Map: XMLRepresentable {
    let toolEnabled: Bool
    let mappings: [MapMapping]
    
    func asXML(with root: String) -> XMLElement {
        let root =  XMLElement(name: root)
        root.addChild(XMLElement(name: "toolEnabled", stringValue: toolEnabled ? "true" : "false"))
        
        let mappingsXMLElement = XMLElement(name: "mappings")
        mappings.forEach { mappingsXMLElement.addChild($0.asXML(with: "mapMapping")) }
        root.addChild(mappingsXMLElement)
        
        return root
    }
}
