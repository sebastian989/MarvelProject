//
//  CharaterListViewModel.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 23/01/22.
//

import Foundation
import Combine

protocol ViewPaginationDelegate: class {
    func onFetchCompleted(with indexToReload: [Int]?)
    func onFetchFailed(with reason: String)
}

class CharacterListViewModel {
    
    weak var pagingDelegate: ViewPaginationDelegate?
    var totalCharacters = 0
    var numberOfCharacters: Int { characters.count }
    
    private var characters = [Character]()
    private let repository: CharacterRepository
    private var currentPage = 1
    private let elementsPerPage = 20
    private var isFetchInProgress = false
    
    required init(repository: CharacterRepository = CharacterRepositoryImpl()) {
        self.repository = repository
        loadCharacters()
    }
    
    func loadCharacters() {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        let offset = (currentPage - 1) * elementsPerPage
        repository.getCharacters(limit: elementsPerPage, offset: offset) { [weak self] (response) in
            self?.validateCharactersResponse(response)
            self?.isFetchInProgress = false
        }
    }
    
    func character(at index: Int) -> Character {
        return characters[index]
    }
    
    private func validateCharactersResponse(_ response: Result<CharacterResponseDTO, ApiError>) {
        switch response {
        case .success(let response):
            totalCharacters = response.data.total
            characters.append(contentsOf: response.data.results)
            if currentPage > 1 {
                let indexToReload = calculateIndexToReload(from: response.data.results)
                pagingDelegate?.onFetchCompleted(with: indexToReload)
            } else {
                pagingDelegate?.onFetchCompleted(with: .none)
            }
            currentPage += 1
            
        case .failure(let error):
            print(error.localizedDescription)
            pagingDelegate?.onFetchFailed(with: error.reason)
        }
    }
    
    private func calculateIndexToReload(from newCharacters: [Character]) -> [Int] {
        let startIndex = characters.count - newCharacters.count
        let endIndex = startIndex + newCharacters.count
        
        return (startIndex..<endIndex).map { $0 }
    }
}
