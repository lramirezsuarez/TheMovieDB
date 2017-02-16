//
//  MovieCollectionViewController.swift
//  TheMovieDB
//
//  Created by Luis Ramirez on 2/9/17.
//  Copyright © 2017 Globant. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCollectionViewController: UIViewController, MediaViewControllerDelegate {
    var movies = [Movie]()
    var page = 1
    var totalPages = 0
    let segueIdentifier = "ShowSegue"
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var listView: MediaCollection!

    override func viewDidLoad() {
        super.viewDidLoad()
        listView.myListDelegate = self
        loadDataToCollection()
        self.listView.refreshControl = refreshControl
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(MovieCollectionViewController.refreshAction(sender:)), for: UIControlEvents.valueChanged)
    }

    func loadDataToCollection() {
        MoviesFacade.RetrieveInfo(mediaType: .upcoming, page: page) {
            (moviesResponse, error) in
            guard let resultMovies = moviesResponse?.movies,
                let totalPages = moviesResponse?.totalPages else {
                    self.displayMessage(title: "Error", message: "\(error!)")
                    return
            }
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.movies.append(contentsOf: resultMovies)
            self.totalPages = totalPages
            self.listView.reloadData()
        }
    }
    
    func refreshAction(sender: UIRefreshControl) {
        self.page = 1
        self.movies.removeAll()
        self.listView.reloadData()
        self.loadDataToCollection()
    }
    
    func displayMessage(title: String, message : String) {
        let refreshAlert = UIAlertController(title: title,
                                             message: message,
                                             preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == segueIdentifier,
                let destination = segue.destination as? MovieDetailViewController,
                let movieIndex = listView.indexPathsForSelectedItems?.first
            {
                destination.detail = movies[movieIndex.item]
            }
        }
    
    func getNumberOfCells() -> Int {
        return movies.count
    }
    
    func setupCell(cell: MovieCell, indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        cell.titleLabel?.text = movie.name
        let filter = RoundedCornersFilter(radius: 10.0)
        cell.posterImage?.af_setImage(withURL: (movie.poster), placeholderImage: #imageLiteral(resourceName: "poster-placeholder"), filter: filter, imageTransition: .flipFromTop(0.4))
        cell.ratingCosmos?.rating = movie.rating
    }
    
    func didSelectCell(cell: MovieCell, indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        newViewController.detail = movies[indexPath.row]
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
