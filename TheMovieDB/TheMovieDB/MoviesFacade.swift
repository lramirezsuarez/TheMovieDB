//
//  MoviesFacade.swift
//  TheMovieDB
//
//  Created by Luis Ramirez on 1/30/17.
//  Copyright © 2017 Globant. All rights reserved.
//

import Foundation
import Alamofire

typealias MoviesResponseHandler = (_ moviesResponse : MoviesResponse?, _ error: NSError?) -> Void

struct MoviesFacade {
    
    
    static func RetrieveInfo (mediaType : MediaType, page : Int, completionHandler : @escaping MoviesResponseHandler){
        let pageURL = "&page=\(page)"
        let url = MediaSingleton.sharedInstance.host+"\(mediaType.Route)"+MediaSingleton.sharedInstance.apiKey+pageURL
        Alamofire.request(url).responseJSON{
            response in
            guard let json = response.result.value as? [String: AnyObject]
                else {
                    completionHandler(nil, response.result.error as NSError?)
                    return
            }
            let urlGenre = MediaSingleton.sharedInstance.host+"/genre/movie/list"+MediaSingleton.sharedInstance.apiKey
            Alamofire.request(urlGenre).responseJSON{
                response in
                guard let jsonGenre = response.result.value as? [String: AnyObject]
                    else {
                        completionHandler(nil, response.result.error as NSError?)
                        return
                }
                let movies  = MoviesResponse(json : json, genre : jsonGenre)!
                completionHandler(movies, nil)
            }
        }
    }
}
