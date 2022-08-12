//
//  ViewModelType.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
