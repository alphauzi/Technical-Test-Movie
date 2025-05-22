//
//  HomeViewController.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = MoviesListViewModel()
    private var bag = DisposeBag()
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(MovieItemCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewModel.fetchMovie()
        viewModel.movieResponse.subscribe(onNext: { [weak self] movies in
            self?.movies.append(contentsOf: movies)
            self?.collectionView.reloadData()
        })
        .disposed(by: bag)
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieItemCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setupItem(data: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 25, height: 290)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
      }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkLoadMore()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.checkLoadMore()
    }
    
    func checkLoadMore() -> Void {
        let indexPaths = self.collectionView.indexPathsForVisibleItems
        guard let lastIndexPath = indexPaths.last else { return }
        if lastIndexPath.section == 0 {
            self.viewModel.loadMore()
        }
    }
}
