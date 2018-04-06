//
//  ViewController.swift
//  Algorythma
//
//  Created by Amit Mishra on 25/03/18.
//  Copyright © 2018 Amit Mishra. All rights reserved.
//

import UIKit
import ModernSearchBar
import ReactorKit
import RxCocoa
import RxSwift
import Moya
class ViewController: RxBaseVC,ModernSearchBarDelegate,StoryboardView {

    @IBOutlet weak var modernSearchBar: ModernSearchBar!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.reactor = SearchReactor()
        self.configureSearchBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    func bind(reactor: SearchReactor) {
        // Action
        reactor.state.map { $0.repos }
            .subscribe(onNext:{[weak self] repos in
                if(!reactor.currentState.isLoading!){
                if repos.count > 0 {
                    let searchPrams = MovieListParam()
                    searchPrams.movies = repos
                    ActionManager.performAction (redirectionType: RedirectionTypes.Search,actionParams:searchPrams , sourceController: self)
                } else
                {
                    let alertController = UIAlertController(title: "No Resut Fount ", message: "Please Search With Other Movies Title", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { action in
                        print(action)
                    }
                    alertController.addAction(cancelAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
                }
                
            })
            .disposed(by: disposeBag)

        button.rx.controlEvent(.touchUpInside)
            .map { [weak self] modernSearchBar in Reactor.Action.showMovieFromSearch(self?.modernSearchBar.text)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

    }
    private func searchMovies(searhText: String = "Batman") -> Void {
        //Code Smell Should ideally create it as state also but used third party search bar so putting it here
        
// Like to create Oe state For this as well But using a third part searchBar Limits that as it dont expose the view with in
       // has I used the default uisearchBar  It would Be better Sorry For that
            NetworkAdapterSigned.request(target: .searchMovie(searchText: searhText) , success: {
                (response) in
                let myResponse:Observable<MovieSearchModel> =   response.map(to: MovieSearchModel.self)
                let movies =  myResponse.map{
                    moviesDetail -> [MoviesModel] in
                    moviesDetail.movies
                }
                
                movies.subscribe { event in
                    switch event {
                    case .next(let repos):
                        let searchPrams = MovieListParam()
                        searchPrams.movies = repos
                        ActionManager.performAction (redirectionType: RedirectionTypes.Search,actionParams:searchPrams , sourceController: self)
                        
                        
                        break
                    case .error( _):
                        let searchPrams = MovieListParam()
                        searchPrams.movies = [MoviesModel]()
                        ActionManager.performAction (redirectionType: RedirectionTypes.Search,actionParams:searchPrams , sourceController: self)                    case .completed:
                        print("done")
                    }
                    
                    }.dispose()
                
            }, error: { (error) in
                //emptysearch
                //reject(resultError)
                
                
            },
               failure: { (error) in
                // emptysearch
                
                
            })
        
    }
    
    ///Called if you use String suggestion list
    func onClickItemSuggestionsView(item: String) {
       self.searchMovies(searhText: item)

    }
    
    ///Called if you use Custom Item suggestion list
    func onClickItemWithUrlSuggestionsView(item: ModernSearchBarModel) {
        print("User touched this item: "+item.title+" with this url: "+item.url.description)
    }
    
    ///Called when user touched shadowView
    func onClickShadowView(shadowView: UIView) {
        print("User touched shadowView")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.configureSearchBar()
    }
    
  
    
    private func configureSearchBar(){
        
        ///Create array of string
        let suggestionList : [RecentlySearch] = DBHelper.fetchEntity("RecentlySearch", inContext: self.reactor!.fetcher.dataStack.mainContext) as! [RecentlySearch]
        let sgstTextArray :[String] = suggestionList.map{$0.searchText!}
        self.modernSearchBar.delegateModernSearchBar = self
        self.modernSearchBar.setDatas(datas: sgstTextArray)

        
    }
    
    
    
    
   //For Search Bar .. Please ignore this  Code
    private func customDesign(){
       
        self.modernSearchBar.shadowView_alpha = 0.8
        
        //Modify the default icon of suggestionsView's rows
        self.modernSearchBar.searchImage = ModernSearchBarIcon.Icon.none.image
        
        self.modernSearchBar.searchLabel_font = UIFont(name: "Avenir-Light", size: 30)
        self.modernSearchBar.searchLabel_textColor = UIColor.red
        self.modernSearchBar.searchLabel_backgroundColor = UIColor.black
        
        //Modify properties of the searchIcon
        self.modernSearchBar.suggestionsView_searchIcon_height = 40
        self.modernSearchBar.suggestionsView_searchIcon_width = 40
        self.modernSearchBar.suggestionsView_searchIcon_isRound = false
        
        //Modify properties of suggestionsView
        ///Modify the max height of the suggestionsView
        self.modernSearchBar.suggestionsView_maxHeight = 1000
        ///Modify properties of the suggestionsView
        self.modernSearchBar.suggestionsView_backgroundColor = UIColor.brown
        self.modernSearchBar.suggestionsView_contentViewColor = UIColor.yellow
        self.modernSearchBar.suggestionsView_separatorStyle = .singleLine
        self.modernSearchBar.suggestionsView_selectionStyle = UITableViewCellSelectionStyle.gray
        self.modernSearchBar.suggestionsView_verticalSpaceWithSearchBar = 10
        self.modernSearchBar.suggestionsView_spaceWithKeyboard = 20
    }
    
    private func makingSearchBarAwesome(){
        //self.modernSearchBar.backgroundImage = UIImage()
        self.modernSearchBar.layer.borderWidth = 0
        self.modernSearchBar.layer.borderColor = UIColor(red: 181, green: 240, blue: 210, alpha: 1).cgColor
    }



}

