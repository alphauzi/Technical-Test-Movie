//
//  DetailViewController.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import UIKit
import RxSwift
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var trailerWebView: WKWebView!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var movie: Movie?
    private var viewModel = DetailViewModel()
    private var bag = DisposeBag()
    
    var trailer: Trailer? = nil
    var trailerKey = ""
    
    var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movie = movie else { return }
        self.setupUI()
        self.configuretableView()
        
        if let movieId = movie.id {
            viewModel.fetchTrailer(id: movieId)
            viewModel.trailerResponse.subscribe(onNext: { [weak self] trailer in
                self?.trailer = trailer.first
                if let key = self?.trailer?.key{
                    self?.trailerKey = key
                }
            })
            .disposed(by: bag)
            
            viewModel.fetchReview(id: movieId)
            viewModel.reviewResponse
                .subscribe(onNext: { [weak self] review in
                    guard let self = self else { return }
                    self.reviews.append(contentsOf: review)
                    self.tableView.reloadData()
                })
                .disposed(by: bag)
        }
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let vc = PopupViewController()
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.navigationController?.present(vc, animated: true)
            })
            .disposed(by: bag)
        
    }
    
    @IBAction func playButton(_ sender: Any) {
        playYouTube(key: trailerKey)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DetailViewController{
    func configuretableView() {
        tableView.register(OverviewTableViewCell.self)
        tableView.register(ReviewTableViewCell.self)
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    func setupUI() {
        guard let movie = movie else { return }
        self.navigationController?.navigationBar.isHidden = true
        self.backButton.layer.cornerRadius = 15
        
        trailerWebView.isHidden = true
        titleLabel.text = movie.title
        popularityLabel.text = String("\(movie.voteCount ?? 0) votes")
        playButton.layer.cornerRadius = 15
        playButton.clipsToBounds = true
        
        let date = dateFormat(date: movie.releaseDate ?? "")
        releaseLabel.text = date
        
        let rating = String(format: "★ %.2f", movie.voteAverage ?? 0)
        ratingLabel.text = "" + rating + "       "
        ratingLabel.textColor = .white
        ratingLabel.backgroundColor = .red
        ratingLabel.layer.cornerRadius = 5
        ratingLabel.layer.masksToBounds = true
        ratingLabel.textAlignment = .center
        
        let imgURL = movie.backdropPath ?? ""
        if let imgURL = URL(string: "https://image.tmdb.org/t/p/w500" + imgURL) {
            self.thumbnailView.sd_setImage(with: imgURL, placeholderImage: UIImage(systemName: "movieclapper.fill"))
        }
    }
    
    func playYouTube(key: String) {
        trailerWebView.isHidden = false
        thumbnailView.isHidden = true
        
        let embedHTML = """
           <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(key)?playsinline=1&autoplay=1" 
               frameborder="0" allowfullscreen></iframe>
           """
        trailerWebView.loadHTMLString(embedHTML, baseURL: nil)
    }
    
    func dateFormat(date: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
        }
        return ""
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.isEmpty ? 2 : reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let movie = movie else { return UITableViewCell() }
            let cell: OverviewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.overviewLabel.text = String("\(movie.overview ?? "")")
            return cell
        }else{
            if !reviews.isEmpty{
                let cell: ReviewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setupItem(data: reviews[indexPath.row-1])
                return cell
            }else{
                let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.configure()
                return cell
            }
        }
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkLoadMore()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.checkLoadMore()
    }
    
    func checkLoadMore() -> Void {
        let indexPaths = self.tableView.indexPathsForVisibleRows
        guard let lastIndexPath = indexPaths?.last, let movieId = movie?.id else { return }
        if lastIndexPath.section == 0 {
            self.viewModel.loadMore(id: movieId)
        }
    }
}
