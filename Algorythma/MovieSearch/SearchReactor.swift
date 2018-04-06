//
//  SearchReactor.swift
//  Algorythma
//
//  Created by Amit Mishra on 26/03/18.
//  Copyright © 2018 Amit Mishra. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import Moya
final class SearchReactor: Reactor {
    let repositoryMovie : Observable<[MoviesModel]> = Observable.empty()
    lazy var fetcher: Fetcher = {
        let fetcher = Fetcher()
        return fetcher
    }()
    enum Action {
        case updateSearchSuggestion(String?)
        case showMovieFromSearch(String?)
        case showMovieFromPrviousSuccessfullSearch(String?)
    }
    
    enum Mutation {
        case setQuery(String?)
        case setRepos([MoviesModel])
        case setLoading(Bool)
    }
    
    struct State {
        var query: String?
        var repos: [MoviesModel] = []
        var nextPage: Int?
        var isLoading: Bool? = false
    
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateSearchSuggestion(query):
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
             self.searchMovies(searhText: "Batman")
                    .takeUntil(self.action.filter(isUpdateQueryAction))
                    .map { Mutation.setRepos($0) },
                ])
            
        case let .showMovieFromSearch(query):
            guard !self.currentState.isLoading! else { return Observable.empty() } // prevent from multiple requests
            return .concat([
                // 1) set loading status to true
                Observable.just(Mutation.setLoading(true)),
                
                // 2) call API and add movies
              self.searchMovies(searhText: query!) .takeUntil(self.action.filter(isUpdateQueryAction))
                    .map{
                        Mutation.setRepos($0)
                }.do(onCompleted:{self.saveSearchToDb(searchText: query!).takeUntil(self.action.filter(self.isUpdateQueryAction)).map{
                    Mutation.setQuery($0)}
                }),
             // Save to Data base
           
                
                // 3) set loading status to false
                Observable.just(Mutation.setLoading(false)),
                ])
            
         /* Boiler Plate Code for Search From Core Data stored Previous result also But As I use a third Party Search Bar So Tough to implement with that
             */
        case .showMovieFromPrviousSuccessfullSearch(_):
            guard !self.currentState.isLoading! else { return Observable.empty() } // prevent from multiple requests
            return Observable.concat([
                // 1) set loading status to true
                Observable.just(Mutation.setLoading(true)),
                
                // 2) call API and append repos
                self.searchMovies(searhText: "Batman").takeUntil(self.action.filter(isUpdateQueryAction))
                    .map{ Mutation.setRepos($0) },
                
                // 3) set loading status to false
                Observable.just(Mutation.setLoading(false)),
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
            
        case let .setRepos(repos):
            var newState = state
            newState.repos = repos
            return newState
            
        case let .setLoading(isLoadingstill):
            var newState = state
            newState.isLoading = isLoadingstill
            return newState
            
        }
        
    }
    
    private func isUpdateQueryAction(_ action: Action) -> Bool {
        if case .updateSearchSuggestion = action {
            return true
        } else {
            return false
        }
    }
    
    public func searchMovies(searhText: String) -> Observable<[MoviesModel]> {
        return  NetworkAdapterSigned.request(.searchMovie(searchText: searhText)).asObservable().map(to: MovieSearchModel.self).map{
            moviesDetail -> [MoviesModel] in
            return moviesDetail.movies
        }
}
    
    //Database Operation To Save Successful Search Result
    private func saveSearchToDb(searchText:String)->Observable<String> {
      
        let result:[RecentlySearch] = DBHelper.fetchEntity("RecentlySearch", inContext: fetcher.dataStack.mainContext) as! [RecentlySearch]
        let found = result.contains(where: {$0.searchText == searchText})
        if(self.currentState.repos.count > 0 && !found){
        let task = DBHelper.insertEntity("RecentlySearch", dataStack: fetcher.dataStack)
        task.setValue(searchText, forKey: "searchText")
            try! fetcher.dataStack.mainContext.save()
        }
       return Observable.just(searchText)

    }
   
}

